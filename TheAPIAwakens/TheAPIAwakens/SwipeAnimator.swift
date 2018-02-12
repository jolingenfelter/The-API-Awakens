//
//  SwipeAnimator.swift
//  TheAPIAwakens
//
//  Created by Joanna LINGENFELTER on 2/10/18.
//  Copyright © 2018 JoLingenfelter. All rights reserved.
//

import UIKit

class SwipeAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    let animationDuration = 2.0
    weak var storedContext: UIViewControllerContextTransitioning?
    private var pausedTime: CFTimeInterval = 0
    var interactive = false
    var panning = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        storedContext = transitionContext
        
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = CGRect(x: finalFrame.width, y: 0, width: finalFrame.width, height: finalFrame.height)
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let topSlide = CABasicAnimation(keyPath: "position.x")
        topSlide.fromValue = 0
        topSlide.toValue = -fromVC.view.frame.width
        topSlide.duration = animationDuration
        topSlide.delegate = self
        fromVC.view.layer.add(topSlide, forKey: nil)
        
        let bottomSlide = CABasicAnimation(keyPath: "position.x")
        bottomSlide.fromValue = finalFrame.width
        bottomSlide.toValue = 0
        bottomSlide.duration = animationDuration
        toVC.view.layer.add(bottomSlide, forKey: nil)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            if let fromVC = context.viewController(forKey: .from), let toVC = context.viewController(forKey: .to) {
                fromVC.view.layer.removeAllAnimations()
                toVC.view.layer.removeAllAnimations()
            }
        }
        storedContext = nil
    }
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        
    }
    
    override func cancel() {
        
        super.cancel()
    }
    
    override func finish() {
        
        super.finish()
    }
    
    private func restart(forFinishing: Bool) {
        
    }
}














