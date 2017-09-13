//
//  VehiclesViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/8/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class VehiclesViewController: SwapiContainerViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Variables
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
    var vehiclesArray: [Vehicle]?
    let swapiClient = SwapiClient()
    var selectedVehicle: Vehicle? {
        didSet {
            if let selectedVehicle = selectedVehicle {
                self.updateLabelsFor(selectedVehicle)
            }
        }
    }
    
    var hasExchangeRate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        buttonsSetup()
        setupDataLabels()
        setupVehiclePicker()
        
        // Picker
        baseController?.picker.delegate = self
        baseController?.picker.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VehiclesViewController.endTextViewEditing))
        self.view.addGestureRecognizer(tap)
        
        // Notification observer to show alert when network connection lost
        NotificationCenter.default.addObserver(self, selector: #selector(showCheckConnectionAlert), name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)

    }
    
    func setupNavigationBar() {
        self.title = "Vehicles"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(CharactersViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backPressed() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func buttonsSetup() {
        baseController?.englishButton.addTarget(self, action: #selector(VehiclesViewController.metricToEnglish), for: .touchUpInside)
        baseController?.metricButton.addTarget(self, action: #selector(VehiclesViewController.englishToMetric), for: .touchUpInside)

    }
    
    func setupDataLabels() {
        baseController?.data1Label.text = "Model"
        baseController?.data2Label.text = "Cost"
        baseController?.data3Label.text = "Length"
        baseController?.data4Label.text = "Class"
        baseController?.data5Label.text = "Crew"
    }
    
    func setupVehiclePicker() {
        
        // SwapiClient
        swapiClient.fetchVehicles { result in
            switch result {
                case .success(let vehicles):
                    self.vehiclesArray = vehicles
                    
                    self.baseController?.smallestObjectLabel.text = self.smallestAndLargest(vehicles).smallest.name
                    self.baseController?.largestObjectLabel.text = self.smallestAndLargest(vehicles).largest.name
                
                    self.baseController?.picker.selectRow(0, inComponent: 0, animated: true)
                
                    self.selectedVehicle = vehicles[(self.baseController?.picker.selectedRow(inComponent: 0))!]
                
                    self.baseController?.picker.reloadAllComponents()
                
            case .failure(let error):
               print(error)
            }
        }
        
    }
    
    func updateLabelsFor(_ vehicle: Vehicle) {
        self.baseController?.titleLabel.text = selectedVehicle?.name
        
        if let make = selectedVehicle?.model {
            baseController?.info1Label.text = make
        } else {
            baseController?.info1Label.text = "N/a"
        }
        
        if let vehicleCost = selectedVehicle?.costDouble {
            baseController?.self.info2Label.text = "\(vehicleCost) credits"
        } else {
            baseController?.info2Label.text = "N/a"
        }
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            baseController?.info3Label.text = "\(vehicleLength) cm"
        } else {
            baseController?.info3Label.text = "N/a"
        }
        
        if let vehicleClass = selectedVehicle?.vehicleClass {
            baseController?.info4Label.text = vehicleClass
        } else {
            baseController?.info4Label.text = "N/a"
        }
       
        if let crew = selectedVehicle?.crew {
            baseController?.info5Label.text = crew
        } else {
            baseController?.info5Label.text = "N/a"
        }
        
        // Conversion Buttons Color 
        self.baseController?.englishButton.setTitleColor(unselectedColor, for: UIControlState())
        self.baseController?.metricButton.setTitleColor(UIColor.white, for: UIControlState())
        self.baseController?.usdButton.setTitleColor(unselectedColor, for: UIControlState())
        self.baseController?.creditsButton.setTitleColor(UIColor.white, for: UIControlState())
        
 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: PickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let vehicles = vehiclesArray {
            return vehicles.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let vehicles = vehiclesArray {
            let vehicle = vehicles[row]
            return vehicle.name
        } else {
            return "Awaiting vehicle arrival"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let vehicles = vehiclesArray {
            let vehicle = vehicles[row]
            selectedVehicle = vehicle
        }
    }
    
    // MARK: English and Metric Conversions
    
    func englishToMetric() {
        baseController?.englishButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.metricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            baseController?.info3Label.text = "\(vehicleLength) cm"
        }
    }
    
    func metricToEnglish() {
        baseController?.metricButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.englishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            let englishLength = vehicleLength * 0.328084
            baseController?.info3Label.text = "\(englishLength) ft"
        }
        
    }
    
    // MARK: USD and Credits Conversion
    
    func USDToCredits() {
        baseController?.usdButton.setTitleColor(unselectedColor, for: UIControlState())
        baseController?.creditsButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleCost = selectedVehicle?.costDouble {
            baseController?.info2Label.text = "\(vehicleCost) credits"
        }
    }
    
    func CreditsToUSD() {
        if hasExchangeRate == false {
            baseController?.usdButton.setTitleColor(unselectedColor, for: UIControlState())
            baseController?.creditsButton.setTitleColor(UIColor.white, for: UIControlState())
        } else if hasExchangeRate == true {
            baseController?.usdButton.setTitleColor(UIColor.white, for: UIControlState())
            baseController?.creditsButton.setTitleColor(unselectedColor, for: UIControlState())
            
        }
        
        validateExchageRate()
    }
    
    func validateExchageRate() {
        if selectedVehicle?.costDouble == nil {
            baseController?.usdButton.isEnabled = false
        }
        
        if baseController?.conversionTextField.text == "" {
            hasExchangeRate = false
            presentAlert(title: "Invalid exchange rate", message: "Enter exchange rate")
        }
        
        guard let exchangeRateDouble = Double((baseController?.conversionTextField.text!)!) else {
            hasExchangeRate = false
            baseController?.conversionTextField.text = ""
            presentAlert(title: "Invalid exchange rate", message: "Exchange rate must be a number")
            return
        }
        
        if exchangeRateDouble <= 0 {
            hasExchangeRate = false
            presentAlert(title: "Invalid exchange rate", message: "Exchange rate must be greater than zero")
        }
        
        if exchangeRateDouble > 0 {
            if let vehicleCost = selectedVehicle?.costDouble {
                hasExchangeRate = true
                let USDCost = vehicleCost * exchangeRateDouble
                baseController?.info2Label.text = "$\(USDCost)"
            } else {
                presentAlert(title: "Error", message: "Missing cost for this vehicle")
            }
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

    //MARK: Smallest and Largest
    
    func smallestAndLargest(_ vehicles: [Vehicle]) -> (smallest: Vehicle, largest: Vehicle) {
        var vehiclesWithLength = [Vehicle]()
        for vehicle in vehicles {
            if vehicle.lengthDouble != nil {
                vehiclesWithLength.append(vehicle)
            }
        }
        let sortedVehicles = vehiclesWithLength.sorted { $0.lengthDouble! < $1.lengthDouble! }
        return (sortedVehicles.first!, sortedVehicles.last!)
    }
    
    // MARK: Network Alert
    
    func showCheckConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "Check network connection and try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }

}
