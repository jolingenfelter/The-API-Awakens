//
//  VehiclesViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/8/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class VehiclesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var vehiclePicker: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var data1Label: UILabel!
    @IBOutlet weak var data2Label: UILabel!
    @IBOutlet weak var data3Label: UILabel!
    @IBOutlet weak var data4Label: UILabel!
    @IBOutlet weak var data5Label: UILabel!
 
    @IBOutlet weak var info1Label: UILabel!
    @IBOutlet weak var info2Label: UILabel!
    @IBOutlet weak var info3Label: UILabel!
    @IBOutlet weak var info4Label: UILabel!
    @IBOutlet weak var info5Label: UILabel!
    
    
    @IBOutlet weak var smallestObjectLabel: UILabel!
    @IBOutlet weak var largestObjectLabel: UILabel!
    
    @IBOutlet weak var USDButton: UIButton!
    @IBOutlet weak var CreditsButton: UIButton!
    @IBOutlet weak var EnglishButton: UIButton!
    @IBOutlet weak var MetricButton: UIButton!
    
    @IBOutlet weak var exchangeRateTextField: UITextField!
    
    // Variables
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
    var vehiclesArray: [Vehicle]?
    let swapiClient = SwapiClient()
    var selectedVehicle: Vehicle? {
        didSet {
            self.updateLabelsFor(selectedVehicle!)
        }
    }
    
    var hasExchangeRate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        buttonsSetup()
        setupDataLabels()
        setupVehiclePicker()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VehiclesViewController.endTextViewEditing))
        self.view.addGestureRecognizer(tap)
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
        EnglishButton.addTarget(self, action: #selector(VehiclesViewController.metricToEnglish), for: .touchUpInside)
        MetricButton.addTarget(self, action: #selector(VehiclesViewController.englishToMetric), for: .touchUpInside)

    }
    
    func setupDataLabels() {
        data1Label.text = "Model"
        data2Label.text = "Cost"
        data3Label.text = "Length"
        data4Label.text = "Class"
        data5Label.text = "Crew"
    }
    
    func setupVehiclePicker() {
        
        // SwapiClient
        swapiClient.fetchVehicles { result in
            switch result {
                case .success(let vehicles):
                    self.vehiclesArray = vehicles
                    
                    self.smallestObjectLabel.text = self.smallestAndLargest(vehicles).smallest.name
                    self.largestObjectLabel.text = self.smallestAndLargest(vehicles).largest.name
                
                    self.vehiclePicker.selectRow(0, inComponent: 0, animated: true)
                
                    self.selectedVehicle = vehicles[self.vehiclePicker.selectedRow(inComponent: 0)]
                
                    self.vehiclePicker.reloadAllComponents()
                
            case .failure(let error):
                print(error)
            }
        }
        
        // PickerView 
        vehiclePicker.dataSource = self
        vehiclePicker.delegate = self
        
    }
    
    func updateLabelsFor(_ vehicle: Vehicle) {
        self.nameLabel.text = selectedVehicle?.name
        
        if let make = selectedVehicle?.model {
            info1Label.text = make
        } else {
            info1Label.text = "N/a"
        }
        
        if let vehicleCost = selectedVehicle?.costDouble {
            self.info2Label.text = "\(vehicleCost) credits"
        } else {
            info2Label.text = "N/a"
        }
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            self.info3Label.text = "\(vehicleLength) cm"
        } else {
            info3Label.text = "N/a"
        }
        
        if let vehicleClass = selectedVehicle?.vehicleClass {
            info4Label.text = vehicleClass
        } else {
            info4Label.text = "N/a"
        }
       
        if let crew = selectedVehicle?.crew {
            info5Label.text = crew
        } else {
            info5Label.text = "N/a"
        }
        
        // Conversion Buttons Color 
        self.EnglishButton.setTitleColor(unselectedColor, for: UIControlState())
        self.MetricButton.setTitleColor(UIColor.white, for: UIControlState())
        self.USDButton.setTitleColor(unselectedColor, for: UIControlState())
        self.CreditsButton.setTitleColor(UIColor.white, for: UIControlState())
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
        EnglishButton.setTitleColor(unselectedColor, for: UIControlState())
        MetricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            info3Label.text = "\(vehicleLength) cm"
        }
    }
    
    func metricToEnglish() {
        MetricButton.setTitleColor(unselectedColor, for: UIControlState())
        EnglishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            let englishLength = vehicleLength * 0.328084
            info3Label.text = "\(englishLength) ft"
        }
        
    }
    
    // MARK: USD and Credits Conversion
    
    func USDToCredits() {
        USDButton.setTitleColor(unselectedColor, for: UIControlState())
        CreditsButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let vehicleCost = selectedVehicle?.costDouble {
            info2Label.text = "\(vehicleCost) credits"
        }
    }
    
    func CreditsToUSD() {
        if hasExchangeRate == false {
            USDButton.setTitleColor(unselectedColor, for: UIControlState())
            CreditsButton.setTitleColor(UIColor.white, for: UIControlState())
        } else if hasExchangeRate == true {
            USDButton.setTitleColor(UIColor.white, for: UIControlState())
            CreditsButton.setTitleColor(unselectedColor, for: UIControlState())
            
        }
        
        validateExchageRate(exchangeRate: exchangeRateTextField.text)
    }
    
    func validateExchageRate(exchangeRate : String?) {
        if exchangeRate == "" {
            hasExchangeRate = false
            presentAlert(title: "Invalid exchange rate", message: "Enter exchange rate")
        }
        
        guard let exchangeRateDouble = Double(exchangeRate!) else {
            hasExchangeRate = false
            exchangeRateTextField.text = ""
            presentAlert(title: "Invalid exchange rate", message: "Exchange rate must be a number")
            return
        }
        
        if let vehicleCost = selectedVehicle?.costDouble {
            hasExchangeRate = true
            let USDCost = vehicleCost * exchangeRateDouble
            info2Label.text = "$\(USDCost)"
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
        if exchangeRateTextField.text == "" {
            exchangeRateTextField.placeholder = "Exchange rate"
        }
        resignFirstResponder()
    }
    
    func endTextViewEditing() {
        exchangeRateTextField.endEditing(true)
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
}
