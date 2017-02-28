import UIKit

class ViewController: UIViewController {
    
    @IBOutlet
    weak var result: UILabel!
    var isWriting = false
    var numbers = Array<Double>()
    var value: Double {
        get {
            return Double(result.text!)!
        }
        set {
            result.text = "\(newValue)"
            isWriting = false
        }
    }
    @IBOutlet weak var cells: UICollectionView!
    
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
    
    @IBAction
    func enter(_ sender: UIButton) {
        numbers.append(value)
        isWriting = false
    }
    
    @IBAction
    func operate(_ sender: UIButton) {
        if numbers.count >= 2 {
            switch sender.currentTitle! {
            case "+":
                value = numbers.popLast()! + numbers.popLast()!
                enter(sender)
            case "-":
                value = numbers.popLast()! - numbers.popLast()!
                enter(sender)
            case "*":
                value = numbers.popLast()! * numbers.popLast()!
                enter(sender)
            case "/":
                value = numbers.popLast()! / numbers.popLast()!
                enter(sender)
            default:
                break;
            }
        }
    }
}


