//
//  SettingsViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 9/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData : [Double] = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = [200, 400, 600, 800, 1000, 2000, 3000, 5000]
    }
    
    override func viewDidAppear(animated: Bool) {
        let indexOfRealmDistance = pickerData.indexOf(RealmHelper.getDistance())
        self.picker.selectRow(indexOfRealmDistance!, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Int(pickerData[row]))"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       RealmHelper.updateDistance(pickerData[row])
    }
    
}
