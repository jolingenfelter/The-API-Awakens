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
    var operation: UINavigationControllerOperation = .push
    var panning = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if interactive {
            let transitionLayer = transitionContext.containerView.layer
            pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), from: nil)
            transitionLayer.speed = 0
            transitionLayer.timeOffset = pausedTime
        }
        
        if operation == .push {
            storedContext = transitionContext
            
            guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
            
            transitionContext.containerView.addSubview(toVC.view)
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toVC.view.frame = CGRect(x: finalFrame.maxX, y: 0, width: finalFrame.width, height: finalFrame.height)
            print(toVC.view.frame)
            
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
        let translation = recognizer.translation(in: recognizer.view!.superview!)
        var progress: CGFloat = abs(translation.x / 200)
        progress = min(max(progress, 0.01), 0.99)
        switch recognizer.state {
        case .changed:
            update(progress)
        case .cancelled, .ended:
            if progress < 0.5 {
                cancel()
            } else {
                finish()
            }
            panning = false
            interactive = false
        default:
            break
        }
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














