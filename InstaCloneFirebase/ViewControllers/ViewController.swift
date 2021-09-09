//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 5.09.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func signIn(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            // signIn method will check for matches of password and email by itself. So we don't have to check it.
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                
                if error != nil {
                    //Got an error. Email or password wrong!
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "some kind a error.")
                } else {
                    //Everything went fine, user password and email confirmed, so we're ready to go.
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error", message: "Username/Password?")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    //Got an error. Email address have used once, or maybe password isn't type of desired.
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "some kind a error.")
                } else {
                    //Succesfully sgined Up, so we're ready to go.
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error!", message: "Email or password is empty. Please fill it to complete registration.")
        }
        
        
    }
    
    public func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

