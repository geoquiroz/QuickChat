//
//  WelcomeViewController.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let registerButton = PillButton(text: "Register", color: .black, textColor: .white ,hasBorder: true)
    private let loginButton = PillButton(text: "Login", color: .black, textColor: .white,  hasBorder: true)


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Welcome"

        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 36
        view.addSubview(stackView) { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(120)
        }


        stackView.addArrangedSubview(registerButton) {make in
            make.height.equalTo(60)
        }
        stackView.addArrangedSubview(loginButton) { make in
            make.height.equalTo(60)
        }
        setupBindings()
    }

    private func setupBindings() {
        registerButton.tap.subscribe(onNext: { _ in
            self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        }).add(to: disposer)

        loginButton.tap.subscribe(onNext: {
            _ in self.navigationController?.pushViewController(LoginViewController(), animated: true)
        })
    }
}
