import UIKit

public class SplitFromCenterRetroTransition : CollidingDiamondsRetroTransition {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let diamondSize = CGSize.init(width: fromVC.view.bounds.size.width * 2, height: fromVC.view.bounds.size.height * 2)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        
        let containerLayer = CALayer.init()
        containerLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        containerLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        
        var start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (fromVC.view.bounds.height / 2) - (diamondSize.height / 2))
        var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y - (diamondSize.height / 2)), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (fromVC.view.bounds.height / 2) + (diamondSize.height / 2))
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y + (diamondSize.height / 2)), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: (fromVC.view.bounds.width / 2) + (diamondSize.width / 2), y: fromVC.view.bounds.height / 2)
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x + (diamondSize.width / 2), y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: (fromVC.view.bounds.width / 2) - (diamondSize.width / 2), y: fromVC.view.bounds.height / 2)
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x - (diamondSize.width / 2), y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        fromVC.view.layer.mask = containerLayer
    }
}
