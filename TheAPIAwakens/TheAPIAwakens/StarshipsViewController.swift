//
//  StarshipsViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/8/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class StarshipsViewController: SwapiContainerViewController, UITextFieldDelegate {
    
    // Variables
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
    var starshipsArray: [Starship]?
    let swapiClient = SwapiClient()
    var selectedStarship: Starship? {
        didSet {
            self.updateLabelsFor(selectedStarship!)
        }
    }
    
    var hasExchangeRate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        buttonsSetup()
        setupDataLabels()
        fetchAndLoadStarships()

        
        baseController?.conversionTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(StarshipsViewController.endTextViewEditing))
        self.view.addGestureRecognizer(tap)
        
        // Picker
        baseController?.picker.delegate = self
        baseController?.picker.dataSource = self
        
        // Notification observer to show alert when network connection lost
        NotificationCenter.default.addObserver(self, selector: #selector(showCheckConnectionAlert), name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }
    
    func setupNavigationBar() {
        self.title = "Starships"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(CharactersViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backPressed() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func buttonsSetup() {
        baseController?.creditsButton.addTarget(self, action: #selector(usdToCredits), for: .touchUpInside)
        baseController?.usdButton.addTarget(self, action: #selector(creditsToUSD), for: .touchUpInside)
        baseController?.englishButton.addTarget(self, action: #selector(metricToEnglish), for: .touchUpInside)
        baseController?.metricButton.addTarget(self, action: #selector(englishToMetric), for: .touchUpInside)
    }
    
    func setupDataLabels() {
        baseController?.data1Label.text = "Model"
        baseController?.data2Label.text = "Cost"
        baseController?.data3Label.text = "Length"
        baseController?.data4Label.text = "Class"
        baseController?.data5Label.text = "Crew"
        
        baseController?.conversionTextField.placeholder = "Exchange Rate"
    }
    
    func fetchAndLoadStarships() {
        
        // SwapiClient
        swapiClient.fetchStarships { result in
            switch result {
                case .success(let starships):
                    self.starshipsArray = starships
                
                    self.baseController?.smallestObjectLabel.text = self.smallestAndLargest(starships).smallest.name
                    self.baseController?.largestObjectLabel.text = self.smallestAndLargest(starships).largest.name
                
                    self.baseController?.picker.selectRow(0, inComponent: 0, animated: true)
                
                    self.selectedStarship = starships[(self.baseController?.picker.selectedRow(inComponent: 0))!]
                
                    self.baseController?.picker.reloadAllComponents()
                
                case .failure(let error):
                    print(error)
                
            }
        }
        
    }
    
    func updateLabelsFor(_ starship: Starship) {
        
        self.baseController?.titleLabel.text = selectedStarship?.name
        
        if let model = selectedStarship?.model {
            
            baseController?.info1Label.text = model
        } else {
            baseController?.info1Label.text = "N/a"
        }
        
        if let starshipCost = selectedStarship?.costDouble {
            baseController?.info2Label.text = "\(starshipCost) credits"
        } else {
            baseController?.info2Label.text = "N/a"
        }
        
        if let starshipLength = selectedStarship?.lengthDouble {
            baseController?.info3Label.text = "\(starshipLength) m"
        } else {
            baseController?.info3Label.text = "N/a"
        }
        
        if let starshipClass = selectedStarship?.starshipClass {
            baseController?.info4Label.text = starshipClass
        } else {
            baseController?.info4Label.text = "N/a"
        }
    
        if let crew = selectedStarship?.crew {
            baseController?.info5Label.text = crew
        } else {
            baseController?.info5Label.text = "N/a"
        }
        
        // Conversion Buttons Color
        self.baseController?.englishButton.setTitleColor(unselectedColor, for: .normal)
        self.baseController?.metricButton.setTitleColor(UIColor.white, for: .normal)
        self.baseController?.usdButton.setTitleColor(unselectedColor, for: .normal)
        self.baseController?.creditsButton.setTitleColor(UIColor.white, for: .normal)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: English and Metric Conversions
    
    func englishToMetric() {
        baseController?.englishButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.metricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let starshipLength = selectedStarship?.lengthDouble {
            baseController?.info3Label.text = "\(starshipLength) m"
        }
    }
    
    func metricToEnglish() {
        baseController?.metricButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.englishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let starshipLength = selectedStarship?.lengthDouble {
            let englishLength = starshipLength * 1.09361
            baseController?.info3Label.text = "\(englishLength) yds"
        }
        
    }
    
    // MARK: USD and Credits Conversion
    
    func usdToCredits() {
        
        baseController?.usdButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.creditsButton.setTitleColor(.white, for: UIControlState())
        
        if let starshipCost = selectedStarship?.costString{
            baseController?.info2Label.text = "\(starshipCost) credits"
        }
    }
    
    func creditsToUSD() {
        
        let userText = baseController?.conversionTextField.text
        
        guard userText != "", let exchangeRateString = userText, let exchangeRate = Double(exchangeRateString) else {
            self.hasExchangeRate = false
            baseController?.conversionTextField.text = ""
            presentAlert(title: "Invalid exchange rate", message: "Enter a valid exchange rate")
            baseController?.usdButton.setTitleColor(unselectedColor, for: UIControlState())
            baseController?.creditsButton.setTitleColor(.white, for: UIControlState())
            return
        }
        
        do {
                try selectedStarship?.usdCost(exchangeRate: exchangeRate) { (convertedCost) in
                self.hasExchangeRate = true
                self.baseController?.info2Label.text = "$\(convertedCost)"
                self.baseController?.usdButton.setTitleColor(.white, for: .normal)
                self.baseController?.creditsButton.setTitleColor(self.unselectedColor, for: .normal)
            }
            
        } catch ConversionError.UnavailableCost {
            presentAlert(title: "Error", message: ConversionError.UnavailableCost.rawValue)
        } catch ConversionError.InvalidExchangeRate {
            presentAlert(title: "Error", message: ConversionError.InvalidExchangeRate.rawValue)
        } catch let error {
            presentAlert(title: "Error", message: error.localizedDescription)
        }

    }

    
    func presentAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    // MARK: TextField Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if baseController?.conversionTextField.text == "" {
            baseController?.conversionTextField.placeholder = "Exchange rate"
        }
        resignFirstResponder()
    }
    
    func endTextViewEditing() {
        baseController?.conversionTextField.endEditing(true)
        view.endEditing(true)
    }
    
    // MARK: Smallest and Largest
    
    func smallestAndLargest(_ starships: [Starship]) -> (smallest: Starship, largest: Starship) {
        var shipsWithlength = [Starship]()
        for starship in starships {
            if starship.lengthDouble != nil {
                shipsWithlength.append(starship)
            }
        }
        let sortedStarships = shipsWithlength.sorted { $0.lengthDouble! < $1.lengthDouble! }
        return (sortedStarships.first!, sortedStarships.last!)
    }

    // MARK: Network Alert
    
    func showCheckConnectionAlert() {
        showAlert(withTitle: "Error", andMessage: "Check network connection and try again")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }

}

// MARK: - PickerView

extension StarshipsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let starships = starshipsArray {
            return starships.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let starships = starshipsArray {
            let starship = starships[row]
            return starship.name
        } else {
            return ("Awaiting starship arrival")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        baseController?.info3Label.text = ""
        if let starships = starshipsArray {
            let starship = starships[row]
            selectedStarship = starship
        }
    }
}
