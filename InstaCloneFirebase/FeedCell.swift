//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Fatih Kilit on 7.09.2021.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var usermailLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCountLabel.text!) {
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }

}
