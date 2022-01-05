
import Foundation
import iOSSnapshotTestCase
@testable import Clean_Signup

 final class SignUpViewControllerSnapshotTests:  FBSnapshotTestCase {
     override func setUp() {
         super.setUp()
         recordMode = false
     }
 
     func test_signUpViewControllerAppearance_initialState() {
         let sut = SignUpViewController()
         FBSnapshotVerifyViewController(sut)
     }
     
     func test_signUpViewControllerAppearance_withUserInput() {
         let sut = SignUpViewController()
         sut.textFieldName.text = "Full Name"
         sut.textFieldEmail.text = "test@email.com"
         sut.textFieldPassword.text = "password"
         sut.textFieldConfirmPassword.text = "password"
         sut.termsConditionsCheckBox.isSelected = true
         FBSnapshotVerifyViewController(sut)
     }
 }
