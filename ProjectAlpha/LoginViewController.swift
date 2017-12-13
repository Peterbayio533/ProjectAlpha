//
//  LoginViewController.swift
//  ProjectAlpha
//
//  Created by Peter Bayiokos on 12/12/17.
//  Copyright © 2017 PeterB. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFacebookButtons()
        
        setupGoogleButtons()
   
        // Do any additional setup after loading the view.
    }
    
    
    //Google Login Setups Below
    fileprivate func setupGoogleButtons(){
        //Google Sign In Button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 330, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        /*let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 16, y: 330 + 66, width: view.frame.width - 32, height: 50)
        customButton.backgroundColor = .orange
        customButton.setTitle("Custom Google Button", for: .normal)
        customButton.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside)
        view.addSubview(customButton)*/
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
     //Facebook Login Setups Below
    fileprivate func setupFacebookButtons(){
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 330 + 66, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong", error ?? "")
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
            print("Successfully logged in with facebook", user ?? "")
            
        })
        print("Successully logged in with Facebook")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
