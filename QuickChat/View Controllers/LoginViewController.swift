//
//  LoginViewController.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    private let emailField = FloatLabelTextField()
    private let passwordField = FloatLabelTextField()
    private let loginButton = PillButton(text: "Login", color: .black, textColor: .white, hasBorder: true)



    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        view.backgroundColor = .white

        let stackView = UIStackView(axis: .vertical)
        view.addSubview(stackView) { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview().inset(32)
        }

        emailField.placeholder = "Email Address"
        emailField.backgroundColor = .clear
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .next
        emailField.autocapitalizationType = .none
        emailField.returnAction.subscribe(onNext: { _ = self.passwordField.becomeFirstResponder() }).add(to: disposer)
        stackView.addArrangedSubview(emailField)

        passwordField.placeholder = "Password"
        passwordField.backgroundColor = .clear
        passwordField.textField.isSecureTextEntry = true
        passwordField.autocorrectionType = .no
        passwordField.keyboardType = .default
        passwordField.returnKeyType = .next
        passwordField.autocapitalizationType = .none
        passwordField.returnAction.subscribe(onNext: { _ = self.passwordField.resignFirstResponder() }).add(to: disposer)
        stackView.addArrangedSubview(passwordField)

        view.addSubview(loginButton) { make in
            make.bottom.equalToSuperview().inset(60)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }

        setupBindings()

    }

    func setupBindings() {
                 loginButton.tap.subscribe(onNext: { self.loginUser() }).add(to: disposer)
          }

    func loginUser() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                print("Failed to login user with error: ", error.localizedDescription)
                return
            }
            let chatVC = ChatViewController()
            chatVC.modalPresentationStyle = .fullScreen
            chatVC.modalTransitionStyle = .crossDissolve
            self?.navigationController?.pushViewController(chatVC, animated: true)
            print("Login Successful")
        }
    }
}
