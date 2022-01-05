

import XCTest
@testable import Clean_Signup

final class SignUpViewControllerTextFieldsTests: XCTestCase {
    func test_textFieldName_attributesShouldBeSet() {
        let textField = makeSUT().textFieldName
        
        XCTAssertEqual(textField.textContentType, .name, "textContentType")
        XCTAssertEqual(textField.autocorrectionType, .no, "autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
        XCTAssertEqual(textField.autocapitalizationType, .words, "autocapitalizationType")
    }
    
    func test_textFieldEmail_attributesShouldBeSet() {
        let textField = makeSUT().textFieldEmail
        
        XCTAssertEqual(textField.textContentType, .emailAddress, "textContentType")
        XCTAssertEqual(textField.keyboardType, .emailAddress, "keyboardType")
        XCTAssertEqual(textField.autocapitalizationType, .none, "autocapitalizationType")
        XCTAssertEqual(textField.autocorrectionType, .no, "autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
    }
    
    func test_textFieldPassword_attributesShouldBeSet() {
        let textField = makeSUT().textFieldPassword
        
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
    }
    
    func test_textFieldConfirmPassword_attributesShouldBeSet() {
        let textField = makeSUT().textFieldConfirmPassword
        
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertEqual(textField.returnKeyType, .done, "returnKeyType")
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
    }
    
    //MARK: Helper Methods
    private func makeSUT()->SignUpViewController {
        SignUpViewController()
    }
}
