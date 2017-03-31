import Foundation

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> Character {
        if i >= length {
            return "$"
        }
        let start = index(startIndex, offsetBy: i)
        return self[start]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}

class Brain {
    
    enum ParseError : Error {
        case missingRightPar
        case unknownFunc
        case twoOrMoreComma
    }
    
    indirect enum Expr {
        case value(Double)
        case unary(Expr, (Double) -> Double)
        case binary(Expr, Expr, (Double, Double) -> Double)
        
        func eval() -> Double {
            switch self {
            case let .value(n):
                return n
            case let .unary(r1, fn):
                return fn(r1.eval())
            case let .binary(r1, r2, fn):
                return fn(r1.eval(), r2.eval())
            }
        }
    }
    
    func primary_expression(_ word : String, _ i : inout Int) throws -> Expr {
        while word[i] == " " {
            i = i + 1
        }
        switch word[i] {
        case "(":
            i = i + 1
            let r1 = try expression(word, &i)
            if word[i] != ")" {
                throw ParseError.missingRightPar
            }
            i = i + 1
            return r1
        case "√":
            i = i + 1
            return Expr.unary(try expression(word, &i), sqrt)
        case "c", "s", "t", "l":
            switch word[i ..< i+3] {
            case "cos":
                i = i + 3
                return Expr.unary(try expression(word, &i), cos)
            case "sin":
                i = i + 3
                return Expr.unary(try expression(word, &i), sin)
            case "tan":
                i = i + 3
                return Expr.unary(try expression(word, &i), tan)
            case "log":
                i = i + 3
                return Expr.unary(try expression(word, &i), log)
            default:
                throw ParseError.unknownFunc
            }
        default:
            var num = ""
            var hasComma = false
            while (word[i] >= "0" && word[i] <= "9") || word[i] == "." {
                if word[i] == "." {
                    if hasComma {
                        throw ParseError.twoOrMoreComma
                    }
                    hasComma = true
                }
                num.append(word[i])
                i = i + 1
            }
            return Expr.value(Double(num)!)
        }
    }
    
    func postfix_expression(_ word : String, _ i : inout Int) throws -> Expr {
        var r1 = try primary_expression(word, &i)
        while true {
            switch word[i] {
            case "²":
                i = i + 1
                r1 = Expr.unary(r1, {$0 * $0})
            case " ":
                i = i + 1
            default:
                return r1
            }
        }
    }
    
    func multipilcative_expression(_ word : String, _ i : inout Int) throws -> Expr {
        var r1 = try postfix_expression(word, &i)
        while true {
            switch word[i] {
            case "×":
                i = i + 1
                r1 = Expr.binary(r1, try postfix_expression(word, &i), {$0 * $1})
            case "÷":
                i = i + 1
                r1 = Expr.binary(r1, try postfix_expression(word, &i), {$0 / $1})
            case " ":
                i = i + 1
            default:
                return r1
            }
        }
    }
    
    func expression(_ word : String, _ i : inout Int) throws -> Expr {
        var r1 = try multipilcative_expression(word, &i)
        while true {
            switch word[i] {
            case "+":
                i = i + 1
                r1 = Expr.binary(r1, try multipilcative_expression(word, &i), {$0 + $1})
            case "-":
                i = i + 1
                r1 = Expr.binary(r1, try multipilcative_expression(word, &i), {$0 - $1})
            case " ":
                i = i + 1
            default:
                return r1
            }
        }
    }
    
    func eval(_ word : String) throws -> Double {
        var i = 0
        var r = try expression(word, &i);
        while i < word.length {
            r = Expr.binary(r, try expression(word, &i), {$0 * $1})
        }
        return r.eval()
    }
}
