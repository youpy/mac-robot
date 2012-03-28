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

void Init_event_dispatcher(void){
  VALUE rb_mMac, rb_cRobot;

  rb_mMac = rb_define_module("Mac");
  rb_cRobot = rb_define_class_under(rb_mMac, "Robot", rb_cObject);
  rb_cEventDispatcher = rb_define_class_under(rb_cRobot, "EventDispatcher", rb_cObject);
  rb_define_singleton_method(rb_cEventDispatcher, "new", cEventDispatcher_new, -1);
  rb_define_method(rb_cEventDispatcher, "dispatchMouseEvent", cEventDispatcher_dispatchMouseEvent, -1);
}
