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
    var operation: UINavigationControllerOperation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        storedContext = transitionContext
        
        if operation == .push {
            
            guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
                return
            }
            
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toVC.view.frame = finalFrame
            let containerView = transitionContext.containerView
            containerView.addSubview(toVC.view)

            let topSlide = CABasicAnimation(keyPath: "position.x")
            topSlide.fromValue = 0
            topSlide.toValue = -fromVC.view.frame.width
            topSlide.duration = animationDuration
            topSlide.delegate = self
            fromVC.view.layer.add(topSlide, forKey: nil)
        }
        
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
        let animationProgress = TimeInterval(animationDuration) * TimeInterval(percentComplete)
        storedContext?.containerView.layer.timeOffset = pausedTime + animationProgress
    }
    
    override func cancel() {
        restart(forFinishing: false)
        super.cancel()
    }
    
    override func finish() {
        restart(forFinishing: true)
        super.finish()
    }
    
    private func restart(forFinishing: Bool) {
        let transitionLayer = storedContext?.containerView.layer
        transitionLayer?.beginTime = CACurrentMediaTime()
        transitionLayer?.speed = forFinishing ? 1 : -1
    }
}














