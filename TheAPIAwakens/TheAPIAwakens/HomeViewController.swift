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
    
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

