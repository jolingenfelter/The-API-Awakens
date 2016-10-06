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
    }
    
    func setupDataLabels() {
        data1Label.text = "Born"
        data2Label.text = "Home"
        data3Label.text = "Height"
        data4Label.text = "Eyes"
        data5Label.text = "Hair"
    }

    
    func setupCharacterPicker() {
        
        // SwapiClient
        swapiClient.fetchCharacters { (result) in
            switch result {
            case .success(let characters):
                self.charactersArray = characters
                
                self.smallestObjectLabel.text = self.smallestAndLargest(characters).smallest.name
                self.largestObjectLabel.text = self.smallestAndLargest(characters).largest.name
                
                self.characterPicker.selectRow(0, inComponent: 0, animated: true)
                
                self.selectedCharacter = characters[self.characterPicker.selectedRow(inComponent: 0)]
                
                self.fetchCharacterHome(self.selectedCharacter!)
                
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
    
    func updateLabelsFor(_ character: Character) {
        self.nameLabel.text = selectedCharacter?.name
        self.info1Label.text = selectedCharacter?.yearOfBirth
        fetchCharacterHome(selectedCharacter!)
        self.info3Label.text = selectedCharacter?.heightString
        self.info4Label.text = selectedCharacter?.eyeColor
        self.info5Label.text = selectedCharacter?.hairColor
    }
    
    //didReceiveMemoryWarning is not the method you want to set up your views with. ;-)
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
        if let characters = charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    
    // English and Metric Conversions
    
    func englishToMetric() {
        
    }
    
    func metricToEnglish() {
        
    }
    
    // Smallest and Largest Characters
    
    func smallestAndLargest(_ characters: [Character]) -> (smallest: Character, largest: Character) {
        
        let sortedCharacters = characters.sorted { $0.heightInt! < $1.heightInt! }
        
        return (sortedCharacters.first!, sortedCharacters.last!)
    }



}
