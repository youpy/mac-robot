#import "util.h"

static VALUE mUtil_get_pixel_color(int argc, VALUE *argv, VALUE self)
{
  VALUE x, y;
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  int intX, intY;
  VALUE result;
  CGImageRef image;
  NSBitmapImageRep *bitmap;
  NSColor *color;

  rb_scan_args(argc, argv, "2", &x, &y);

  intX = NUM2INT(x);
  intY = NUM2INT(y);

  CGDirectDisplayID displayID = CGMainDisplayID();
  image = CGDisplayCreateImageForRect(displayID, CGRectMake(intX, intY, 1, 1));
  bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
  CGImageRelease(image);
  color = [bitmap colorAtX:0 y:0];

  result = rb_ary_new();
  rb_ary_push(result, rb_float_new((float)[color redComponent]));
  rb_ary_push(result, rb_float_new((float)[color greenComponent]));
  rb_ary_push(result, rb_float_new((float)[color blueComponent]));
  rb_ary_push(result, rb_float_new((float)[color alphaComponent]));

  [bitmap release];
  [pool release];

  return result;
}

static VALUE mUtil_get_display_pixel_size(int argc, VALUE *argv, VALUE self)
{
  int width, height;
  VALUE result;

  width = (int)CGDisplayPixelsWide((CGDirectDisplayID)0);
  height = (int)CGDisplayPixelsHigh((CGDirectDisplayID)0);

  result = rb_ary_new();
  rb_ary_push(result, INT2NUM(width));
  rb_ary_push(result, INT2NUM(height));

  return result;
}

static VALUE mUtil_get_mouse_current_location(int argc, VALUE *argv, VALUE self)
{
  VALUE result;
  CGEventRef event;

  event = CGEventCreate(NULL);
  CGPoint loc = CGEventGetLocation(event);

  result = rb_ary_new();
  rb_ary_push(result, INT2NUM(loc.x));
  rb_ary_push(result, INT2NUM(loc.y));

  return result;
}

void Init_util(void){
  VALUE rb_mMac, rb_cRobot, rb_mUtil;

  rb_mMac = rb_define_module("Mac");
  rb_cRobot = rb_define_class_under(rb_mMac, "Robot", rb_cObject);
  rb_mUtil = rb_define_module_under(rb_cRobot, "Util");
  rb_define_singleton_method(rb_mUtil, "get_pixel_color", mUtil_get_pixel_color, -1);
  rb_define_singleton_method(rb_mUtil, "get_display_pixel_size", mUtil_get_display_pixel_size, -1);
  rb_define_singleton_method(rb_mUtil, "get_mouse_current_location", mUtil_get_mouse_current_location, -1);
}
