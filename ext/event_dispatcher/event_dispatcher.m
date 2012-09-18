#import "event_dispatcher.h"

static VALUE rb_cEventDispatcher;

struct EventDispatcherObject {};

void cEventDispatcher_free(void *ptr) {
  free(ptr);
}

VALUE createInstance() {
  struct EventDispatcherObject *obj;

  obj = malloc(sizeof(struct EventDispatcherObject));

  return Data_Wrap_Struct(rb_cEventDispatcher, 0, cEventDispatcher_free, obj);
}

CGEventType getEventTypeFromValue(VALUE value)
{
  const char *typeStr;
  CGEventType type;

  typeStr = StringValuePtr(value);

  if(strcmp(typeStr, "mouse_down") == 0) {
    type = kCGEventLeftMouseDown;
  } else if(strcmp(typeStr, "mouse_up") == 0) {
    type = kCGEventLeftMouseUp;
  } else if(strcmp(typeStr, "mouse_move") == 0) {
    type = kCGEventMouseMoved;
  } else {
    type = kCGEventNull;
  }

  return type;
}

CGScrollEventUnit getScrollEventUnitFromValue(VALUE value)
{
  const char *unitStr;
  CGScrollEventUnit unit;

  unitStr = StringValuePtr(value);

  if(strncmp(unitStr, "pix", 3) == 0) {
    // accepts pixel, pixels, pix
    unit = kCGScrollEventUnitPixel;
  } else if(strncmp(unitStr, "line", 4) == 0) {
    // accepts line, lines
    unit = kCGScrollEventUnitLine;
  } else {
    rb_warn("Given unit `%s' is invalid. pixel or line is allowed.", unitStr);
    unit = kCGScrollEventUnitPixel;
  }

  return unit;
}

CGMouseButton getMouseButtonFromValue(VALUE value)
{
  // http://developer.apple.com/library/mac/#documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html
  //
  // enum _CGMouseButton {
  //     kCGMouseButtonLeft = 0,
  //     kCGMouseButtonRight = 1,
  //     kCGMouseButtonCenter = 2
  // };
  // typedef uint32_t CGMouseButton;
  //
  return (CGMouseButton)NUM2INT(value);
}

static VALUE cEventDispatcher_new(int argc, VALUE *argv, VALUE klass)
{
  VALUE obj;

  obj = createInstance();

  return obj;
}

static VALUE cEventDispatcher_dispatchMouseEvent(int argc, VALUE *argv, VALUE self)
{
  VALUE x, y, button, type;
  CGEventRef event;

  rb_scan_args(argc, argv, "4", &x, &y, &button, &type);

  event = CGEventCreateMouseEvent(
                                  NULL,
                                  getEventTypeFromValue(rb_funcall(type, rb_intern("to_s"), 0)),
                                  CGPointMake(NUM2INT(x), NUM2INT(y)),
                                  getMouseButtonFromValue(button));

  CGEventPost(kCGHIDEventTap, event);
  CFRelease(event);

  return Qnil;
}

// http://stackoverflow.com/questions/6126226/how-to-create-an-nsevent-of-type-nsscrollwheel
// wheel_cnt: 1 - Y, 2 - Y-X, 3 - Y-X-Z
static VALUE cEventDispatcher_dispatchScrollWheelEvent(int argc, VALUE *argv, VALUE self)
{
  VALUE unit, wheel_cnt, scroll_y, scroll_x, scroll_z;
  CGEventRef event;

  rb_scan_args(argc, argv, "5", &unit, &wheel_cnt, &scroll_y, &scroll_x, &scroll_z);

  event = CGEventCreateScrollWheelEvent(
                                  NULL,
                                  getScrollEventUnitFromValue(rb_funcall(unit, rb_intern("to_s"), 0)),
                                  NUM2INT(wheel_cnt),
                                  NUM2INT(scroll_y),
                                  NUM2INT(scroll_x),
                                  NUM2INT(scroll_z));

  CGEventPost(kCGHIDEventTap, event);
  CFRelease(event);

  return Qnil;
}

// http://forums.macrumors.com/showthread.php?t=780577
static VALUE cEventDispatcher_dispatchKeyboardEvent(int argc, VALUE *argv, VALUE self)
{
  VALUE keycode, keydown;
  CGEventRef event;

  rb_scan_args(argc, argv, "2", &keycode, &keydown);

  event = CGEventCreateKeyboardEvent(
                                  NULL,
                                  (CGKeyCode)NUM2INT(keycode),
                                  (bool)NUM2INT(keydown));

  CGEventPost(kCGHIDEventTap, event);
  CFRelease(event);

  return Qnil;
}

void Init_event_dispatcher(void){
  VALUE rb_mMac, rb_cRobot;

  rb_mMac = rb_define_module("Mac");
  rb_cRobot = rb_define_class_under(rb_mMac, "Robot", rb_cObject);
  rb_cEventDispatcher = rb_define_class_under(rb_cRobot, "EventDispatcher", rb_cObject);
  rb_define_singleton_method(rb_cEventDispatcher, "new", cEventDispatcher_new, -1);
  rb_define_method(rb_cEventDispatcher, "dispatchMouseEvent", cEventDispatcher_dispatchMouseEvent, -1);
  rb_define_method(rb_cEventDispatcher, "dispatchScrollWheelEvent", cEventDispatcher_dispatchScrollWheelEvent, -1);
  rb_define_method(rb_cEventDispatcher, "dispatchKeyboardEvent", cEventDispatcher_dispatchKeyboardEvent, -1);
}
