//
//  SwapiContainerViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/12/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class SwapiContainerViewController: UIViewController {
    
    public var baseController: BaseController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let baseVC = segue.destination as? BaseController else { return }
        baseController = baseVC
        
    }

}
