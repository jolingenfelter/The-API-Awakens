//
//  CharactersViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class CharactersViewController: SwapiContainerViewController {

    // Variables
    var charactersArray: [Character]?
    let swapiClient = SwapiClient()
    var selectedCharacter: Character? {
        didSet {
            self.updateLabelsFor(selectedCharacter!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCharacterPicker()
        buttonsSetup()
        setupDataLabels()
        
        // Picker
        baseController?.picker.delegate = self
        baseController?.picker.dataSource = self
        
        // Notification observer to show alert when network connection lost
        NotificationCenter.default.addObserver(self, selector: #selector(showCheckConnectionAlert), name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }
    
    func setupNavigationBar() {
        self.title = "Characters"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(CharactersViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backPressed() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func buttonsSetup() {
        baseController?.usdButton.isHidden = true
        baseController?.creditsButton.isHidden = true
        
        baseController?.englishButton.addTarget(self, action: #selector(CharactersViewController.metricToEnglish), for: .touchUpInside)
        baseController?.metricButton.addTarget(self, action: #selector(CharactersViewController.englishToMetric), for: .touchUpInside)
    }
    
    func setupDataLabels() {
        baseController?.data1Label.text = "Born"
        baseController?.data2Label.text = "Home"
        baseController?.data3Label.text = "Height"
        baseController?.data4Label.text = "Eyes"
        baseController?.data5Label.text = "Hair"
        baseController?.data6Label.text = "Vehicle(s)"
    }

    
    func setupCharacterPicker() {
        
        // SwapiClient
        swapiClient.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.charactersArray = characters
                
                self.baseController?.smallestObjectLabel.text = self.smallestAndLargest(characters).smallest.name
                self.baseController?.largestObjectLabel.text = self.smallestAndLargest(characters).largest.name
                
                self.baseController?.picker.selectRow(0, inComponent: 0, animated: true)
                
                self.selectedCharacter = characters[(self.baseController?.picker.selectedRow(inComponent: 0))!]
                
                self.fetchCharacterHome(self.selectedCharacter!)
                
                self.fetchVehiclesForCharacter(self.selectedCharacter!)
                
                self.baseController?.picker.reloadAllComponents()
            
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }
    
    func fetchCharacterHome(_ character: Character) {
        self.swapiClient.fetchCharacterHome(character) { result in
            
            switch result {
                case .success(let home):
                    self.baseController?.info2Label.text = home.name
                case .failure(let error):
                    print(error)
                    self.baseController?.info2Label.text = "Unavailable"
            }
        }
    }
    
    func fetchVehiclesForCharacter(_ character: Character) {
        self.swapiClient.fetchCharacterVehicles(character) { result in
         
            switch result {
            case .success(let vehicles):
                var vehicleNamesArray = [String]()
                for vehicle in vehicles {
                    if let vehicleName = vehicle.name {
                        vehicleNamesArray.append(vehicleName)
                    }
                }
                
                self.baseController?.info6Label.text = "\(vehicleNamesArray.joined(separator: ", "))"
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateLabelsFor(_ character: Character) {
        self.baseController?.titleLabel.text = selectedCharacter?.name
        
        if let yearOfBirth = selectedCharacter?.yearOfBirth {
            baseController?.info1Label.text = yearOfBirth
        } else {
            baseController?.info1Label.text = "unknown"
        }
        
        fetchCharacterHome(selectedCharacter!)
        
        if let characterHeight = selectedCharacter?.heightDouble {
            baseController?.info3Label.text = "\(characterHeight) cm"
        }
        
        if let eyeColor = selectedCharacter?.eyeColor {
            baseController?.info4Label.text = eyeColor
        } else {
            baseController?.info4Label.text = "unknown"
        }
        
        if let hairColor = selectedCharacter?.hairColor {
            baseController?.info5Label.text = hairColor
        } else {
            baseController?.info5Label.text = "unknown"
        }
        
        fetchVehiclesForCharacter(selectedCharacter!)
        
        // Conversion Buttons Color
        baseController?.englishButton.setTitleColor(baseController?.unselectedColor, for: UIControlState())
        baseController?.metricButton.setTitleColor(UIColor.white, for: UIControlState())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: English and Metric Conversions
    
    @objc func englishToMetric() {
        baseController?.englishButton.setTitleColor(baseController?.unselectedColor, for: UIControlState())
        baseController?.metricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let characterHeight = selectedCharacter?.heightDouble {
            baseController?.info3Label.text = "\(characterHeight) cm"
        }
    }
    
    @objc func metricToEnglish() {
        baseController?.metricButton.setTitleColor(baseController?.unselectedColor, for: UIControlState())
        baseController?.englishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let characterHeight = selectedCharacter?.heightDouble {
            let englishHeight = characterHeight.cmToFeet()
            baseController?.info3Label.text = "\(englishHeight) ft"
        }
        
    }
    
    // MARK: Smallest and Largest Characters
    
    func smallestAndLargest(_ characters: [Character]) -> (smallest: Character, largest: Character) {
        var charactersWithHeight = [Character]()
        for character in characters {
            if character.heightDouble != nil {
                charactersWithHeight.append(character)
            }
        }
        let sortedCharacters = charactersWithHeight.sorted { $0.heightDouble! < $1.heightDouble! }
        return (sortedCharacters.first!, sortedCharacters.last!)
    }
    
    // MARK: Network Alert
    
    @objc func showCheckConnectionAlert() {
        showAlert(withTitle: "Error", andMessage: "Check network connection and try again")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }
}

// MARK: - UIPickerViewDataSource and Delegate

extension CharactersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let characters = charactersArray {
            return characters.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let characters = charactersArray {
            let character = characters[row]
            return character.name
        } else {
            return "Awaiting character arrival"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        baseController?.info6Label.text = ""
        
        if let characters = charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    
}
