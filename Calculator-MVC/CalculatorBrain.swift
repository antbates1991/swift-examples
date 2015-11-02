//
//  CalculatorBrain.swift
//  Calculator-MVC
//
//  Created by Anthony Bates on 30/08/2015.
//  Copyright © 2015 Anthony Bates. All rights reserved.
//

// in swift arrays and dictionaries are not classes they are structs.


import Foundation

class CalculatorBrain {
    
    
    private enum Op
    {
        case Operand(Double)
        case UanryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            
            get {
                switch self {
                    case.Operand(let operand) :
                        return "\(operand)"
                    case.UanryOperation(let symbol, _) :
                        return symbol
                    case.BinaryOperation(let symbol, _) :
                        return symbol
                }
            }
            
        }
    }
    
    private var opStack = [Op]()
    
    // create a new dictionary of key (string) and value (Op)
    private var knownOps = [String: Op]()
    
    
    // in swift you can just append the operator to perform actions such as square root, +, * instead of specifiying arument 1 (operation) argument 2
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $0 - $1})
        learnOp(Op.UanryOperation("√", sqrt))
    }
    
    // specifying var inside of the evaluate function allows a mutable copy of the op dictionary, however a cleaner way it to create a new local variable
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                
                // _ in swift means ignore in this case we ignore the symbol.
                case .UanryOperation(_,let operation):
                    let operationEvaluation = evaluate(remainingOps)
                
                    if let operand = operationEvaluation.result {
                        return (operation(operand), operationEvaluation.remainingOps)
                    }
                
                case .BinaryOperation(_,let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    
                    }
                
            }
            
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainingOps) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainingOps) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        
        // in swift you can use square brackets to look something up in a dictionary
        
        // let operation is an optional because you may pass a symbol that doesnt exist in the dictionary, so it will return nil. All dictionary look ups in swift return optionals.
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        
        return evaluate()
        
    }
    
}


