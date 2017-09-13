//
//  BaseController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/12/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var data1Label: UILabel!
    @IBOutlet weak var info1Label: UILabel!
    @IBOutlet weak var data2Label: UILabel!
    @IBOutlet weak var info2Label: UILabel!
    @IBOutlet weak var data3Label: UILabel!
    @IBOutlet weak var info3Label: UILabel!
    @IBOutlet weak var data4Label: UILabel!
    @IBOutlet weak var info4Label: UILabel!
    @IBOutlet weak var data5Label: UILabel!
    @IBOutlet weak var info5Label: UILabel!
    @IBOutlet weak var data6Label: UILabel!
    @IBOutlet weak var info6Label: UILabel!
    
    
    @IBOutlet weak var conversionTextField: UITextField!
    
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var smallestObjectLabel: UILabel!
    @IBOutlet weak var largestObjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
