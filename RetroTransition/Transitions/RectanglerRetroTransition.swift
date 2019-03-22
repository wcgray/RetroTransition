import UIKit

class RectanglerRetroTransition : RetroTransition {
    static let RectangleGrowthDistance : CGFloat = 60
    
    private static func rectMovedIn(_ rect :CGRect, magnitude: CGFloat) -> CGRect {
        return CGRect.init(x: rect.origin.x + magnitude, y: rect.origin.y + magnitude, width: rect.size.width - magnitude * 2, height: rect.size.height - magnitude * 2)
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        func createRectOutlinePath(_ outerRect: CGRect, completion: (() -> (Void))? = nil) -> CAShapeLayer? {
            let magnitude = (RectanglerRetroTransition.RectangleGrowthDistance * 0.2)
            if (RectanglerRetroTransition.RectangleGrowthDistance >= outerRect.size.width || RectanglerRetroTransition.RectangleGrowthDistance >= outerRect.size.height) {
                return nil
            }
            let innerRect = RectanglerRetroTransition.rectMovedIn(outerRect, magnitude: magnitude)
            if (RectanglerRetroTransition.RectangleGrowthDistance >= innerRect.size.width || RectanglerRetroTransition.RectangleGrowthDistance >= innerRect.size.height) {
                return nil
            }
            
            let path = UIBezierPath(rect: outerRect)
            path.append(UIBezierPath(rect: innerRect))
            path.usesEvenOddFillRule = true
            
            let finalPath = UIBezierPath(rect: outerRect)
            finalPath.append(UIBezierPath(rect: RectanglerRetroTransition.rectMovedIn(innerRect, magnitude: RectanglerRetroTransition.RectangleGrowthDistance)))
            finalPath.usesEvenOddFillRule = true
            
            let runAnimationToPathWithCompletion : ((CGPath, CAShapeLayer, (() -> (Void))?) -> (Void)) = { pathEnd, layer, completion in
                let animation : RetroBasicAnimation = RetroBasicAnimation()
                animation.keyPath = "path"
                animation.duration = self.duration
                animation.fromValue = pathEnd
                animation.toValue = path.cgPath
                animation.autoreverses = false
                animation.onFinish = {
                    if let completion = completion {
                        completion()
                    }
                }
                layer.add(animation, forKey: "path")
            }
            
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: outerRect.size.width, height: outerRect.size.height)
            shapeLayer.position = CGPoint(x: outerRect.size.width / 2, y: outerRect.size.height / 2)
            shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
            shapeLayer.path = path.cgPath
            
            runAnimationToPathWithCompletion(finalPath.cgPath, shapeLayer, completion);
            
            return shapeLayer
        }
        
        let cleanup : (() -> (Void)) = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
            fromVC.view.removeFromSuperview()
        }
        
        let maskLayer = CALayer.init()
        maskLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        maskLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        for i in (0..<8) {
            let magnitude = CGFloat(i) * RectanglerRetroTransition.RectangleGrowthDistance
            if magnitude <= fromVC.view.bounds.width && magnitude <= fromVC.view.bounds.height {
                let startRect = RectanglerRetroTransition.rectMovedIn(fromVC.view.bounds, magnitude: magnitude)
                if let sublayer = createRectOutlinePath(startRect, completion: cleanup) {
                    maskLayer.addSublayer(sublayer)
                }
            }
        }
        
        fromVC.view.layer.mask = maskLayer
        
        let animation : RetroBasicAnimation = RetroBasicAnimation()
        animation.keyPath = "opacity"
        animation.duration = self.duration
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.autoreverses = false
        fromVC.view.layer.add(animation, forKey: "path")
    }
}
