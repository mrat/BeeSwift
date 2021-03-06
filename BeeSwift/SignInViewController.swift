//
//  SignInViewController.swift
//  BeeSwift
//
//  Created by Andy Brett on 4/26/15.
//  Copyright (c) 2015 APB. All rights reserved.
//

import Foundation
import TwitterKit
import FBSDKLoginKit
import MBProgressHUD

class SignInViewController : UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UITextFieldDelegate, UIAlertViewDelegate {
    
    var headerLabel = BSLabel()
    var emailTextField = BSTextField()
    var passwordTextField = BSTextField()
    var newEmailTextField = BSTextField()
    var newUsernameTextField = BSTextField()
    var newPasswordTextField = BSTextField()
    var chooseSignInButton = BSButton()
    var chooseSignUpButton = BSButton()
    var beeImageView = UIImageView()
    var signUpButton = BSButton()
    var backToSignInButton = BSButton()
    var backToSignUpButton = BSButton()
    var signInButton = BSButton()
    var facebookLoginButton : FBSDKLoginButton = FBSDKLoginButton()
    var twitterLoginButton : TWTRLogInButton = TWTRLogInButton()
    var googleSigninButton = GIDSignInButton()
    var divider = UIView()
    
    override func viewDidLoad() {
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleFailedSignIn(_:)), name: NSNotification.Name(rawValue: CurrentUserManager.failedSignInNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleFailedSignUp(_:)), name: NSNotification.Name(rawValue: CurrentUserManager.failedSignUpNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSignedIn(_:)), name: NSNotification.Name(rawValue: CurrentUserManager.signedInNotificationName), object: nil)
        self.view.backgroundColor = UIColor.white
        
        scrollView.addSubview(self.chooseSignInButton)
        self.chooseSignInButton.setTitle("I have a Beeminder account", for: .normal)
        self.chooseSignInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.centerY).offset(-10)
            make.width.equalTo(self.view).multipliedBy(0.75)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        self.chooseSignInButton.addTarget(self, action: #selector(SignInViewController.chooseSignInButtonPressed), for: .touchUpInside)
        
        scrollView.addSubview(self.chooseSignUpButton)
        self.chooseSignUpButton.setTitle("Create a Beeminder account", for: .normal)
        self.chooseSignUpButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.chooseSignInButton.snp.bottom).offset(15)
            make.width.equalTo(self.view).multipliedBy(0.75)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        self.chooseSignUpButton.addTarget(self, action: #selector(SignInViewController.chooseSignUpButtonPressed), for: .touchUpInside)
        
        self.beeImageView.image = UIImage(named: "GraphPlaceholder")
        scrollView.addSubview(self.beeImageView)
        self.beeImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.chooseSignInButton.snp.top)
            make.centerX.equalTo(scrollView)
        }
        
        scrollView.addSubview(self.headerLabel)
        
        self.headerLabel.text = "Sign in to Beeminder"
        self.headerLabel.isHidden = true
        self.headerLabel.textAlignment = NSTextAlignment.center
        self.headerLabel.snp.makeConstraints { (make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            make.centerX.equalTo(scrollView)
        }
        
        scrollView.addSubview(self.emailTextField)
        self.emailTextField.isHidden = true
        self.emailTextField.placeholder = "Email or username"
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        self.emailTextField.returnKeyType = .next
        self.emailTextField.delegate = self
        self.emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView).multipliedBy(0.75)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        
        scrollView.addSubview(self.passwordTextField)
        self.passwordTextField.isHidden = true
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.autocapitalizationType = .none
        self.passwordTextField.delegate = self
        self.passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(15)
            make.centerX.equalTo(self.emailTextField)
            make.width.equalTo(self.emailTextField)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        
        scrollView.addSubview(self.signInButton)
        self.signInButton.isHidden = true
        self.signInButton.setTitle("Sign In", for: UIControlState())
        self.signInButton.backgroundColor = UIColor.beeGrayColor()
        self.signInButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        self.signInButton.titleLabel?.textColor = UIColor.white
        self.signInButton.addTarget(self, action: #selector(SignInViewController.signInButtonPressed), for: UIControlEvents.touchUpInside)
        self.signInButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.passwordTextField)
            make.right.equalTo(self.passwordTextField)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(15)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        
        scrollView.addSubview(self.divider)
        self.divider.isHidden = true
        self.divider.backgroundColor = UIColor.beeGrayColor()

        self.twitterLoginButton = TWTRLogInButton { (session, error) in
            if error == nil {
                OAuthSignInManager.sharedManager.loginWithTwitterSession(session)
            }
            else {
                // show error
            }
        }
        
        self.twitterLoginButton.isHidden = true
        scrollView.addSubview(self.twitterLoginButton)
        self.twitterLoginButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.divider.snp.bottom).offset(15)
            make.centerX.equalTo(self.signInButton)
            make.width.equalTo(self.signInButton)
            make.height.equalTo(self.signInButton)
        }
        
        scrollView.addSubview(self.facebookLoginButton)
        self.facebookLoginButton.alpha = 0.0
        self.facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.facebookLoginButton.delegate = self
        self.facebookLoginButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.twitterLoginButton.snp.bottom).offset(15)
            make.centerX.equalTo(self.signInButton)
            make.width.equalTo(self.signInButton)
            make.height.equalTo(self.signInButton)
        }
        if FBSDKAccessToken.current() != nil {
            FBSDKAccessToken.setCurrent(nil)
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = OAuthSignInManager.sharedManager
        GIDSignIn.sharedInstance().scopes = ["profile", "email"]
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        scrollView.addSubview(self.googleSigninButton)
        self.googleSigninButton.isHidden = true
        self.googleSigninButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.facebookLoginButton.snp.bottom).offset(15)
            make.centerX.equalTo(self.signInButton)
            make.width.equalTo(self.signInButton)
            make.height.equalTo(self.signInButton)
        }
        
        scrollView.addSubview(self.backToSignUpButton)
        self.backToSignUpButton.isHidden = true
        self.backToSignUpButton.setTitle("Back to Sign Up", for: .normal)
        self.backToSignUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.googleSigninButton.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.width.equalTo(self.view).multipliedBy(0.75)
            make.bottom.equalTo(-20)
        }
        self.backToSignUpButton.addTarget(self, action: #selector(SignInViewController.chooseSignUpButtonPressed), for: .touchUpInside)
        
        scrollView.addSubview(self.newUsernameTextField)
        self.newUsernameTextField.isHidden = true
        self.newUsernameTextField.autocapitalizationType = .none
        self.newUsernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.width.equalTo(self.view).multipliedBy(0.75)
        }
        self.newUsernameTextField.placeholder = "Username"
        
        scrollView.addSubview(self.newEmailTextField)
        self.newEmailTextField.isHidden = true
        self.newEmailTextField.autocapitalizationType = .none
        self.newEmailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.newUsernameTextField.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.width.equalTo(self.view).multipliedBy(0.75)
        }
        self.newEmailTextField.placeholder = "Email"
        
        scrollView.addSubview(self.newPasswordTextField)
        self.newPasswordTextField.isHidden = true
        self.newPasswordTextField.autocapitalizationType = .none
        self.newPasswordTextField.isSecureTextEntry = true
        self.newPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.newEmailTextField.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.width.equalTo(self.view).multipliedBy(0.75)
        }
        
        self.newPasswordTextField.placeholder = "Password"
        
        scrollView.addSubview(self.signUpButton)
        self.signUpButton.isHidden = true
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.addTarget(self, action: #selector(SignInViewController.signUpButtonPressed), for: .touchUpInside)
        self.signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.newPasswordTextField.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.width.equalTo(self.view).multipliedBy(0.75)
        }
        
        scrollView.addSubview(self.backToSignInButton)
        self.backToSignInButton.isHidden = true
        self.backToSignInButton.setTitle("Back to Sign In", for: .normal)
        self.backToSignInButton.snp.makeConstraints { (make) in
            make.top.equalTo(divider.snp.bottom).offset(15)
            make.height.equalTo(Constants.defaultTextFieldHeight)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.75)
        }
        self.backToSignInButton.addTarget(self, action: #selector(SignInViewController.chooseSignInButtonPressed), for: .touchUpInside)
    }
    
    @objc func signUpButtonPressed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        OAuthSignInManager.sharedManager.signUpWith(email: self.newEmailTextField.text!, password: self.newPasswordTextField.text!, username: self.newUsernameTextField.text!)
    }
    
    @objc func chooseSignInButtonPressed() {
        CurrentUserManager.sharedManager.signingUp = false
        self.beeImageView.isHidden = true
        self.divider.isHidden = false
        self.googleSigninButton.isHidden = false
        self.twitterLoginButton.isHidden = false
        self.facebookLoginButton.alpha = 1.0
        self.backToSignUpButton.isHidden = false
        self.emailTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.backToSignInButton.isHidden = true
        self.newUsernameTextField.isHidden = true
        self.newPasswordTextField.isHidden = true
        self.newEmailTextField.isHidden = true
        self.chooseSignInButton.isHidden = true
        self.chooseSignUpButton.isHidden = true
        self.headerLabel.text = "Sign in to Beeminder"
        self.headerLabel.isHidden = false
        self.signInButton.isHidden = false
        self.signUpButton.isHidden = true
        self.divider.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.signInButton)
            make.right.equalTo(self.signInButton)
            make.height.equalTo(1)
            make.top.equalTo(self.signInButton.snp.bottom).offset(15)
        }
    }
    
    @objc func chooseSignUpButtonPressed() {
        CurrentUserManager.sharedManager.signingUp = true
        self.beeImageView.isHidden = true
        self.divider.isHidden = false
        self.googleSigninButton.isHidden = true
        self.twitterLoginButton.isHidden = true
        self.facebookLoginButton.alpha = 0.0
        self.backToSignUpButton.isHidden = true
        self.emailTextField.isHidden = true
        self.passwordTextField.isHidden = true
        self.backToSignInButton.isHidden = false
        self.newUsernameTextField.isHidden = false
        self.newPasswordTextField.isHidden = false
        self.newEmailTextField.isHidden = false
        self.chooseSignInButton.isHidden = true
        self.chooseSignUpButton.isHidden = true
        self.headerLabel.text = "Sign up for Beeminder"
        self.headerLabel.isHidden = false
        self.signInButton.isHidden = true
        self.signUpButton.isHidden = false
        self.divider.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.signUpButton)
            make.right.equalTo(self.signUpButton)
            make.height.equalTo(1)
            make.top.equalTo(self.signUpButton.snp.bottom).offset(15)
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            UIApplication.shared.openURL(URL(string: "https://www.beeminder.com")!)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // show message if error
        OAuthSignInManager.sharedManager.loginButton(loginButton, didCompleteWith: result, error: error as NSError!)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        OAuthSignInManager.sharedManager.loginButtonDidLogOut(loginButton)
    }
    
    @objc func handleFailedSignIn(_ notification : Notification) {
        UIAlertView(title: "Could not sign in", message: "Invalid credentials", delegate: self, cancelButtonTitle: "OK").show()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    @objc func handleFailedSignUp(_ notification : Notification) {
        UIAlertView(title: "Could not sign up", message: "Username or email is already taken", delegate: self, cancelButtonTitle: "OK").show()
    }
    
    @objc func handleSignedIn(_ notification : Notification) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    @objc func signInButtonPressed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CurrentUserManager.sharedManager.signInWithEmail(self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.emailTextField) {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField.isEqual(self.passwordTextField) {
            self.signInButtonPressed()
        }
        return true
    }
    
}
