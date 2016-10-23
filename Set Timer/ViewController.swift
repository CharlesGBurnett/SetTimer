//
//  ViewController.swift
//  Set Timer
//
//  Created by Charles Burnett on 10/9/16.
//  Copyright © 2016 Charles Burnett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var repButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var timer = Timer()
    var counter = 0
    var minutes = 0
    var seconds = 0
    var isPaused = false
        
    var setCounter = 0
    var repCounter = 0
    
    var pickerViewData = [["a"], ["b"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        var hourList = [String]()
        var minuteList = [String]()
        var secondList = [String]()
        
        for i in 0...23{
            print("\(String(i))")
            hourList.append(String(i))
        }
        for i in 0...59{
            minuteList.append(String(i))
            secondList.append(String(i))
        }
        pickerViewData = [hourList, minuteList, secondList]
        
    }
    
    override func viewDidLayoutSubviews() {
        setButton.layer.cornerRadius = setButton.frame.width / 2.0
        repButton.layer.cornerRadius = repButton.frame.width / 2.0
        timerButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setPressed(_ sender: AnyObject){
        setCounter += 1
        setButton.setTitle("Set \(setCounter)", for: UIControlState.normal)
        repCounter = 0
        repButton.setTitle("Reps", for: UIControlState.normal)
    }

    @IBAction func repPressed(_ sender: AnyObject) {
        repCounter += 1
        repButton.setTitle("\(repCounter) Reps", for: UIControlState.normal)
    }
    
    @IBAction func startPressed(_ sender: AnyObject) {
        
        if counter == 0 {
            timerNotSetAlert()
            return
        }
                
            
        else {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func resetPressed(_ sender: AnyObject) {
        setCounter = 0
        repCounter = 0
        setButton.setTitle("Sets", for: UIControlState.normal)
        repButton.setTitle("Reps", for: UIControlState.normal)
        timer.invalidate()
        timerButton.setTitle("Start", for: UIControlState.normal)
    }
    @IBAction func pauseTimer(_ sender: AnyObject) {
        if isPaused == false {
        timer.invalidate()
        pauseButton.setTitle("Play", for: UIControlState.normal)
        isPaused = true
        }
        else {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        pauseButton.setTitle("Pause", for: UIControlState.normal)
        isPaused = false
        }
    }
    
    func timerAction() {
        if counter == 0 {
           timer.invalidate()
            return
        }
        
        counter -= 1
        let (hours,minutes,seconds) = secondsToHoursMinutesSeconds(seconds: counter)
        if hours == 0 {
            if seconds >= 10 {
                timerButton.setTitle("\(minutes):\(seconds)", for: UIControlState.normal)
            }
            else
            {
                timerButton.setTitle("\(minutes):0\(seconds)", for: UIControlState.normal)
            }
        }
        else
        {
            if minutes >= 10 && seconds >= 10 {
                timerButton.setTitle("\(hours):\(minutes):\(seconds)", for: UIControlState.normal)
            }
            if minutes >= 10 && seconds < 10 {
                timerButton.setTitle("\(hours):\(minutes):0\(seconds)", for: UIControlState.normal)
            }
            if minutes < 10 && seconds >= 10 {
                timerButton.setTitle("\(hours):0\(minutes):\(seconds)", for: UIControlState.normal)
            }
            else
            {
                timerButton.setTitle("\(hours):0\(minutes):0\(seconds)", for: UIControlState.normal)
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timerNotSetAlert()
    {
        let alert = UIAlertController(title: "No time set", message: "Please set the time for the timer", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        print("picked number: \(pickerViewData[component][row])")
    }
}

