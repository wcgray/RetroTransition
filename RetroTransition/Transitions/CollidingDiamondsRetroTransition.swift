import UIKit

public class CollidingDiamondsRetroTransition : RetroTransition {
    public enum CollidingDiamondsOrientation {
        case vertical
        case horizontal
    }
    public var orientation : CollidingDiamondsOrientation = .horizontal
    
    override func defaultDuration() -> TimeInterval {
        return 1.0
    }
    
    internal func animatedDiamondPath(startCenter: CGPoint, endCenter : CGPoint, size: CGSize, screenBounds: CGRect, completion: (() -> (Void))?) -> CALayer {
        let pathStart = UIBezierPath()
        pathStart.move(to: CGPoint.init(x: startCenter.x - (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (size.height / 2)))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x + (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (size.height / 2)))
        
        let pathEnd = UIBezierPath()
        pathEnd.move(to: CGPoint.init(x: endCenter.x - (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y - (size.height / 2)))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x + (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y + (size.height / 2)))
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = pathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        shapeLayer.position = CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height / 2)
        
        let animation : RetroBasicAnimation = RetroBasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            if let completion = completion {
                completion()
            }
        }
        shapeLayer.add(animation, forKey: "path")
        
        return shapeLayer
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let diamondSize = CGSize.init(width: fromVC.view.bounds.size.width * 2, height: fromVC.view.bounds.size.height * 2)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        
        let containerLayer = CALayer.init()
        containerLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        containerLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC.view.layer.mask = nil
        }
        
        if (orientation == .vertical) {
            var start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: diamondSize.height / -2)
            var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y + diamondSize.height), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
            containerLayer.addSublayer(layer)
            
            start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (diamondSize.height * 0.5) + fromVC.view.bounds.height)
            layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y - diamondSize.height), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
            containerLayer.addSublayer(layer)
        } else {
            var start = CGPoint.init(x: diamondSize.width / -2, y: fromVC.view.bounds.height / 2)
            var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x + diamondSize.width, y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
            containerLayer.addSublayer(layer)
            
            start = CGPoint.init(x: fromVC.view.bounds.width + (diamondSize.width * 0.5), y: fromVC.view.bounds.height / 2)
            layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x - diamondSize.width, y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
            containerLayer.addSublayer(layer)
        }
        
        
        
        toVC.view.layer.mask = containerLayer
    }
}
