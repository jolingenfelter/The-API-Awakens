//
//  VehiclesViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/8/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class VehiclesViewController: SwapiContainerViewController {
    
    // Variables
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
    }
    
    func setupVehiclePicker() {
        
        // SwapiClient
        swapiClient.fetchVehicles { [weak self] result in
            switch result {
                case .success(let vehicles):
                    self?.vehiclesArray = vehicles
                    
                    self?.baseController?.smallestObjectLabel.text = self?.smallestAndLargest(vehicles).smallest.name
                    self?.baseController?.largestObjectLabel.text = self?.smallestAndLargest(vehicles).largest.name
                
                    self?.baseController?.picker.selectRow(0, inComponent: 0, animated: true)
                
                    self?.selectedVehicle = vehicles[(self?.baseController?.picker.selectedRow(inComponent: 0))!]
                
                    self?.baseController?.picker.reloadAllComponents()
                
            case .failure(let error):
               self?.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
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
        self.baseController?.englishButton.setTitleColor(baseController?.unselectedColor, for: .normal)
        self.baseController?.metricButton.setTitleColor(.white, for: .normal)
        self.baseController?.usdButton.setTitleColor(baseController?.unselectedColor, for: .normal)
        self.baseController?.creditsButton.setTitleColor(.white, for: .normal)
        
 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: English and Metric Conversions
    
    @objc func englishToMetric() {
        baseController?.englishButton.setTitleColor(baseController?.unselectedColor, for: .normal)
        baseController?.metricButton.setTitleColor(.white, for: .normal)
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            baseController?.info3Label.text = "\(vehicleLength) cm"
        }
    }
    
    @objc func metricToEnglish() {
        baseController?.metricButton.setTitleColor(baseController?.unselectedColor, for: .normal)
        baseController?.englishButton.setTitleColor(.white, for: .normal)
        
        if let vehicleLength = selectedVehicle?.lengthDouble {
            let englishLength = vehicleLength.metersToYards()
            baseController?.info3Label.text = "\(englishLength) ft"
        }
        
    }
    
    // MARK: USD and Credits Conversion
    
    @objc func usdToCredits() {
        baseController?.usdButton.setTitleColor(baseController?.unselectedColor, for: .normal)
        baseController?.creditsButton.setTitleColor(.white, for: .normal)
        
        if let vehicleCost = selectedVehicle?.costDouble {
            baseController?.info2Label.text = "\(vehicleCost) credits"
        }
    }
    
    @objc func creditsToUSD() {
        
        baseController?.creditsToUSD(priceableObject: selectedVehicle!)
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
    
    @objc func showCheckConnectionAlert() {
        showAlert(withTitle: "Error", andMessage: "Check network connection and try again")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }

}

// MARK: TextField Delegate

extension VehiclesViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if baseController?.conversionTextField.text == "" {
            baseController?.conversionTextField.placeholder = "Exchange rate"
        }
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if baseController?.conversionTextField.text != "" {
            creditsToUSD()
        }
        
        endTextViewEditing()
        
        return true
    }
    
    @objc func endTextViewEditing() {
        baseController?.conversionTextField.endEditing(true)
        view.endEditing(true)
    }
    
}

// MARK: PickerViewDelegate

extension VehiclesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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
}
