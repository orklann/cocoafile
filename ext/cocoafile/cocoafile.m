#import <Cocoa/Cocoa.h>
#include "cocoafile.h"

VALUE rb_mCocoafile;
VALUE rb_mFile;

VALUE choose_file(VALUE self, VALUE rb_ext);

RUBY_FUNC_EXPORTED void
Init_cocoafile(void)
{
  rb_mCocoafile = rb_define_module("Cocoafile");
  rb_mFile = rb_define_class_under(rb_mCocoafile, "File", rb_cObject);
  rb_define_method(rb_mFile, "choose_file", choose_file, 1);
}

VALUE choose_file(VALUE self, VALUE rb_ext) {
  // Ensure the input is an array of strings
  Check_Type(rb_ext, T_ARRAY);
  NSMutableArray *extensions = [NSMutableArray array];

  // Convert each Ruby string (extension) to NSString and add to the list
  long len = RARRAY_LEN(rb_ext);
  for (long i = 0; i < len; i++) {
    VALUE ext_val = rb_ary_entry(rb_ext, i);
    Check_Type(ext_val, T_STRING);
    const char *ext_cstr = StringValueCStr(ext_val);
    NSString *ext = [NSString stringWithUTF8String:ext_cstr];
    
    UTType *lumioseType = [UTType typeWithFilenameExtension:ext];
    if (lumioseType) {
      [extensions addObject:lumioseType];
    }
  }


  NSOpenPanel *panel = [NSOpenPanel openPanel];

  panel.allowedContentTypes = extensions;
  panel.canChooseFiles = YES;
  panel.canChooseDirectories = NO;
  panel.allowsMultipleSelection = NO;
  panel.prompt = @"Open";

  // Run synchronously
  NSInteger result = [panel runModal];

  if (result == NSModalResponseOK) {
    NSURL *selectedFile = panel.URL;
    NSString *path = selectedFile.path;

    // Convert NSString → Ruby String
    return rb_str_new_cstr([path UTF8String]);
  }

  // User cancelled: return nil
  return Qnil;
}
