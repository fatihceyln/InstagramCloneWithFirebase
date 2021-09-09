//
//  makeAlert.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 7.09.2021.
//

import UIKit
import

func makeAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
}
