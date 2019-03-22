# Retro Transition
Fun implementations of UIViewControllerAnimatedTransitioning for 90s inspired transitions between view controllers.

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
