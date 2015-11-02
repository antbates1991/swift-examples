//
//  ViewController.swift
//  Calculator - MVC
//
//  Created by Anthony Bates on 17/08/2015.
//  Copyright © 2015 Anthony Bates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfANumber : Bool = false

    // function to append button title to digit
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfANumber{
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfANumber = true
        }
        
        print("digit = \(digit)");
    }
    
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
        
            }
        }
    }
    
    
    @IBAction func enter() {
        
        userIsInTheMiddleOfANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0;
        }
        
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text! = "\(newValue)"
            userIsInTheMiddleOfANumber = false
        }
    
    }
}

