//
//  ViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/30/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Make NavigationBar Transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

