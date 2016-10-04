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
        
        // SwapiClient
        swapiClient.fetchCharacters { (result) in
            switch result {
            case .success(let characters):
                self.charactersArray = characters
                print(self.charactersArray)
                self.characterPicker.reloadAllComponents()
            case .failure(let error):
                print(error)
            }
        }
        
        // PickerView
        characterPicker.delegate = self
        characterPicker.dataSource = self

    }
    
    //didReceiveMemoryWarning is not the method you want to set up your views with. ;-)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: PickerView
    
    //numberOfComponents only needs to return 1 because you only need the picker to display one category of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //numberOfRows is the method you need to set up to display the data. Kinda like in a UITableView
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
    

}
