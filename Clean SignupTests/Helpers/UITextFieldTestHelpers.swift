
import Foundation
import UIKit

extension UITextContentType: CustomStringConvertible {
    public var description: String { rawValue }
}

extension UITextAutocorrectionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .no:
            return "no"
        case .yes:
            return "yes"
        @unknown default:
            fatalError("Unknown UITextAutocorrectionType")
            
        }
    }
}

extension UIReturnKeyType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .next:
            return "next"
        case .continue:
            return "continue"
        case .done:
            return "done"
        case .emergencyCall:
            return "emergencyCall"
        case .go:
            return "go"
        case .google:
            return "google"
        case .join:
            return "join"
        case .route:
            return "route"
        case .search:
            return "search"
        case .send:
            return "send"
        case .yahoo:
            return "yahoo"
        @unknown default:
            return "unknown"
        }
    }
}

extension UIKeyboardType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .asciiCapable:
            return "asciiCapable"
        case .numbersAndPunctuation:
            return "numbersAndPunctuation"
        case .URL:
            return "URL"
        case .numberPad:
            return "numberPad"
        case .phonePad:
            return "phonePad"
        case .namePhonePad:
            return "namePhonePad"
        case .emailAddress:
            return "emailAddress"
        case .decimalPad:
            return "decimalPad"
        case .twitter:
            return "twitter"
        case .webSearch:
            return "webSearch"
        case .asciiCapableNumberPad:
            return "asciiCapableNumberPad"
        @unknown default:
            return "Unknown"
        }
    }
}

extension UITextAutocapitalizationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .words:
            return "words"
        case .allCharacters:
            return "allCharacters"
        case .none:
            return "none"
        case .sentences:
            return "sentences"
            
        @unknown default:
            return "unknown"
        }
    }
}

extension UITextField {
    func delegateTextFieldDidEndEditing(text: String? = nil) {
        self.text = text
        delegate?.textFieldDidEndEditing?(self, reason: .committed)
    }
    
    func delegateTextFieldShouldReturn() -> Bool? {
        delegate?.textFieldShouldReturn?(self)
    }
}



