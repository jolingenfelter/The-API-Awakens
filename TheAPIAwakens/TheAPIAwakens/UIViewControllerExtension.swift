//
//  UIViewControllerExtension.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/13/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
