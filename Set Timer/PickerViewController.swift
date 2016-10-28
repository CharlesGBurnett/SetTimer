//
//  PickerViewController.swift
//  Set Timer
//
//  Created by Charles Burnett on 10/27/16.
//  Copyright © 2016 Charles Burnett. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var pickerViewData = [["a"], ["b"]]
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        var hourList = [String]()
        var minuteList = [String]()
        var secondList = [String]()
        
        for i in 0...23{
            hourList.append(String(i))
        }
        for i in 0...59{
            minuteList.append(String(i))
            secondList.append(String(i))
        }
        pickerViewData = [hourList, minuteList, secondList]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hours = Int(pickerViewData[component][row])!
        case 1:
            minutes = Int(pickerViewData[component][row])!
        case 2:
            seconds = Int(pickerViewData[component][row])!
        default:
            print("error")
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
