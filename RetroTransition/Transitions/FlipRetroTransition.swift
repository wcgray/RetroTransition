import UIKit

class FlipRetroTransition : RetroTransition {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .curveEaseInOut]
        
        UIView.transition(with: containerView, duration: self.duration, options: transitionOptions, animations: {
            containerView.addSubview(toVC.view)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
