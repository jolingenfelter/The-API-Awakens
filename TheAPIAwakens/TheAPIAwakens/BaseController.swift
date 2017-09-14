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
    
    var hasExchangeRate: Bool = false
    
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func creditsToUSD(priceableObject: Priceable) {
        
        let userText = conversionTextField.text
        
        guard userText != "", let exchangeRateString = userText, let exchangeRate = Double(exchangeRateString) else {
            self.hasExchangeRate = false
            conversionTextField.text = ""
            showAlert(withTitle: "Invalid exchange rate", andMessage: "Enter a valid exchange rate")
            usdButton.setTitleColor(unselectedColor, for: UIControlState())
            creditsButton.setTitleColor(.white, for: UIControlState())
            return
        }
        
        do {
            try priceableObject.usdCost(exchangeRate: exchangeRate) { (convertedCost) in
                self.hasExchangeRate = true
                self.info2Label.text = "$\(convertedCost)"
                self.usdButton.setTitleColor(.white, for: .normal)
                self.creditsButton.setTitleColor(self.unselectedColor, for: .normal)
            }
            
        } catch ConversionError.UnavailableCost {
            showAlert(withTitle: "Error", andMessage: ConversionError.UnavailableCost.rawValue)
        } catch ConversionError.InvalidExchangeRate {
            showAlert(withTitle: "Error", andMessage: ConversionError.InvalidExchangeRate.rawValue)
        } catch let error {
            showAlert(withTitle: "Error", andMessage: error.localizedDescription)
        }
        
    }

}
