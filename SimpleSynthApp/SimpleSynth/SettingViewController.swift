//
//  ViewController.swift
//  SimpleSynth
//
//  Created by Carter Durno on 11/11/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import UIKit
import Firebase

var exampleSynth = Synth()

class SettingViewController: UIViewController {

    
    var mb = ModuleBoard()
    var baseOsc = Oscillator()
    var freqOsc = Oscillator()
    var intOsc = Oscillator()
    var eg = EnvGenerator()

    var phantomOscButton: UIButton = UIButton()
    
   
    
    @IBOutlet var baseButtons: [UIButton]!
    @IBOutlet var freqButtons: [UIButton]!
    @IBOutlet var intensityButtons: [UIButton]!
    @IBOutlet var intensityFreq: UISlider!
    @IBOutlet var frequencyWaveFreq: UISlider!
    let aestheticOrange = UIColor(red: 255/255, green: 152/255, blue: 0, alpha: 1);
     let ref = FIRDatabase.database().reference()
   
    func updateSettingsMB(newMB: ModuleBoard){
        self.mb = newMB
    }
    @IBAction func attackValueChanged(sender: UISlider) {
        eg.attack = Int(sender.value)
    }
    @IBAction func decayValueChanged(sender: UISlider) {
        eg.decay = Int(sender.value)
    }
    @IBAction func sustainValueChanged(sender: UISlider) {
            eg.sustain = Int(sender.value)
    }
    @IBAction func releaseValueChanged(sender: UISlider) {
            eg.release1 = Int(sender.value)
    }
    @IBAction func sustainLevelChanged(sender: UISlider) {
            eg.sustainLevel = sender.value
    }
    @IBAction func freqFrequencyChanged(sender: UISlider) {
        freqOsc.frequency = sender.value
    }
    
    @IBAction func intensityFrequencyChanged(sender: UISlider) {
        intOsc.frequency = sender.value
    }
    override func viewDidLoad() {
        baseOsc.waveForm = BasicWaves.Sine
        
        for button in baseButtons{
            button.addTarget(self, action: #selector(SettingViewController.setBaseWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        for button in freqButtons{
            button.addTarget(self, action: #selector(SettingViewController.setFreqWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        for button in intensityButtons{
            button.addTarget(self, action: #selector(SettingViewController.setIntensityWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        super.viewDidLoad()
        eg.attack = 100
        eg.decay = 1000
        eg.sustain = 1000
        eg.release1 = 1000
        eg.sustainLevel = 0.5
        mb.theBoard.append(baseOsc)
        mb.theBoard.append(eg)
        exampleSynth.mb = self.mb
        
        // force load landscape
        let temp = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(temp, forKey: "orientation")
        
              // Do any additional setup after loading the view, typically from a nib.
        let feedVC = self.tabBarController?.viewControllers![2] as! FeedViewController
//        feedVC.setUpSharing()
//        print(feedVC)
        
        print("loaded settingVC")
       // feedVC.viewDidLoad()
        setUpSharing()
    }
    
    func setUpSharing(){
        self.tabBarController?.selectedIndex = 2
        self.tabBarController?.selectedIndex = 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func annoyingNoise(sender: AnyObject) {
      //  exampleSynth.keyPressed = true
        exampleSynth.playSin()
        
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
       // print("clicked")
      //  print(mb.toJsonString())
        
        
        //User dialog code is adopted from Andy Ibanez from StackOverflow
        //http://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        var alert = UIAlertController(title: "Share!", message: "Name Your Synth", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Name Here"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            self.mb.name = textField.text!
            let entry = self.ref.child("Synthesizer").childByAutoId()
            entry.child("MB").setValue(self.mb.toJsonString())
            entry.child("user").setValue("MusicLover")
            }))

        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        

    }
        
    @IBAction func playSine(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Sine
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playTriangle(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Triangle
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playSquare(sender: AnyObject) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Square
        newMB.theBoard.append(osc)
        var eg = EnvGenerator()
        eg.attack = 0
        eg.decay = 5000
        newMB.theBoard.append(eg)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playSawtoothWave(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Sawtooth
       // newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    
    enum WaveFormType: Int {case Sine = 0, Triangle = 1, Square = 2, Sawtooth = 3, None = 4}
    func updateSettingDisplay(){
        if (baseOsc.waveForm == nil) {
            phantomOscButton.tag = 4
        }
        else {
        switch(baseOsc.waveForm!){
        
        case .Square:
            phantomOscButton.tag = 2
        case .Sine:
            phantomOscButton.tag = 0
        case .Sawtooth:
            phantomOscButton.tag = 3
        case.Triangle:
            phantomOscButton.tag = 1
        }
            
        }
        setBaseWave(phantomOscButton)
    }
    
    func setBaseWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in baseButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            baseButtons[0].backgroundColor = aestheticOrange
            baseButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Sine
     //       mb.theBoard.append(baseOsc)
            //exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
            
            
            
        case .Triangle:
            baseButtons[1].backgroundColor = aestheticOrange
            baseButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Triangle
        //    mb.theBoard.append(baseOsc)
         //  exampleSynth.mb = mb
           exampleSynth.playSoundFromModule()
            
        case .Square:
            baseButtons[2].backgroundColor = aestheticOrange
            baseButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Square
       //     mb.theBoard.append(baseOsc)
        //    exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
            
        case .Sawtooth:
            baseButtons[3].backgroundColor = aestheticOrange
            baseButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Sawtooth
       //     mb.theBoard.append(baseOsc)
        //    exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
        case .None:
            print("none")
        }
    }
    
    
    func setFreqWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in freqButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            freqButtons[0].backgroundColor = aestheticOrange
            freqButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Sine
            freqOsc.frequency = frequencyWaveFreq.value
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Triangle:
            freqButtons[1].backgroundColor = aestheticOrange
            freqButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Triangle
            freqOsc.frequency = frequencyWaveFreq.value
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Square:
            freqButtons[2].backgroundColor = aestheticOrange
            freqButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Square
            freqOsc.frequency = frequencyWaveFreq.value
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Sawtooth:
            freqButtons[3].backgroundColor = aestheticOrange
            freqButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Sawtooth
            freqOsc.frequency = frequencyWaveFreq.value
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .None:
            freqButtons[4].backgroundColor = aestheticOrange
            freqButtons[4].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.frequencyController = nil
        }
    
    }
    
    func setIntensityWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in intensityButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            intensityButtons[0].backgroundColor = aestheticOrange
            intensityButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Sine
            intOsc.frequency = intensityFreq.value
            baseOsc.intensityController = intOsc
            
        case .Triangle:
            intensityButtons[1].backgroundColor = aestheticOrange
            intensityButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Triangle
            intOsc.frequency = intensityFreq.value
            baseOsc.intensityController = intOsc
            
        case .Square:
            intensityButtons[2].backgroundColor = aestheticOrange
            intensityButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Square
            intOsc.frequency = intensityFreq.value
            baseOsc.intensityController = intOsc
            
        case .Sawtooth:
            intensityButtons[3].backgroundColor = aestheticOrange
            intensityButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Sawtooth
            intOsc.frequency = intensityFreq.value
            baseOsc.intensityController = intOsc
            
        case .None:
            intensityButtons[4].backgroundColor = aestheticOrange
            intensityButtons[4].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.intensityController = nil
        }
    
    }

}

