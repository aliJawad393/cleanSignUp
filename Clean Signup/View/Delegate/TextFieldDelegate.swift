
import Foundation
import UIKit


final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    private var endEditingBlock: ((String)->())?
    private var nextResponder: UITextField?
    
    init(nextResponser: UITextField?, endEditingBlock: ((String)->())?) {
        self.endEditingBlock = endEditingBlock
        self.nextResponder = nextResponser
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        endEditingBlock?(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = nextResponder {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
