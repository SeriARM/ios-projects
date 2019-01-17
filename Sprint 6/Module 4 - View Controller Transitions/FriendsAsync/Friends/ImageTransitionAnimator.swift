//
//  ImageTransitionAnimator.swift
//  Friends
//
//  Created by Sergey Osipyan on 1/10/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

protocol LabelProviding {
    var friendName: UILabel! { get }
    var friendImage: UIImageView! { get }
}

typealias LabelProvidingVC = LabelProviding & UIViewController

class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        
        guard let fromTVC = transitionContext.viewController(forKey: .from) as? LabelProvidingVC,
        let toDVC = transitionContext.viewController(forKey: .to) as? LabelProvidingVC,
            let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        let toViewEndFrame = transitionContext.finalFrame(for: toDVC)
        containerView.addSubview(toView)
        toView.frame = toViewEndFrame
        toView.alpha = 0.0
        let sourceImage = fromTVC.friendImage!
        let sourceLabel = fromTVC.friendName!
        sourceLabel.alpha = 0.0
        sourceImage.alpha = 0.0
       
        let destinationLabel = toDVC.friendName!
        let destinationImage = toDVC.friendImage!
      
        destinationImage.alpha = 0.0
        destinationLabel.alpha = 0.0
        
        let labelInitialFrame = containerView.convert((sourceLabel.bounds), from: sourceLabel)
        let animatedLabel = UILabel(frame: labelInitialFrame)
        animatedLabel.text = sourceLabel.text
        animatedLabel.font = sourceLabel.font
        containerView.addSubview(animatedLabel)
        
        let ImageInitialFrame = containerView.convert((sourceImage.bounds), from: sourceImage)
        let animatedImage = UIImageView(frame: ImageInitialFrame)
        animatedImage.image = sourceImage.image
        animatedImage.contentMode = .scaleAspectFill
        containerView.addSubview(animatedImage)
     
        let duration = transitionDuration(using: transitionContext)
        toView.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            animatedLabel.frame = containerView.convert((destinationLabel.bounds), from: destinationLabel)
            animatedImage.frame = containerView.convert(destinationImage.bounds, from: destinationImage)
            toView.alpha = 1.0
        }) { (success) in
            
            sourceLabel.alpha = 1.0
            destinationLabel.alpha = 1.0
            animatedLabel.alpha = 0.0
            
            sourceImage.alpha = 1.0
            destinationImage.alpha = 1.0
            animatedImage.alpha = 0.0
            
            animatedImage.removeFromSuperview()
            animatedLabel.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
}
}
