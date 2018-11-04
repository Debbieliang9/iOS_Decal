//
//  SocialFeedViewCell.swift
//  MealSavvy
//
//  Created by Eric Le Ge on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class SocialFeedViewCell: UITableViewCell {
    
    weak var delegate: SocialFeedViewCellDelegate?
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var UserPhoto: UIImageView!
    
    @IBOutlet weak var timeAgo: UILabel!
    

    @IBOutlet weak var Like: UILabel!
    
    @IBOutlet weak var Comment: UILabel!
    
    @IBAction func CommentButtonTapped(_ sender: UIButton) {
        delegate?.SocialFeedViewCellDidTapComment(self)
    }
    @IBOutlet weak var LikeButton: UIButton!
    
    @IBAction func LikeButtonTapped(_ sender: UIButton) {
        delegate?.SocialFeedViewCellDidTapHeart(self)
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
protocol SocialFeedViewCellDelegate : class {
    func SocialFeedViewCellDidTapHeart(_ sender: SocialFeedViewCell)
    func SocialFeedViewCellDidTapComment(_ sender: SocialFeedViewCell)
}
