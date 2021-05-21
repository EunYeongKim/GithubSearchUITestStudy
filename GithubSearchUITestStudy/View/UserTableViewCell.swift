//
//  UserTableViewCell.swift
//  GithubSearchUITestStudy
//
//  Created by 60080252 on 2021/05/21.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: Search.User? {
        didSet {
            if let avatarUrlStr = user?.avatarUrl, let avatarUrl = URL(string: avatarUrlStr) {
                avatarImageView.kf.setImage(with: avatarUrl)
            }
            nameLabel.text = user?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
