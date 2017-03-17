import UIKit

class ViewController: UIViewController {
    
    enum Operator {
        case NONE
        case ADD
        case SUB
        case MUL
        case DIV
    }
    
    @IBOutlet
    weak var result: UILabel!
    var op: Operator = Operator.NONE
    var operand = 0.0
    var isWriting = false
    var hasComma = false
    var stack : Array<Double> = []
    
    var value: Double {
        get {
            return Double(result.text!)!
        }
        set {
            result.text = "\(newValue)"
            isWriting = false
            hasComma = false
        }
    }
    
    func applyBinary(_ operation: (Double, Double) -> Double) {
        stack.append(operand)
        isWriting = false
        value = operation(operand, value)
        operand = value
    }
    
    func applyUnary(_ operation: (Double) -> Double) {
        stack.append(operand)
        isWriting = false
        if op != Operator.NONE {
            apply()
        }
        value = operation(operand)
        operand = value
    }
    
    func apply() {
        switch op {
        case Operator.ADD:
            applyBinary({$0 + $1});
        case Operator.SUB:
            applyBinary({$0 - $1});
        case Operator.MUL:
            applyBinary({$0 * $1});
        case Operator.DIV:
            applyBinary({$0 / $1});
        default:
            break;
        }
        op = Operator.NONE
    }
    
    @IBAction
    func nClick(_ sender: UIButton) {
        if let chiffre = sender.currentTitle {
            if isWriting {
                result.text = result.text! + chiffre
            } else {
                result.text = chiffre
                isWriting = true
            }
        }
    }
    
    @IBAction func comma(_ sender: UIButton) {
        if !hasComma {
            result.text = result.text! + "."
            hasComma = true
        }
    }
    
    @IBAction
    func enter(_ sender: UIButton) {
        apply()
    }
    
    @IBAction
    func operate(_ sender: UIButton) {
        operand = value
        switch sender.currentTitle! {
        case "+":
            isWriting = false
            op = Operator.ADD
        case "-":
            isWriting = false
            op = Operator.SUB
        case "×":
            isWriting = false
            op = Operator.MUL
        case "÷":
            isWriting = false
            op = Operator.DIV
        case "×²":
            applyUnary({$0 * $0})
        case "√":
            applyUnary(sqrt)
        case "cos":
            applyUnary(cos)
        case "sin":
            applyUnary(sin)
        case "tan":
            applyUnary(tan)
        case "log":
            applyUnary(log)
        default:
            break;
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        value = stack.count > 0 ? stack.popLast()! : 0.0
    }
    
    @IBAction func ac(_ sender: UIButton) {
        value = 0.0
        op = Operator.NONE
        operand = 0.0
        isWriting = false
    }
}


