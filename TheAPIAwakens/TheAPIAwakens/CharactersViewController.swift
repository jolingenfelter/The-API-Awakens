//
//  CharactersViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var characterPicker: UIPickerView!
    
    var charactersArray: [Character]?
    let swapiClient = SwapiClient()
    var selectedCharacter: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // SwapiClient
        swapiClient.fetchCharacters { (result) in
            switch result {
            case .success(let characters):
                self.charactersArray = characters
                print(self.charactersArray)
            case .failure(let error):
                print(error)
            }
        }
        
        // PickerView
        characterPicker.delegate = self
        characterPicker.dataSource = self
        self.characterPicker.reloadAllComponents()
    }
    
    // MARK: PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let characters = charactersArray {
            return characters.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let characters = charactersArray {
            let character = characters[row]
            return character.name
        } else {
            return "Hello world"
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let characters = charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    

}
