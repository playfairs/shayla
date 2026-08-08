#import <AppKit/AppKit.h>
#include "shayla/ui/overlay.hpp"
#include <memory>
#include <string>

@interface OverlayPanel : NSPanel
@end
@implementation OverlayPanel
- (BOOL)canBecomeKeyWindow {
  return NO;
}
- (BOOL)canBecomeMainWindow {
  return NO;
}
@end

namespace shayla::ui {
class MacOverlay : public Overlay {
public:
  MacOverlay() {
    screen = [NSScreen mainScreen];
    textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
    textField.bezeled = NO;
    textField.drawsBackground = NO;
    textField.editable = NO;
    textField.selectable = NO;
    textField.bordered = NO;
    textField.textColor = [NSColor labelColor];
    textField.alignment = NSTextAlignmentCenter;
    textField.font = [NSFont systemFontOfSize:18 weight:NSFontWeightMedium];
    contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
    [contentView addSubview:textField];
    panel = [[OverlayPanel alloc] initWithContentRect:NSMakeRect(0, 0, 1, 1)
                                            styleMask:NSWindowStyleMaskBorderless
                                              backing:NSBackingStoreBuffered
                                                defer:NO];
    panel.opaque = NO;
    panel.backgroundColor = [NSColor clearColor];
    panel.level = NSStatusWindowLevel;
    panel.ignoresMouseEvents = YES;
    panel.hidesOnDeactivate = NO;
    panel.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces
                             | NSWindowCollectionBehaviorFullScreenAuxiliary
                             | NSWindowCollectionBehaviorStationary
                             | NSWindowCollectionBehaviorIgnoresCycle;
    panel.hasShadow = NO;
    panel.titleVisibility = NSWindowTitleHidden;
    panel.titlebarAppearsTransparent = YES;
    [panel setContentView:contentView];
  }
  ~MacOverlay() override = default;
  void show() override {
    [panel orderFrontRegardless];
  }
  void setText(std::string_view text) override {
    std::string buffer{text};
    NSString* string = [[NSString alloc] initWithBytes:buffer.data()
                                                 length:buffer.size()
                                               encoding:NSUTF8StringEncoding];
    textField.stringValue = string ?: @"";
    [textField sizeToFit];
    NSRect frame = textField.frame;
    [textField setFrameOrigin:NSMakePoint(0, 0)];
    [contentView setFrame:NSMakeRect(0, 0, frame.size.width, frame.size.height)];
    [panel setContentSize:frame.size];
    setPosition(currentPosition);
  }
  void setPosition(OverlayPosition position) override {
    currentPosition = position;
    NSRect visibleFrame = screen.visibleFrame;
    NSRect windowFrame = panel.frame;
    if (position == OverlayPosition::TopCenter) {
      double x = visibleFrame.origin.x + (visibleFrame.size.width - windowFrame.size.width) / 2.0;
      double y = visibleFrame.origin.y + visibleFrame.size.height - windowFrame.size.height - 80.0;
      [panel setFrameOrigin:NSMakePoint(x, y)];
    }
  }
private:
  OverlayPanel* panel = nil;
  NSView* contentView = nil;
  NSTextField* textField = nil;
  NSScreen* screen = nil;
  OverlayPosition currentPosition = OverlayPosition::TopCenter;
};

std::unique_ptr<Overlay> createPlatformOverlay() {
  return std::make_unique<MacOverlay>();
}
}
