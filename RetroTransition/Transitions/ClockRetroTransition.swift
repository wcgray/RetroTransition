import UIKit

class ClockRetroTransition : RetroTransition {
    override func defaultDuration() -> TimeInterval {
        return 0.7
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
        
        let radius = 2 * sqrt(pow(fromVC.view.bounds.size.height / 2, 2) + pow(fromVC.view.bounds.size.width / 2, 2))
        let circleCenter = CGPoint(x: radius ,y: radius)
        
        let circleFromToAngle : ((Double) -> (CGPath)) = { endAngle in
            let path = UIBezierPath()
            path.move(to: circleCenter)
            path.addLine(to: circleCenter)
            path.addArc(withCenter: circleCenter, radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(endAngle), clockwise: true)
            
            return path.cgPath
        }
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.position = CGPoint(x: (fromVC.view.frame.size.width / 2) - (radius / 2), y: (fromVC.view.frame.size.height / 2) - (radius / 2))
        shapeLayer.path = circleFromToAngle(2.0 * Double.pi)
        
        fromVC.view.layer.mask = shapeLayer
        
        let cleanup : (() -> (Void)) = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
            fromVC.view.removeFromSuperview()
        }
        
        let runAnimationToPathWithCompletion : ((CGPath, CGPath, @escaping () -> (Void)) -> (Void)) = { pathStart, pathEnd, completion in
            let animation : RetroBasicAnimation = RetroBasicAnimation()
            animation.keyPath = "path"
            animation.duration = self.duration / 4
            animation.fromValue = pathStart
            animation.toValue = pathEnd
            animation.autoreverses = false
            animation.onFinish = {
                completion()
            }
            shapeLayer.add(animation, forKey: "path")
        }
        
        runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 2.0), circleFromToAngle(Double.pi * 1.50001), {
            runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 1.5), circleFromToAngle(Double.pi * 1.00001), {
                runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 1.0), circleFromToAngle(Double.pi * 0.50001), {
                    runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 0.5), circleFromToAngle(Double.pi * 0.0001), {
                        cleanup()
                    })
                })
            })
        })
    }
}
