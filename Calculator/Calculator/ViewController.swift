//
//  ViewController.swift
//  Calculator
//
//  Created by Anthony Bates on 17/08/2015.
//  Copyright © 2015 Anthony Bates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
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
        
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfANumber {
            enter()
        }
        switch operation{
            
            // in swift if a function has only 1 argument you can delete the brackets and have the parameter outside at the end.
            // if you have more than one arguement the last one can go at the end outside of the brackets, the rest must go inside.
        case "x": performOperation { $0 * $1 }
            
            // number dividing by goes last on the stack
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "-": performOperation { $0 - $1 }
        case "√": performOperation2 { sqrt($0) }
            
            // if no cases match, break out
        default: break
        }
    }
    
    // IMPORTANT! Swift can cope with 2 functions being called the same, as one accepts 2 arguments, the other accepts 1 argument. Swift is capable at looking how many arguments the function requires and how many it has been supplied with to determine which of the 2 functions with the same name should be ran.
    
    // TODO change functions to the same name, in Xcode 7 beta this currently doesn't work and throws an objective-c error, despite the app being written in swift.
    
    // performs calculator operation, takes 2 doubles and returns a double
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // performs calculator operation, takes 1 double and returns a double
    func performOperation2(operation: Double -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // declair operand stack - an array of doubles
    var operandStack = Array<Double>()

    
    @IBAction func enter() {
        
        userIsInTheMiddleOfANumber = false
        operandStack.append(displayValue)
        
        print("operandStack = \(operandStack)")
        
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

