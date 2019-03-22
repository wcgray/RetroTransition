import UIKit

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
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = circlePathStart.cgPath
        animation.toValue = circlePathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
}
