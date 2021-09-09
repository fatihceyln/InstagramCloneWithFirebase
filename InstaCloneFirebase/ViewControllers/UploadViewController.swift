//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 5.09.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var commentText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        imageView.addGestureRecognizer(tapGestureRec)
        
    }
    
    @objc func selectPhoto() {
        //First of all we have to declare a picker to pick image.
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(Title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        
        //Create a storage from firebase before work with database
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuidString = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuidString).jpg") //They will save into media folder with named by uuid.
            //They named at one line up, and then they will put database.
            imageReference.putData(data, metadata: nil) { metaData, error in
                if error != nil {
                    self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil
                        {
                            
                            //Database
                            guard let imageUrl = url?.absoluteString, url?.absoluteString != nil else {return}
                            guard let comment = self.commentText.text, self.commentText.text != nil else {return}
                            
                            let dataToSave: [String: Any] = ["imageUrl": imageUrl,
                                                             "postedBy": Auth.auth().currentUser?.email ?? "can't get user's mail",
                                                             "comment": comment,
                                                             "date": FieldValue.serverTimestamp(),
                                                             "likes": 0]
                            
                            let firestoreDatabase = Firestore.firestore()
                            var docRef: DocumentReference!
                            
                            //".addDocument" adds documents with random ID
                            docRef = firestoreDatabase.collection("Posts").addDocument(data: dataToSave, completion: { error in
                                
                                if let error = error {
                                    self.makeAlert(Title: "Error", message: "Got an error: \(error.localizedDescription)")
                                }
                                else {
                                    //Everthing went fine, go back to the feedVC
                                    self.commentText.text = ""
                                    self.imageView.image = UIImage(systemName: "photo.fill")?.withRenderingMode(.alwaysOriginal)
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                        else
                        {
                            self.makeAlert(Title: "Error", message: "Got an error: \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
    }
}
