import UIKit
import SafariServices

final class SignUpViewController: UIViewController {
    
    //MARK: Vars
    private var builder: CredentialsBuilder
    private let signUpBlock: (CredentialsBuilder)->()
    
    //MARK: View component
    private lazy var stackViewContent: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 20
        view.alignment = .fill
        
        let labelSignUp = UILabel()
        labelSignUp.translatesAutoresizingMaskIntoConstraints = false
        labelSignUp.text = "Sign Up"
        labelSignUp.font = UIFont.montserratExtraBold.withAdjustableSize(29)
        labelSignUp.textColor = .white
        
        view.addArrangedSubview(labelSignUp)
        view.addArrangedSubview(textFieldName)
        view.addArrangedSubview(textFieldEmail)
        view.addArrangedSubview(textFieldPassword)
        view.addArrangedSubview(textFieldConfirmPassword)
        view.addArrangedSubview(stackViewTermsAndConditions)
        view.addArrangedSubview(stackViewSignUp)
        
        return view
    }()
    
    private lazy var buttonSignUp: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor(red: 0.71, green: 0.408, blue: 0.231, alpha: 1)
        view.setTitle("Sign Up", for: .normal)
        view.titleLabel?.font = UIFont.montserratSemiBold.withAdjustableSize(17)
        view.setTitleColor(.white, for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.addTarget(self, action: #selector(submitHandler(sender:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackViewSignUp: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        
        view.addArrangedSubview(buttonSignUp)
        view.addArrangedSubview(UIView())
        return view
    }()
    
    private lazy var textFieldName: UITextField = {
        let view = CustomTextField {[weak self] text in
            self?.builder.setName(name: text)
        }
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.setPlaceholder(text: "Name")
        return view
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let view = CustomTextField{[weak self] text in
            do {
                try self?.builder.setEmail(email: text)
            } catch let error {
                self?.alert("Validation Error", message: error.localizedDescription)
            }
        }
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.setPlaceholder(text: "Email Address")
        return view
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let view = CustomTextField{[weak self] text in
            do {
                try self?.builder.setPassword(password: text)
            } catch let error {
                self?.alert("Error", message: error.localizedDescription)
            }
        }
        view.setPlaceholder(text: "Password")
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var textFieldConfirmPassword: UITextField = {
        let view = CustomTextField{[weak self] text in
            do {
                try self?.builder.setConfirmPassword(password: text)
            } catch let error {
                self?.alert("Error", message: error.localizedDescription)
            }
        }
        view.setPlaceholder(text: "Confirm Password")
        view.isSecureTextEntry = true
        return view
    }()
        
    private lazy var stackViewTermsAndConditions: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        
        let buttonTnC = UIButton(type: .system)
        buttonTnC.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratRegular.withAdjustableSize(9),
            .foregroundColor: UIColor(red: 0 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedTitle = NSMutableAttributedString(string: " Terms and Conditions*",
                                                        attributes: attributes)
        buttonTnC.setAttributedTitle(attributedTitle, for: .normal)
        buttonTnC.addTarget(self, action: #selector(termsHandler(sender:)), for: .touchUpInside)
        
        view.addArrangedSubview(termsConditionsCheckBox)
        view.addArrangedSubview(buttonTnC)
        view.addArrangedSubview(UIView())
        return view
    }()
    
    private lazy var termsConditionsCheckBox: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.init(named: "iconCheckboxOutlined"), for: .normal)
        view.setImage(UIImage.init(named: "iconCheckboxFilled"), for: .selected)
        view.addTarget(self, action: #selector(toggleCheckboxSelection), for: .touchUpInside)
        view.setTitle("  I agree to the ", for: .normal)
        view.setTitleColor(UIColor(red: 0.329, green: 0.329, blue: 0.329, alpha: 1), for: .normal)
        view.titleLabel?.font = UIFont.montserratRegular.withAdjustableSize(9)
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .gray
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    //MARK: Init
    init(builder: CredentialsBuilder, signUpBlock: @escaping(CredentialsBuilder)->()) {
        self.builder = builder
        self.signUpBlock = signUpBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonSignUp.layoutIfNeeded()
        buttonSignUp.layer.cornerRadius = buttonSignUp.bounds.size.height / 2
        buttonSignUp.clipsToBounds = true
    }
    
    //MARK: Action
    @objc func submitHandler(sender: UIButton) {
        view.endEditing(true)
        signUpBlock(builder)
    }
    
    @objc func helpHandler(sender: UIButton) {
        
    }
    
    @objc func signInHandler(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleCheckboxSelection() {
        termsConditionsCheckBox.isSelected = !termsConditionsCheckBox.isSelected
        builder.setTicked(isTicked: termsConditionsCheckBox.isSelected)
    }
    
    @objc func termsHandler(sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/terms.php"){
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    
    @objc func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.1) {[weak self] in
            guard let stackView = self?.stackViewContent, let view = self?.view else {return}
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.65, constant: 0),
            ])
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.1) {[weak self] in
            guard let stackView = self?.stackViewContent, let view = self?.view else {return}
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0),
            ])
            view.layoutIfNeeded()
        }
    }
}

//MARK: Helper
private extension SignUpViewController {
    private func displayLoadingIndicator(_ loading: Bool) {
        view.isUserInteractionEnabled = !loading
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

//MARK: Setup View
private extension SignUpViewController {
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 1)
        view.addSubview(stackViewContent)
        view.addSubview(loadingIndicator)
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            stackViewContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackViewContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            NSLayoutConstraint(item: stackViewContent, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0),
                                                
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
