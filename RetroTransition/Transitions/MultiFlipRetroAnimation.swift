import UIKit

public class MultiFlipRetroTransition : RetroTransition {
    public var stepDistance : CGFloat = 0.333
    public var animationStepTime : TimeInterval = 0.333
    
    private func flipTo(transitionContext: UIViewControllerContextTransitioning, view: UIView, scale: CGFloat) {
        var transform = view.layer.transform
        view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        transform = CATransform3DRotate(transform, CGFloat(Double.pi), 0.0, 1.0, 0.0)
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        
        let nextScale = scale - stepDistance
        
        UIView.animate(withDuration: animationStepTime, delay: 0.0, options: [.curveEaseInOut], animations: {
            view.layer.transform = transform
        }) { [weak self] (_) in
            if nextScale > 0 {
                self?.flipTo(transitionContext: transitionContext, view: view, scale: nextScale)
            } else {
                transitionContext.completeTransition(true)
                view.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(1.0 / stepDistance) * animationStepTime
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let fromContainer = UIView()
        fromContainer.frame = fromVC.view.bounds
        containerView.addSubview(fromContainer)
        
        fromContainer.addSubview(fromVC.view)
        
        flipTo(transitionContext: transitionContext, view: fromVC.view, scale: 1.0 - stepDistance)
    }
}
