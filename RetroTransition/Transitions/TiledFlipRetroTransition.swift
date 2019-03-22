import UIKit

public class TiledFlipRetroTransition : RetroTransition {
    private func flipSegment(toViewImage: UIImage, fromViewImage: UIImage, delay: TimeInterval, rect: CGRect, animationTime: CGFloat, parentView: UIView) {
        guard let cgToImage = toViewImage.cgImage,
            let cgFromImage = fromViewImage.cgImage,
            let toImageRef = cgToImage.cropping(to: CGRect(x: toViewImage.scale * rect.origin.x, y: toViewImage.scale * rect.origin.y,width: toViewImage.scale * rect.size.width, height: toViewImage.scale * rect.size.height)),
            let fromImageRef = cgFromImage.cropping(to: CGRect(x: fromViewImage.scale * rect.origin.x, y: fromViewImage.scale * rect.origin.y,width: fromViewImage.scale * rect.size.width, height: fromViewImage.scale * rect.size.height)) else {
            return
        }
        
        let toImage = UIImage.init(cgImage: toImageRef)
        let toImageView = UIImageView()
        toImageView.clipsToBounds = true
        toImageView.frame = rect
        toImageView.image = toImage
        
        let fromImage = UIImage.init(cgImage: fromImageRef)
        let fromImageView = UIImageView()
        fromImageView.clipsToBounds = true
        fromImageView.frame = rect
        fromImageView.image = fromImage
        
        let containerView = UIView()
        containerView.frame = fromImageView.frame
        containerView.backgroundColor = UIColor.clear
        
        fromImageView.frame.origin = CGPoint.zero
        toImageView.frame.origin = CGPoint.zero
        
        containerView.addSubview(fromImageView)
        parentView.addSubview(containerView)
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .curveEaseInOut]
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: containerView, duration: TimeInterval(animationTime), options: transitionOptions, animations: {
                containerView.addSubview(toImageView)
                fromImageView.removeFromSuperview()
            })
        })
    }
    
    override func defaultDuration() -> TimeInterval {
        return 1.0
    }
    
    private func snapshot(_ view : UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotToVc = snapshot(toVC.view),
            let snapshotFromVc = snapshot(fromVC.view)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        fromVC.view.removeFromSuperview()
        
        let parentView = UIView()
        parentView.backgroundColor = UIColor.clear
        parentView.frame = fromVC.view.frame
        containerView.addSubview(parentView)
        
        let cleanup = {
            containerView.addSubview(toVC.view)
            parentView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let squareSizeWidth : CGFloat = fromVC.view.bounds.size.width / 5
        let squareSizeHeight : CGFloat = fromVC.view.bounds.size.height / 10
        
        let numRows = 1 + Int(toVC.view.bounds.size.width / squareSizeWidth)
        let numCols = 1 + Int(toVC.view.bounds.size.height / squareSizeWidth)
        for x in (0...numRows) {
            for y in (0...numCols) {
                let rect = CGRect(x: (CGFloat(x) * squareSizeWidth),y: (CGFloat(y) * squareSizeHeight), width:squareSizeWidth, height: squareSizeHeight)
                
                let randomPercent = Float(arc4random()) / Float(UINT32_MAX)
                let delay = TimeInterval(Float(self.duration * 0.5) * randomPercent)
                
                flipSegment(toViewImage: snapshotToVc, fromViewImage: snapshotFromVc, delay: delay, rect: rect, animationTime: CGFloat(self.duration / 2), parentView: parentView)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.duration), execute: {
            cleanup()
        })
    }
}
