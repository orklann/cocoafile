#import <Cocoa/Cocoa.h>
#include "cocoafile.h"

VALUE rb_mCocoafile;
VALUE rb_mFile;

VALUE choose_file(VALUE self);

RUBY_FUNC_EXPORTED void
Init_cocoafile(void)
{
  rb_mCocoafile = rb_define_module("Cocoafile");
  rb_mFile = rb_define_class_under(rb_mCocoafile, "File", rb_cObject);
  rb_define_method(rb_mFile, "choose_file", choose_file, 0);
}

VALUE choose_file(VALUE self) {
  NSOpenPanel *panel = [NSOpenPanel openPanel];

  UTType *lumioseType = [UTType typeWithFilenameExtension:@"lumiose"];
  panel.allowedContentTypes = @[lumioseType];
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
