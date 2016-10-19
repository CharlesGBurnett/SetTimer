//
//  ViewController.swift
//  Set Timer
//
//  Created by Charles Burnett on 10/9/16.
//  Copyright © 2016 Charles Burnett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var repButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var timer = Timer()
    var counter = 0
    var minutes = 0
    var seconds = 0
    var isPaused = false
        
    var setCounter = 0
    var repCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.isHidden = true
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
    }

    @IBAction func repPressed(_ sender: AnyObject) {
        repCounter += 1
        repButton.setTitle("Rep \(repCounter)", for: UIControlState.normal)
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
}

