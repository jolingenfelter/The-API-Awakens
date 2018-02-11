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
        storedContext = transitionContext
        
        if operation == .push {
            guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to), let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
                return
            }
            
            let containerView = transitionContext.containerView
            let finalFrame = transitionContext.finalFrame(for: toVC)

            toVC.view.frame = finalFrame
            snapshot.frame = finalFrame
            containerView.addSubview(toVC.view)
            containerView.addSubview(snapshot)

            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = 0.0
            animation.toValue = -fromVC.view.frame.width
            animation.duration = animationDuration
            animation.delegate = self
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
            fromVC.view.layer.add(animation, forKey: nil)

        } else {
            print("pop")
        }
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            if let fromVC = context.viewController(forKey: .from) as? HomeViewController {
                fromVC.view.layer.removeAllAnimations()
            }
        }
        storedContext = nil
    }
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view!.superview)
        var progress: CGFloat = (translation.x/200.0)
        let maximum = max(progress, 0.01)
        progress = min(maximum, 0.99)
        
        switch recognizer.state {
        case .changed:
            panning = true
            update(progress)
        case .cancelled, .ended:
            panning = false
            if progress < 0.5 {
                cancel()
            } else {
                finish()
            }
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
        panning = false
        let transitionLayer = storedContext?.containerView.layer
        transitionLayer?.beginTime = CACurrentMediaTime()
        transitionLayer?.speed = forFinishing ? 1 : -1
    }
}














