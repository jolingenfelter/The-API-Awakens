//
//  CharactersViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets
    @IBOutlet weak var characterPicker: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var data1Label: UILabel!
    @IBOutlet weak var data2Label: UILabel!
    @IBOutlet weak var data3Label: UILabel!
    @IBOutlet weak var data4Label: UILabel!
    @IBOutlet weak var data5Label: UILabel!
    @IBOutlet weak var data6Label: UILabel!
    
    @IBOutlet weak var info1Label: UILabel!
    @IBOutlet weak var info2Label: UILabel!
    @IBOutlet weak var info3Label: UILabel!
    @IBOutlet weak var info4Label: UILabel!
    @IBOutlet weak var info5Label: UILabel!
    @IBOutlet weak var info6Label: UILabel!

    
    @IBOutlet weak var smallestObjectLabel: UILabel!
    @IBOutlet weak var largestObjectLabel: UILabel!
    
    @IBOutlet weak var USDButton: UIButton!
    @IBOutlet weak var CreditsButton: UIButton!
    @IBOutlet weak var EnglishButton: UIButton!
    @IBOutlet weak var MetricButton: UIButton!

    
    // Variables
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
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
        
        // Notification observer to show alert when network connection lost
        NotificationCenter.default.addObserver(self, selector: #selector(showCheckConnectionAlert), name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
    }
    
    func setupNavigationBar() {
        self.title = "Characters"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(CharactersViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backPressed() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func buttonsSetup() {
        USDButton.isHidden = true
        CreditsButton.isHidden = true
        
        EnglishButton.addTarget(self, action: #selector(CharactersViewController.metricToEnglish), for: .touchUpInside)
        MetricButton.addTarget(self, action: #selector(CharactersViewController.englishToMetric), for: .touchUpInside)
    }
    
    func setupDataLabels() {
        data1Label.text = "Born"
        data2Label.text = "Home"
        data3Label.text = "Height"
        data4Label.text = "Eyes"
        data5Label.text = "Hair"
        data6Label.text = "Vehicle(s)"
    }

    
    func setupCharacterPicker() {
        
        // SwapiClient
        swapiClient.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.charactersArray = characters
                
                self.smallestObjectLabel.text = self.smallestAndLargest(characters).smallest.name
                self.largestObjectLabel.text = self.smallestAndLargest(characters).largest.name
                
                self.characterPicker.selectRow(0, inComponent: 0, animated: true)
                
                self.selectedCharacter = characters[self.characterPicker.selectedRow(inComponent: 0)]
                
                self.fetchCharacterHome(self.selectedCharacter!)
                
                self.fetchVehiclesForCharacter(self.selectedCharacter!)
                
                self.characterPicker.reloadAllComponents()
            
            case .failure(let error):
                print(error)
            }
        }
        
        // PickerView
        characterPicker.delegate = self
        characterPicker.dataSource = self
    }
    
    func fetchCharacterHome(_ character: Character) {
        self.swapiClient.fetchCharacterHome(character) { result in
            
            switch result {
                case .success(let home):
                    self.info2Label.text = home.name
                case .failure(let error):
                    print(error)
                    self.info2Label.text = "Unavailable"
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
                
                self.info6Label.text = "\(vehicleNamesArray.joined(separator: ", "))"
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateLabelsFor(_ character: Character) {
        self.nameLabel.text = selectedCharacter?.name
        
        if let yearOfBirth = selectedCharacter?.yearOfBirth {
            self.info1Label.text = yearOfBirth
        } else {
            info1Label.text = "unknown"
        }
        
        fetchCharacterHome(selectedCharacter!)
        
        if let characterHeight = selectedCharacter?.heightDouble {
            self.info3Label.text = "\(characterHeight) cm"
        }
        
        if let eyeColor = selectedCharacter?.eyeColor {
            info4Label.text = eyeColor
        } else {
            info4Label.text = "unknown"
        }
        
        if let hairColor = selectedCharacter?.hairColor {
            info5Label.text = hairColor
        } else {
            info5Label.text = "unknown"
        }
        
        fetchVehiclesForCharacter(selectedCharacter!)
        
        // Conversion Buttons Color
        self.EnglishButton.setTitleColor(unselectedColor, for: UIControlState())
        self.MetricButton.setTitleColor(UIColor.white, for: UIControlState())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: PickerViewDelegate
    
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
        
        info6Label.text = ""
        
        if let characters = charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    
    // MARK: English and Metric Conversions
    
    func englishToMetric() {
        EnglishButton.setTitleColor(unselectedColor, for: UIControlState())
        MetricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let characterHeight = selectedCharacter?.heightDouble {
            info3Label.text = "\(characterHeight) cm"
        }
    }
    
    func metricToEnglish() {
        MetricButton.setTitleColor(unselectedColor, for: UIControlState())
        EnglishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let characterHeight = selectedCharacter?.heightDouble {
            let englishHeight = characterHeight * 0.328084
            info3Label.text = "\(englishHeight) ft"
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
