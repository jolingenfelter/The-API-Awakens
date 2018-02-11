//
//  ViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/30/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var charactersStackView: UIStackView!
    @IBOutlet weak var vehiclesStackView: UIStackView!
    @IBOutlet weak var starshipsStackView: UIStackView!
    
    @IBOutlet weak var charactersCenterX: NSLayoutConstraint!
    @IBOutlet weak var vehiclesCenterX: NSLayoutConstraint!
    @IBOutlet weak var starshipsCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    
    let swipeTransition = SwipeAnimator()
    var firstLoad = true
    var touchPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(pan)
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let constraintsArray = [charactersCenterX, vehiclesCenterX, starshipsCenterX]
        
        if firstLoad {
            for constraint in constraintsArray {
                constraint?.constant = -view.frame.size.width
            }
        } else {
            for constraint in constraintsArray {
                constraint?.constant = 0
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.charactersCenterX.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.firstLoad = false
            })
        
            UIView.animate(withDuration: 2.0, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.vehiclesCenterX.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        
            UIView.animate(withDuration: 2.0, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.starshipsCenterX.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - Gestures
extension HomeViewController {
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        guard let touchPoint = touchPoint else {
            return
        }
        switch recognizer.state {
        case .began:
            swipeTransition.interactive = true
            swipeTransition.panning = true
            determineToViewController(point: touchPoint, completion: { (segueIdentifier) in
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            })
        default:
            swipeTransition.handlePan(recognizer)
        }
    }
    
    func determineToViewController(point: CGPoint, completion: (String) -> ()) {
        if point.y < self.separator1.frame.origin.y {
            completion("characters")
        } else if point.y > self.separator2.frame.origin.y {
            completion("vehicles")
        } else {
            completion("starships")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint = touches.first?.location(in: self.view)
    }
}

// MARK: - UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
   
    func navigationController(_
        navigationController: UINavigationController,
                              animationControllerFor
        operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
            return swipeTransition.panning ? swipeTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return !swipeTransition.interactive ? nil : swipeTransition
    }
    
}








