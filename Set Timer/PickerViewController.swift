//
//  PickerViewController.swift
//  Set Timer
//
//  Created by Charles Burnett on 10/27/16.
//  Copyright © 2016 Charles Burnett. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
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
    
    override func viewWillLayoutSubviews() {
        print("width \(timePickerView.frame.width)")
        
        let pickerWidth = self.view.frame.width
        
        var hourXVal = pickerWidth - 325.0
        var minXVal = pickerWidth - 185.0
        var secXVal = pickerWidth - 45.0
        
        if(self.view.frame.width == 320)
        {
            hourXVal = pickerWidth - 245.0
            minXVal = pickerWidth - 135.0
            secXVal = pickerWidth - 30.0
        }
            
        else if(self.view.frame.width == 414)
        {
            hourXVal = pickerWidth - 325.0
            minXVal = pickerWidth - 185.0
            secXVal = pickerWidth - 45.0
        }
        
        else if(self.view.frame.width == 375)
        {
            hourXVal = pickerWidth - 285.0
            minXVal = pickerWidth - 165.0
            secXVal = pickerWidth - 35.0
        }
        
        let hourLabel = UILabel(frame: CGRect(x:hourXVal, y:88, width: 100, height:40))
        let minuteLabel = UILabel(frame: CGRect(x:minXVal, y:88, width: 100, height:40))
        let secondLabel = UILabel(frame: CGRect(x:secXVal, y:88, width: 100, height:40))
        
        hourLabel.text = "Hours"
        minuteLabel.text = "Minutes"
        secondLabel.text = "Sec"
        
        hourLabel.font = UIFont.boldSystemFont(ofSize: 11)
        minuteLabel.font = UIFont.boldSystemFont(ofSize: 11)
        secondLabel.font = UIFont.boldSystemFont(ofSize: 11)
        
        hourLabel.textColor = UIColor.orange
        minuteLabel.textColor = UIColor.orange
        secondLabel.textColor = UIColor.orange
        
        self.timePickerView.addSubview(hourLabel)
        self.timePickerView.addSubview(minuteLabel)
        self.timePickerView.addSubview(secondLabel)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerViewData[component][row], attributes: [NSForegroundColorAttributeName : UIColor.orange])
        return attributedString
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
