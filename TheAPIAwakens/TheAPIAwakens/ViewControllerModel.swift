//
//  ViewControllerModel.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/4/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit


class ViewControllerModel: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var characterPicker: UIPickerView!
    
    var objectArray: [AnyObject]?
    let swapiClient = SwapiClient()
    var selectedObject: AnyObject?
    var controllerTitle = "Characters"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewSetup()
        navBarSetup()
        
    }
    
    func navBarSetup() {
        self.title = controllerTitle
    
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(ViewControllerModel.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backPressed() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func pickerViewSetup() {
        
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
        if let data = objectArray {
            return data.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let objects = objectArray {
            let object = objects[row]
            selectedObject = object
        }
    }
    
    
}
