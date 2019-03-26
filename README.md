
<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/logo.png"/>

# Retro Transition

Fun implementations of UIViewControllerAnimatedTransitioning for 90s inspired transitions between view controllers.

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/circles.gif" width="220" height="434"/> <img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/clock.gif" width="220" height="434"/> <img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/squares.gif" width="220" height="434"/>

## Installation

Use CocoaPods:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'RetroTransition'
```

Or drag the RetroTransition project into your xcodeproj and make RetroTransition a target dependency.

## Usage

Import RetroTransition:

```swift
import RetroTransition
```

Then use it:

```swift
let vc = UIViewController()
navigationController?.pushViewController(vc, withRetroTransition: ClockRetroTransition())
```

## Transitions

### SwingInRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/swing_in.gif" width="220" height="434"/>

### SplitFromCenterRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/xmiddle.gif" width="220" height="434"/>

### ShrinkingGrowingDiamondsRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/shrinkgrowdiamond.gif" width="220" height="434"/>

### CollidingDiamondsRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/colliding-diamonds.gif" width="220" height="434"/>

### StraightLineRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/vertical-slide.gif" width="220" height="434"/>

### AngleLineRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/angle-slide.gif" width="220" height="434"/>

### MultiFlipRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/multiflip.gif" width="220" height="434"/>

### ImageRepeatingRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/imagedups.gif" width="220" height="434"/>

### ClockRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/clock.gif" width="220" height="434"/>

### CircleRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/circle.gif" width="220" height="434"/>

### RectanglerRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/rectangles.gif" width="220" height="434"/>

### TiledFlipRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/squares.gif" width="220" height="434"/>

### FlipRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/flip.gif" width="220" height="434"/>

### MultiCircleRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/circles.gif" width="220" height="434"/>

### CrossFadeRetroTransition

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/crossfade.gif" width="220" height="434"/>

## Author

wcgray, cam@tinsoldiersoftware.com

## License

MIT
