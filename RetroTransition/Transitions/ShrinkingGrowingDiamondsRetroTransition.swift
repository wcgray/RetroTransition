import UIKit

public class ShrinkingGrowingDiamondsRetroTransition : RetroTransition {
    override func defaultDuration() -> TimeInterval {
        return 1.0
    }
    
    private func animatedDiamondPath(startCenter: CGPoint, startSize: CGSize, endSizeLarge: CGSize, endSizeSmall: CGSize, screenBounds: CGRect, completion: (() -> (Void))?) -> CALayer {
        let pathStart = UIBezierPath()
        pathStart.move(to: CGPoint.init(x: startCenter.x - (startSize.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (startSize.height / 2)))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x + (startSize.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (startSize.height / 2)))
        
        let pathStart2 = UIBezierPath()
        pathStart2.move(to: CGPoint.init(x: startCenter.x - (startSize.width / 2), y: startCenter.y))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (startSize.height / 2)))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x + (startSize.width / 2), y: startCenter.y))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (startSize.height / 2)))
        pathStart.append(pathStart2)
        
        pathStart.usesEvenOddFillRule = true
        
        let pathEnd = UIBezierPath()
        pathEnd.move(to: CGPoint.init(x: startCenter.x - (endSizeLarge.width / 2), y: startCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (endSizeLarge.height / 2)))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x + (endSizeLarge.width / 2), y: startCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (endSizeLarge.height / 2)))
        
        let pathEnd2 = UIBezierPath()
        pathEnd2.move(to: CGPoint.init(x: startCenter.x - (endSizeSmall.width / 2), y: startCenter.y))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (endSizeSmall.height / 2)))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x + (endSizeSmall.width / 2), y: startCenter.y))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (endSizeSmall.height / 2)))
        pathEnd.append(pathEnd2)
        
        pathEnd.usesEvenOddFillRule = true
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = pathStart.cgPath
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
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
        
        let diamondSize = fromVC.view.bounds.size
        
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
        
        let start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: diamondSize.height / 2)
        
        let layer = animatedDiamondPath(startCenter: start, startSize: diamondSize, endSizeLarge: CGSize.init(width: diamondSize.width * 2, height: diamondSize.height * 2), endSizeSmall: CGSize.init(width: 1, height: 1), screenBounds: fromVC.view.bounds, completion: completion)
        containerLayer.addSublayer(layer)
        
        toVC.view.layer.mask = containerLayer
    }
}
