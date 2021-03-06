//
//  EnvGenerator.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
class EnvGenerator: SoundModule{
    //Attack, Decay, Sustain, and Release are in units of ms
    //SustainLevel is in unit of gain, 1 being unity gain
    var attack: Int = 0
    var decay: Int = 1000
    var sustain: Int = 2000
    var sustainLevel: Float = 0.5
    var intensity: Float = 1
    var release1: Int = 2000
    var keyHeld: Bool = false
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "attack":
            attack = (value as? Int)!
        case "release1":
            release1 = (value as? Int)!
        case "keyHeld":
            keyHeld = (value as? Bool)!
        case "sustainLebel":
            sustainLevel = (value as? Float)!
        case "intensity":
            intensity = (value as? Float)!
        case "decay":
            decay = (value as? Int)!
        case "sustain":
            sustain = (value as? Int)!
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }

    override func getOutput(inputValue: Float,index: Int)->Float{
        var output: Float = inputValue
        //attack phase
        if (index < attack*Int(samplingRate)/1000){
            let factor = Float(index) / (Float(attack)*samplingRate/1000)
           // print(slope)
            output = output*factor*intensity
        }
            
        //decay phase
        else if (index < (attack+decay)*Int(samplingRate)/1000){
            let decayIndex = index - (attack)*Int(samplingRate)/1000
            let factor = (Float(decayIndex)*(sustainLevel-1.0) / (Float(decay)*samplingRate/1000))+1.0
          //  print(factor)
            output = output*factor*intensity
        }
            
        //sustain phase
        else if (index < (attack+decay+sustain)*Int(samplingRate)/1000 || keyHeld){
            output = output*sustainLevel*intensity
            
        }
            
        //release phase
        else if (index < (attack+decay+sustain+release1)*Int(samplingRate)/1000){
            let relIndex = index - (attack+decay+sustain)*Int(samplingRate)/1000
            let factor = (Float(relIndex)*(-sustainLevel) / (Float(release1)*samplingRate/1000))+sustainLevel
            //  print(factor)
            output = output*factor*intensity
        }
        else {
            output = 0
        }
        
       return output
    }
    
//    override func updateInputParameter(input: Float){
//        indexOfLastTrigger = Int(input)
//    }
}