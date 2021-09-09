//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 5.09.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArr = [String]()
    var userCommentArr = [String]()
    var likeArr = [Int]()
    var userImageArr = [String]()
    var documentIdArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self; tableView.delegate = self
        
        getDataFromFirstore()

    }

    func getDataFromFirstore() {
        let firestoreDatabase = Firestore.firestore()
        /*
        let settings = firestoreDatabase.settings
        firestoreDatabase.settings = settings
        */
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: "Got an error: \(error)", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if !snapshot!.isEmpty && snapshot != nil {
                    
                    self.likeArr.removeAll(keepingCapacity: false)
                    self.userImageArr.removeAll(keepingCapacity: false)
                    self.userCommentArr.removeAll(keepingCapacity: false)
                    self.userEmailArr.removeAll(keepingCapacity: false)
                    self.documentIdArr.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        self.documentIdArr.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArr.append(postedBy)
                        }
                        if let comment = document.get("comment") as? String{
                            self.userCommentArr.append(comment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArr.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArr.append(imageUrl)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }
 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.usermailLabel.text = userEmailArr[indexPath.row]
        cell.userCommentLabel.text = userCommentArr[indexPath.row]
        cell.likeCountLabel.text = String(likeArr[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArr[indexPath.row]), completed: nil)
        cell.documentIdLabel.text = documentIdArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArr.count
    }

}
