//
//  RegisterViewController.swift
//  Messagesapp
//
//  Created by Consultant on 8/2/22.
//

import UIKit
import BaronTalk
import JGProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "M")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()

    private let SignUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        SignUpButton.addTarget(
            self,
            action: #selector(SignUpButtonTapped),
            for: .touchUpInside
        )
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(SignUpButton)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds

        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        SignUpButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)


    }
    
    @objc private func SignUpButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty,

            password.count >= 6 else {
                alertUserLoginError()
                return
        }
        spinner.show(in: view)
       
        AuthHandler.createUser(with: email, password: password, completion: {[weak self] authResult in
            guard let strongSelf = self else {
                print("hello")
                return
            }
            guard authResult != nil else {
                print("Error creating user")
                return
            }


            UserDefaults.standard.setValue(email, forKey: "email")
            
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

        })
    
    }
    
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    
}
