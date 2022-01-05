//
//  iOSViewControllerFactoryTests.swift
//  Clean SignupTests
//
//  Created by Ali Jawad on 02/12/2021.
//

import Foundation
import XCTest
@testable import Clean_Signup
import ViewControllerPresentationSpy

final class iOSViewControllerFactoryTests: XCTestCase {
    
    func test_createSignupViewController_returnsSignUpViewController() {
        XCTAssertNotNil(createSignUpViewControllerUsingSUT(builder: DummyCredentialsBuilder()))
    }
    
    func test_createSignupViewController_delegateIsSet() {
        let controller = createSignUpViewControllerUsingSUT(builder: DummyCredentialsBuilder())!
        
        XCTAssertNotNil(controller.delegate)
    }
    
    func test_createSignupViewController_reflectsTextFieldValuesToBuilder() {
        let spyBuilder = SpyCredentialsBuilder()
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow(builder: spyBuilder)!

        controller.textFieldName.delegateTextFieldDidEndEditing(text: "Full Name")
        controller.textFieldEmail.delegateTextFieldDidEndEditing(text: "test@email.com")
        controller.textFieldPassword.delegateTextFieldDidEndEditing(text: "password")
        controller.textFieldConfirmPassword.delegateTextFieldDidEndEditing(text: "confirmPassword")
        XCTAssertEqual(spyBuilder.name, "Full Name")
        XCTAssertEqual(spyBuilder.email, "test@email.com")
        XCTAssertEqual(spyBuilder.password, "password")
        XCTAssertEqual(spyBuilder.confirmPassword, "confirmPassword")
    }
    
    func test_createSignupViewController_withCredentialsBuilderThrowsError_shouldShowAlertForEmail() {
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!
        let alertVerifier = AlertVerifier()

        controller.textFieldEmail.delegateTextFieldDidEndEditing()

        verifyAlertIsPresented(controller: controller, verifier: alertVerifier)
    }
    
    func test_createSignupViewController_withCredentialsBuilderThrowsError_shouldShowAlertForPassword() {
        let alertVerifier = AlertVerifier()
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!

        controller.textFieldPassword.delegateTextFieldDidEndEditing()

        verifyAlertIsPresented(controller: controller, verifier: alertVerifier)
    }
    
    func test_createSignupViewController_withCredentialsBuilderThrowsError_shouldShowAlertForConfirmPassword() {
        let alertVerifier = AlertVerifier()
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!

        controller.textFieldConfirmPassword.delegateTextFieldDidEndEditing()

        verifyAlertIsPresented(controller: controller, verifier: alertVerifier)
    }
    
    func test_createSignupViewController_textFieldDelegatesShouldBeSet() {
        let controller = createSignUpViewControllerUsingSUT(builder: FakeCredentialsBuilderForError())!
        
        XCTAssertNotNil(controller.textFieldName.delegate)
        XCTAssertNotNil(controller.textFieldEmail.delegate)
        XCTAssertNotNil(controller.textFieldPassword.delegate)
        XCTAssertNotNil(controller.textFieldConfirmPassword.delegate)
    }
    
    func test_textFieldShouldReturn_textFieldName_textFieldEmailShouldBecomeFirstResponder() {
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!
        
        _ = controller.textFieldName.delegateTextFieldShouldReturn()
        
        XCTAssertEqual(controller.textFieldEmail.isFirstResponder, true)
    }
    
    func test_textFieldShouldReturn_textFieldEmail_textFieldPasswordShouldBecomeFirstResponder() {
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!
        
        _ = controller.textFieldEmail.delegateTextFieldShouldReturn()
        
        XCTAssertEqual(controller.textFieldPassword.isFirstResponder, true)
    }
    
    func test_textFieldShouldReturn_textFieldPassword_textFieldConfirmPasswordShouldBecomeFirstResponder() {
        let controller = createSignUpViewControllerUsingSUT_addViewToWindow()!
        
        _ = controller.textFieldPassword.delegateTextFieldShouldReturn()
        
        XCTAssertEqual(controller.textFieldConfirmPassword.isFirstResponder, true)
    }
    
    //MARK: Private Helpers
    private func createSignUpViewControllerUsingSUT_addViewToWindow(builder: CredentialsBuilder = FakeCredentialsBuilderForError()) -> SignUpViewController? {
        if let controller = createSignUpViewControllerUsingSUT(builder: builder) {
            let window = UIWindow()
            window.addSubview(controller.view)
            return controller
        }
        return nil
    }
    
    private func createSignUpViewControllerUsingSUT(builder: CredentialsBuilder) -> SignUpViewController? {
        makeSUT().createSignupViewController(builder: builder) as? SignUpViewController
    }
    
    private func makeSUT() -> iOSViewControllerFactory {
        iOSViewControllerFactory()
    }
    
    private func verifyAlertIsPresented(controller: UIViewController, verifier: AlertVerifier) {
        verifier.verify(
            title: "Validation Error",
            message: "Incorrect Format",
            animated: true,
            actions: [
                .default("OK"),
            ],
            presentingViewController: controller
        )
    }
}
