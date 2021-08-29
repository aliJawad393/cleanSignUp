
import XCTest
@testable import Clean_Signup

class SignUpViewControllerTests: XCTestCase {
    func test_defaultState_uiElementsAreInInitialState() {
        let sut = makeSUT()
        XCTAssertTrue(sut.textFieldName.text == "")
        XCTAssertTrue(sut.textFieldEmail.text == "")
        XCTAssertTrue(sut.textFieldPassword.text == "")
        XCTAssertTrue(sut.textFieldConfirmPassword.text == "")
        XCTAssertTrue(sut.termsConditionsCheckBox.state == .normal)
        XCTAssertTrue(sut.buttonSignUp.isEnabled)

    }

    func test_defaultState_placeholderForTextFieldsAreSet() {
        let sut = makeSUT()
        XCTAssertEqual(sut.textFieldName.placeholder, "Name")
        XCTAssertEqual(sut.textFieldEmail.placeholder, "Email Address")
        XCTAssertEqual(sut.textFieldPassword.placeholder, "Password")
        XCTAssertEqual(sut.textFieldConfirmPassword.placeholder, "Confirm Password")
    }
    
    func test_setTextForTextFields_reflectsValuesToBuilder() {
        let spyBuilder = SpyCredentialsBuilder()
        let sut = makeSUT(builder: spyBuilder) {_ in}
        let window = UIWindow()
        window.addSubview(sut.view)
        uitextfield_setText_makeAndResignFirstResponser(textField: sut.textFieldName, text: "Full Name")
        uitextfield_setText_makeAndResignFirstResponser(textField: sut.textFieldEmail, text: "test@email.com")
        uitextfield_setText_makeAndResignFirstResponser(textField: sut.textFieldPassword, text: "password")
        uitextfield_setText_makeAndResignFirstResponser(textField: sut.textFieldConfirmPassword, text: "confirmPassword")
        
        XCTAssertEqual(spyBuilder.name, "Full Name")
        XCTAssertEqual(spyBuilder.email, "test@email.com")
        XCTAssertEqual(spyBuilder.password, "password")
        XCTAssertEqual(spyBuilder.confirmPassword, "confirmPassword")

        sut.submitHandler(sender: UIButton())
    }
    
    
    func test_selectUnselectCheckBox_reflectsValueToBuilder() {
        let spyBuilder = SpyCredentialsBuilder()
        let sut = makeSUT(builder: spyBuilder) {_ in}
        XCTAssertFalse(spyBuilder.isTicked)
        sut.toggleCheckboxSelection()
        XCTAssertTrue(spyBuilder.isTicked)
    }
    
    
    func test_signUpBlockGetsCalledOnButtonTap() {
        var count = 0
        let sut = makeSUT(builder: DummyCredentialsBuilder()) { _ in
            count = count + 1
        }
        sut.submitHandler(sender: UIButton())
        XCTAssertEqual(count, 1)
    }
    
    func test_signUpBlockReturnsCorrectUserCredentialsValues() {
        let builder = SpyCredentialsBuilder()
        builder.setName(name: "Clean Signup")
        try! builder.setEmail(email: "clean@signup.com")
        try! builder.setPassword(password: "Password")
        let sut = makeSUT(builder: builder) { modified in
            let userCredentials = try? modified.build()
            XCTAssertEqual(userCredentials?.name, "Clean Signup")
            XCTAssertEqual(userCredentials?.email, "clean@signup.com")
            XCTAssertEqual(userCredentials?.password, "Password")
        }
        sut.submitHandler(sender: UIButton())
    }
    
    //MARK: Private Helpers
    private func uitextfield_setText_makeAndResignFirstResponser(textField: UITextField, text: String) {
        textField.becomeFirstResponder()
        textField.text = text
        textField.resignFirstResponder()
    }
    
    private func makeSUT(builder: CredentialsBuilder = DummyCredentialsBuilder(), signUpBlock: @escaping(CredentialsBuilder)->() = {_ in }) -> SignUpViewController {
        return SignUpViewController(builder: builder, signUpBlock: signUpBlock)
    }
}

fileprivate class DummyCredentialsBuilder: CredentialsBuilder {
    func setName(name: String) {}
    
    func setEmail(email: String) throws {}
    
    func setPassword(password: String) throws {}
    
    func setConfirmPassword(password: String) throws {}
    
    func setTicked(isTicked: Bool) {}
    
    func build() throws -> UserCredentials {
        return UserCredentials(name: "", email: "", password: "")
    }
}

fileprivate class SpyCredentialsBuilder: CredentialsBuilder {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isTicked = false
    
    func setName(name: String) {
        self.name = name
    }
    
    func setEmail(email: String) throws {
        self.email = email
    }
    
    func setPassword(password: String) throws {
        self.password = password
    }
    
    func setConfirmPassword(password: String) throws {
        self.confirmPassword = password
    }
    
    func setTicked(isTicked: Bool) {
        self.isTicked = isTicked
    }
    
    func build() throws -> UserCredentials {
        return UserCredentials(name: name, email: email, password: password)
    }
}
