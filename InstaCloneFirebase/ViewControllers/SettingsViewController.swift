//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 5.09.2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logOut(_ sender: Any) {
        
        do {
            // You don't have to do anything else but write one line code. Current user will log out by firebase.
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        } catch {
            let alert = UIAlertController(title: "Error", message: "There is something wrong!", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
}
