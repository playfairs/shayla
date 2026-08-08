#pragma once
#include <memory>
#include <string_view>
namespace shayla::ui {
enum class OverlayPosition {
  TopCenter,
};
class Overlay {
public:
  virtual ~Overlay() = default;
  virtual void show() = 0;
  virtual void setText(std::string_view text) = 0;
  virtual void setPosition(OverlayPosition position) = 0;
};
std::unique_ptr<Overlay> createPlatformOverlay();
}
