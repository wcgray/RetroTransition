import UIKit

class RetroBasicAnimation : CABasicAnimation, CAAnimationDelegate {
    public var onFinish : (() -> (Void))?
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onFinish = onFinish {
            onFinish()
        }
    }
}

public class RetroTransition : NSObject {
    public var duration: TimeInterval = 0.33
    required public init(duration : TimeInterval? = nil) {
        super.init()
        self.duration = duration ?? defaultDuration()
    }
    
    func defaultDuration() -> TimeInterval {
        return 0.33
    }
}

extension RetroTransition : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

internal class RetroTransitionNavigationDelegate : NSObject, UINavigationControllerDelegate {
    static let shared = RetroTransitionNavigationDelegate()
    var transitions : [RetroTransition] = []
    var oldNavigationDelegate : UINavigationControllerDelegate?
    
    func pushTransition(_ transition: RetroTransition, forNavigationController navigationController: UINavigationController) {
        transitions.append(transition)
        oldNavigationDelegate = navigationController.delegate
        
        navigationController.delegate = RetroTransitionNavigationDelegate.shared
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = transitions.popLast()
        
        navigationController.delegate = oldNavigationDelegate
        
        return transition
    }
}

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, withRetroTransition transition: RetroTransition) {
        RetroTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        pushViewController(viewController, animated: true)
    }
    
    func popViewControllerRetroTransition(_ transition: RetroTransition) -> UIViewController? {
        RetroTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        return popViewController(animated: true)
    }
}
