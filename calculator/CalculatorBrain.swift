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
    private let numbers = ["0","1","2","3","4","5","6","7","8","9"]
    init(){
    }
    func eval(str: String) -> String {
        var line: String = str
        // 使用正则表达式一定要加try语句
        do {
            if line.componentsSeparatedByString(bracketLeft).count != line.componentsSeparatedByString(bracketRight).count{
                return "请输入正确的公式"
            }
            while (line.componentsSeparatedByString(bracketLeft).count > 1 && line.componentsSeparatedByString(bracketRight).count > 1) {
                // - 1、创建规则

                let pattern = "\\(([^\\(\\)]*?)\\)"
                // - 2、创建正则表达式对象
                let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                // - 3、开始匹配
                let res = regex.matchesInString(line, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, line.characters.count))
                // 输出结果
                var oldLengthDiff = 0
                for checkingRes in res {
                    
                    var rangeWithBracket:NSRange = checkingRes.range
                    rangeWithBracket.location = rangeWithBracket.location + oldLengthDiff
                    var range:NSRange = rangeWithBracket
                    range.length = range.length - 2
                    range.location = range.location + 1
                    
                    let partWithoutBracket = ((line as NSString).substringWithRange(range))
                    let part = ((line as NSString).substringWithRange(rangeWithBracket))
                    var beforeCh = ""
                    var afterCh = ""
                    let rangeOfBefore: Range<String.Index>
                    let result: Double = simpleEval(partWithoutBracket)
                    if range.location - 2 >= 0 {
                        let indexOfBefore = line.startIndex.advancedBy(range.location - 2)
                        rangeOfBefore = Range<String.Index>(start: indexOfBefore,end: indexOfBefore.advancedBy(1))
                        beforeCh = line.substringWithRange(rangeOfBefore)

                    }
                    if range.location + range.length + 1 <= line.characters.count - 1 {
                        let indexOfAfter = line.startIndex.advancedBy(range.location + range.length + 1)
                        let rangeOfAfter = Range<String.Index>(start: indexOfAfter,end: indexOfAfter.advancedBy(1))
                        afterCh = line.substringWithRange(rangeOfAfter)
                    }
                    
                    if numbers.contains(beforeCh){
                        line = line.stringByReplacingOccurrencesOfString(part, withString: "*\(part)")
                        oldLengthDiff = oldLengthDiff + 1
                    }
                    if numbers.contains(afterCh){
                        line = line.stringByReplacingOccurrencesOfString(part, withString: "\(part)*")
                        oldLengthDiff = oldLengthDiff + 1
                    }
                    line = line.stringByReplacingOccurrencesOfString(part, withString: "\(result)")
                    oldLengthDiff = "\(result)".characters.count - part.characters.count
                    print(line)
                }
            }
        }
        catch {
            print(error)
        }
        return "\(simpleEval(line))"
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
