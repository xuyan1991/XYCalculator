//
//  CalculatorBrain.swift
//  
//
//  Created by 徐岩 on 16/3/3.
//
//

import Foundation

class CalculatorBrain {
    private let plus = "+"
    private let minus = "-"
    private let multi = "*"
    private let devide = "/"
    
    private let bracketLeft = "("
    private let bracketRight = ")"
    init(){
    }
    func eval(str: String) -> Double {
        var line: String = str
        // 使用正则表达式一定要加try语句
        do {
            while (line.componentsSeparatedByString(bracketLeft).count > 1) {
                // - 1、创建规则
                let pattern = "\\(([^\\(\\)]*?)\\)"
                // - 2、创建正则表达式对象
                let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                // - 3、开始匹配
                let res = regex.matchesInString(line, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
                // 输出结果
                for checkingRes in res {
                    var part = ((line as NSString).substringWithRange(checkingRes.range))
                    var result: Double = simpleEval(part)
                    line = line.stringByReplacingOccurrencesOfString(part, withString: "\(result)")
                    print(part)
                }
            }
        }
        catch {
            print(error)
        }
        return simpleEval(str)
    }
    
    func simpleEval(str:String) -> Double{
        var valueStack: [Double] = [Double]()
        var opStack:[Character] = [Character]()
        var isOper: Bool = false
        var temValue:String = ""
        var index: Int = 0
        for ch: Character in str.characters {
            if String(ch) == plus || String(ch) == minus || String(ch) == multi || String(ch) == devide{
                var num = (temValue as NSString ).doubleValue
                if isOper{
                    let num1 = valueStack.removeLast()
                    let op = opStack.removeLast()
                    var result = simpleTwoEval(op, value1: num1, value2: num)
                    num = result
                }
                valueStack.append(num)
                opStack.append(ch)
                temValue = ""
                isOper = false
                if String(ch) == multi || String(ch) == devide{
                    isOper = true
                }
            }
            else{
                temValue = "\(temValue)\(ch)"
                if index == (str.characters.count - 1){
                    var num = (temValue as NSString ).doubleValue
                    if isOper{
                        let num1 = valueStack.removeLast()
                        let op = opStack.removeLast()
                        var result = simpleTwoEval(op, value1: num1, value2: num)
                        num = result
                    }
                    valueStack.append(num)
                    isOper = false
                }
                
            }
            index = index + 1
         
            
        }
        valueStack = valueStack.reverse()
        opStack = opStack.reverse()
        while valueStack.count > 1 {
            let num1 = valueStack.removeLast()
            let num2 = valueStack.removeLast()
            let op = opStack.removeLast()
            var result = simpleTwoEval(op, value1: num1, value2: num2)
            valueStack.append(result)
        }
        
        return valueStack.first!
    }
    func simpleTwoEval(op: Character, value1:Double, value2:Double) -> Double {
        switch String(op){
        case plus: return value1 + value2
        case minus: return value1 - value2
        case multi: return value1 * value2
        case devide: return value1 / value2
        default: return 0.0
        }
    }
    
}
