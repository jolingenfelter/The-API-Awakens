//
//  StarshipsViewController.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/8/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets
    @IBOutlet weak var starshipPicker: UIPickerView!
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
    let unselectedColor = UIColor(red: 140/255, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
    var starshipsArray: [Starship]?
    let swapiClient = SwapiClient()
    var selectedStarship: Starship? {
        didSet {
            self.updateLabelsFor(selectedStarship!)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        buttonsSetup()
        setupDataLabels()
        setupStarshipPicker()
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
        EnglishButton.addTarget(self, action: #selector(CharactersViewController.metricToEnglish), for: .touchUpInside)
        MetricButton.addTarget(self, action: #selector(CharactersViewController.englishToMetric), for: .touchUpInside)
        
    }
    
    func setupDataLabels() {
        data1Label.text = "Make"
        data2Label.text = "Cost"
        data3Label.text = "Length"
        data4Label.text = "Class"
        data5Label.text = "Crew"
    }
    
    func setupStarshipPicker() {
        
        // SwapiClient
        swapiClient.fetchStarships { result in
            switch result {
                case .success(let starships):
                    self.starshipsArray = starships
                
                    self.smallestObjectLabel.text = self.smallestAndLargest(starships).smallest.name
                    self.largestObjectLabel.text = self.smallestAndLargest(starships).largest.name
                
                    self.starshipPicker.selectRow(0, inComponent: 0, animated: true)
                
                    self.selectedStarship = starships[self.starshipPicker.selectedRow(inComponent: 0)]
                
                    self.starshipPicker.reloadAllComponents()
                
                case .failure(let error):
                    print(error)
                
            }
        }
        
        // PickerView
        starshipPicker.delegate = self
        starshipPicker.dataSource = self
    }
    
    func updateLabelsFor(_ starship: Starship) {
        
        self.nameLabel.text = selectedStarship?.name
        
        if let model = selectedStarship?.model {
            info1Label.text = model
        } else {
            info1Label.text = "N/a"
        }
        
        if let starshipCost = selectedStarship?.costDouble {
            self.info2Label.text = "\(starshipCost) credits"
        } else {
            self.info2Label.text = "N/a"
        }
        
        if let starshipLength = selectedStarship?.lengthDouble {
            self.info3Label.text = "\(starshipLength) m"
        } else {
            self.info3Label.text = "N/a"
        }
        
        if let starshipClass = selectedStarship?.starshipClass {
            info4Label.text = starshipClass
        } else {
            info4Label.text = "N/a"
        }
    
        if let crew = selectedStarship?.crew {
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
    
    // MARK: UIPickerView Delegate
    
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
        info3Label.text = ""
        if let starships = starshipsArray {
            let starship = starships[row]
            selectedStarship = starship
        }
    }
    
    
    // MARK: English and Metric Conversions
    
    func englishToMetric() {
        EnglishButton.setTitleColor(unselectedColor, for: UIControlState())
        MetricButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let starshipLength = selectedStarship?.lengthDouble {
            info3Label.text = "\(starshipLength) m"
        }
    }
    
    func metricToEnglish() {
        MetricButton.setTitleColor(unselectedColor, for: UIControlState())
        EnglishButton.setTitleColor(UIColor.white, for: UIControlState())
        
        if let starshipLength = selectedStarship?.lengthDouble {
            let englishLength = starshipLength * 1.09361
            info3Label.text = "\(englishLength) yds"
        }
        
    }
    
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

    

}
