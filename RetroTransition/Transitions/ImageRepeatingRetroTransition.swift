import Foundation

public class ImageRepeatingRetroTransition : RetroTransition {
    public var imageStepPercent : CGFloat = 0.05
    public var imageStepTime : TimeInterval = TimeInterval(0.2)
    
    private var imageViews : [UIImageView] = []
    
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let numberOfImageViews = Int(0.5 / imageStepPercent)
        return imageStepTime * TimeInterval(numberOfImageViews * 2)
    }
    
    private func removeImageView(transitionContext: UIViewControllerContextTransitioning) {
        let imageView = imageViews.first
        imageView?.removeFromSuperview()
        self.imageViews = Array(imageViews.dropFirst())
        
        if imageViews.count ==  0 {
            transitionContext.completeTransition(true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.imageStepTime, execute: { [weak self] in
            self?.removeImageView(transitionContext: transitionContext)
        })
    }
    
    private func addImageView(transitionContext: UIViewControllerContextTransitioning, fromViewImage: UIImage, imageViewRect: CGRect) {
        let imageView = UIImageView.init(frame: imageViewRect)
        imageView.clipsToBounds = true
        imageView.image = fromViewImage
        transitionContext.containerView.addSubview(imageView)
        imageViews.append(imageView)
        
        let widthStep = transitionContext.containerView.bounds.size.width * imageStepPercent
        let heightStep = transitionContext.containerView.bounds.size.height * imageStepPercent
        
        if (imageViewRect.size.width - (widthStep * 2) <= 0 || imageViewRect.size.height - (heightStep * 2) <= 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.imageStepTime, execute: { [weak self] in
                self?.removeImageView(transitionContext: transitionContext)
            })
            return
        }
        
        let nextImageViewRect = CGRect.init(x: imageViewRect.origin.x + widthStep, y: imageViewRect.origin.y + heightStep, width: imageViewRect.size.width - (widthStep * 2), height: imageViewRect.size.height - (heightStep * 2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.imageStepTime, execute: { [weak self] in
            if let self = self {
                self.addImageView(transitionContext: transitionContext, fromViewImage: fromViewImage, imageViewRect: nextImageViewRect)
            }
        })
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromViewControllerImage = snapshot(fromVC.view)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        addImageView(transitionContext: transitionContext, fromViewImage: fromViewControllerImage, imageViewRect: containerView.bounds)
    }
}

