import UIKit

class MultiCircleRetroTransition : RetroTransition {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let cleanup = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.mask = nil
        }
        
        
        let createRectOutlinePath : ((CGPoint, CGSize, CGFloat, (() -> (Void))?) -> (CAShapeLayer)) = { circleCenter, circleSize, circleRadius, completion in
            let pathStart = UIBezierPath()
            pathStart.addArc(withCenter: circleCenter, radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            let pathEnd = UIBezierPath()
            pathEnd.addArc(withCenter: circleCenter, radius: circleSize.width, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            let rect = CGRect.init(x: circleCenter.x - (circleSize.width / 2), y: circleCenter.y - (circleSize.height / 2), width: circleSize.width, height: circleSize.height)
            
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
            shapeLayer.position = CGPoint(x: (rect.origin.x + rect.size.width) - (circleSize.width / 2), y: (rect.origin.y + rect.size.height) - (circleSize.height / 2))
            shapeLayer.path = pathStart.cgPath
            
            let animation : RetroBasicAnimation = RetroBasicAnimation()
            animation.keyPath = "path"
            animation.duration = self.duration
            animation.fromValue = pathEnd.cgPath
            animation.toValue = pathStart.cgPath
            animation.autoreverses = false
            animation.onFinish = {
                if let completion = completion {
                    completion()
                }
            }
            shapeLayer.add(animation, forKey: "path")
            
            return shapeLayer
        }
        
        guard let view = fromVC.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        let maskLayer = CALayer.init()
        maskLayer.bounds = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        maskLayer.position = CGPoint(x: (view.frame.size.width / 2), y: (view.frame.size.height / 2))
        
        let circleSize = CGSize(width: 20, height: 20)
        for rowIndex in (0..<Int(1 + ceilf(Float(view.bounds.size.height / circleSize.height)))) {
            for colIndex in (0..<Int(2 + ceilf(Float(view.bounds.size.width / circleSize.width)))) {
                let circleCenter = CGPoint(x: (circleSize.width / 2) + (CGFloat(colIndex) * circleSize.width), y: (circleSize.height / 2) + (CGFloat(rowIndex) * circleSize.height))
                
                maskLayer.addSublayer(createRectOutlinePath(circleCenter, circleSize, 1, rowIndex == 0 && colIndex == 0 ? cleanup : nil))
            }
        }
        
        fromVC.view.layer.mask = maskLayer
    }
}
