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

class ClockRetroTransition : RetroTransition {
    required init(duration : TimeInterval = 1.0) {
        super.init()
        self.duration = duration
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

class CircleRetroTransition : RetroTransition {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let radius = sqrt(pow(fromVC.view.bounds.size.height / 2, 2) + pow(fromVC.view.bounds.size.width / 2, 2))
        let circlePathStart = UIBezierPath(arcCenter: CGPoint(x: fromVC.view.bounds.size.width / 2,y: fromVC.view.bounds.size.height / 2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePathEnd = UIBezierPath(arcCenter: CGPoint(x: fromVC.view.bounds.size.width / 2,y: fromVC.view.bounds.size.height / 2), radius: CGFloat(1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = circlePathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        shapeLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        fromVC.view.layer.mask = shapeLayer
        
        let animation : RetroBasicAnimation = RetroBasicAnimation()
        animation.keyPath = "path"
        animation.duration = self.duration
        animation.fromValue = circlePathStart.cgPath
        animation.toValue = circlePathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
}

class CrossFadeRetroTransition : RetroTransition {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        fromVC.view.alpha = 1.0
        toVC.view.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.duration, animations: {
            fromVC.view.alpha = 0.0
            toVC.view.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.alpha = 1.0
        }
    }
}

internal class RetroTransition : NSObject {
    public var duration: TimeInterval!
    required init(duration : TimeInterval = 0.33) {
        self.duration = duration
        super.init()
    }
}

extension RetroTransition : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, withRetroTransition transition: RetroTransition) {
        RetroTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        pushViewController(viewController, animated: true)
    }
    
    func popViewControllerRetroTransition(_ transition: RetroTransition) -> UIViewController? {
        RetroTransitionNavigationDelegate.shared.pushTransition(transition, forNavigationController: self)
        return popViewController(animated: true)
    }
}
