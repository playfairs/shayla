#import <AppKit/AppKit.h>
#include "shayla/platform/platform.hpp"
#include "shayla/ui/overlay.hpp"
#include <memory>

@interface ApplicationDelegate : NSObject <NSApplicationDelegate>
@end
@implementation ApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender {
  return NO;
}
@end

namespace shayla::platform {
int runApp(int argc, char** argv) {
  @autoreleasepool {
    NSApplication* app = [NSApplication sharedApplication];
    [app setActivationPolicy:NSApplicationActivationPolicyAccessory];
    ApplicationDelegate* delegate = [[ApplicationDelegate alloc] init];
    app.delegate = delegate;
    auto overlay = shayla::ui::createPlatformOverlay();
    overlay->setText("shayla · idle");
    overlay->setPosition(shayla::ui::OverlayPosition::TopCenter);
    overlay->show();
    [app run];
  }
  return 0;
}
}
