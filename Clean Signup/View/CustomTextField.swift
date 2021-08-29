
import Foundation
import UIKit

final class CustomTextField: UITextField, UITextFieldDelegate {
    private var endEditingBlock: ((String)->())?
    
    //MARK: Init
    init(endEditingBlock: ((String)->())? = nil) {
        self.endEditingBlock = endEditingBlock
        super.init(frame: .zero)
        borderStyle = .none
        backgroundColor = UIColor(red: 0.096, green: 0.096, blue: 0.096, alpha: 1)
        layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textColor = .white
        font = UIFont.montserratRegular.withAdjustableSize(17)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
        clipsToBounds = true
    }
    
    func setPlaceholder(text: String) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.329, green: 0.329, blue: 0.329, alpha: 1)])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        endEditingBlock?(textField.text ?? "")
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    private struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
    }
}

