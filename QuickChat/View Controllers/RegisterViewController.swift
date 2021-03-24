//
//  RegisterViewController.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    private let firstNameField = FloatLabelTextField()
    private let lastNameField = FloatLabelTextField()
    private let emailField = FloatLabelTextField()
    private let passwordField = FloatLabelTextField()
    private let signUpButton = PillButton(text: "Register", color: .black, textColor: .white, hasBorder: true)



    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        view.backgroundColor = .white

        let stackView = UIStackView(axis: .vertical)
        view.addSubview(stackView) { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview().inset(32)
        }

        firstNameField.placeholder = "First Name"
        firstNameField.backgroundColor = .clear
        firstNameField.autocorrectionType = .no
        firstNameField.keyboardType = .default
        firstNameField.returnKeyType = .done
        firstNameField.returnAction.subscribe(onNext: {_ = self.lastNameField.resignFirstResponder()}).add(to: disposer)
        stackView.addArrangedSubview(firstNameField)

        lastNameField.placeholder = "Last Name"
        lastNameField.backgroundColor = .clear
        lastNameField.autocorrectionType = .no
        lastNameField.keyboardType = .default
        lastNameField.returnKeyType = .next
        lastNameField.autocapitalizationType = .none
        lastNameField.returnAction.subscribe(onNext: { _ = self.emailField.resignFirstResponder() }).add(to: disposer)
        stackView.addArrangedSubview(lastNameField)

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

        view.addSubview(signUpButton) { make in
            make.bottom.equalToSuperview().inset(60)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }

        setupBindings()

    }

    func setupBindings() {
        signUpButton.tap.subscribe(onNext: { self.createUser() }).add(to: disposer)
    }

    func createUser() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Failed to sign up user with error: ", error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }
            let userData = ["first_name": self?.firstNameField.text ?? "",
                            "last_name": self?.lastNameField.text ?? "",
                            "uid": uid,
                            "email": self?.emailField.text ?? ""]
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: userData) { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

            }
        }
    }



}

