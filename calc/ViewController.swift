import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var par: UIButton!
    var brain = Brain()
    var value: Double {
        get { return Double(result.text!)! }
        set { result.text = "\(newValue)" }
    }
    
    @IBAction func back(_ sender: UIButton) {
        switch text.text![text.text!.length-1] {
        case ")":
            par.setTitle(")", for: UIControlState.normal)
        case "(":
            par.setTitle("(", for: UIControlState.normal)
        default:
            break
        }
        brain.back(&text.text!)
        calc()
    }
    
    @IBAction func ac(_ sender: UIButton) {
        text.text = ""
        value = 0.0
    }
    
    func calc() {
        do {
            value = try brain.eval(text.text!)
        } catch {
            result.text = "ERR"
        }
    }
    
    @IBAction func append(_ sender: UIButton) {
        switch sender.currentTitle! {
        case ".":
            if text.text?.characters.last == "." {
                return
            }
            text.text?.append(sender.currentTitle!)
            do { try brain.eval(text.text!) }
            catch Brain.ParseError.twoOrMoreComma {
                text.text?.remove(
                    at: (text.text?.index(before: (text.text?.endIndex)!))!
                )
            } catch {}
        case "(":
            text.text?.append(sender.currentTitle!)
            sender.setTitle(")", for: UIControlState.normal)
        case ")":
            text.text?.append(sender.currentTitle!)
            sender.setTitle("(", for: UIControlState.normal)
            calc()
        case "√":
            text.text?.append(sender.currentTitle!)
        default:
            text.text?.append(" " + sender.currentTitle! + " ")
        }
    }
    
    @IBAction func appendAndCalc(_ sender: UIButton) {
        text.text?.append(sender.currentTitle!)
        calc()
    }
    
    
}


