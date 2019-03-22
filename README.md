
<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/logo.png"/>

# Retro Transition

Fun implementations of UIViewControllerAnimatedTransitioning for 90s inspired transitions between view controllers.

<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/circles.gif" width="220" height="434"/>
<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/clock.gif" width="220" height="434"/>
<img src="https://raw.githubusercontent.com/wcgray/RetroTransition/master/Images/squares.gif" width="220" height="434"/>

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

## License

MIT
