
import XCTest
@testable import Clean_Signup

final class SignUpViewControllerTests: XCTestCase {
    
    func test_defaultState_uiElementsAreInInitialState() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.textFieldName.text, "")
        XCTAssertEqual(sut.textFieldName.text, "")
        XCTAssertEqual(sut.textFieldEmail.text, "")
        XCTAssertEqual(sut.textFieldPassword.text, "")
        XCTAssertEqual(sut.textFieldConfirmPassword.text, "")
        XCTAssertEqual(sut.termsConditionsCheckBox.state, .normal)
        XCTAssertTrue(sut.buttonSignUp.isEnabled)
        
    }
    
    func test_defaultState_placeholderForTextFieldsAreSet() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.textFieldName.placeholder, "Name")
        XCTAssertEqual(sut.textFieldEmail.placeholder, "Email Address")
        XCTAssertEqual(sut.textFieldPassword.placeholder, "Password")
        XCTAssertEqual(sut.textFieldConfirmPassword.placeholder, "Confirm Password")
    }
    
    func test_submitButtonAction_callsRespectiveDelegateMethod() {
        let spyDelegate = SpySignUpViewControllerDelegate()
        let sut = makeSUT(delegate: spyDelegate)
        
        sut.buttonSignUp.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(spyDelegate.didTapSignUpButtonCount, 1)
    }
    
    func test_toggleTermsAndConditionsSwitch_shouldCallRespectiveDelegateMethod() {
        let spyDelegate = SpySignUpViewControllerDelegate()
        let sut = makeSUT(delegate: spyDelegate)
        
        sut.termsConditionsCheckBox.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(spyDelegate.isCheckboxTicked)
        
        sut.termsConditionsCheckBox.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(spyDelegate.isCheckboxTicked)
    }
    
    //MARK: Private Helpers
    private func makeSUT(delegate: SignUpViewControllerDelegate? = nil) -> SignUpViewController {
        let controller = SignUpViewController()
        controller.delegate = delegate
        return controller
    }
}

fileprivate final class SpySignUpViewControllerDelegate: SignUpViewControllerDelegate {
    var didTapSignUpButtonCount: Int = 0
    var isCheckboxTicked = false
    
    func didTapSignUpButton() {
            didTapSignUpButtonCount += 1
    }
    
    func didToggleTermsAndConditionCheckbox(value: Bool) {
        isCheckboxTicked = value
    }
    
    
}






