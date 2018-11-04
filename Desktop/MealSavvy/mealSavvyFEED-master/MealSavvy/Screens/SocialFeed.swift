//
//  SocialFeed.swift
//  MealSavvy
//
//  Created by Chris  on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class SocialFeed: UIViewController, UITableViewDelegate, UITableViewDataSource, SocialFeedViewCellDelegate, PrivateTableViewCellDelegate{
    func PrivateTableViewCellDidTapSwitch(_ sender: PrivateTableViewCell) {
        if sender.mySwitch.isOn {
            sender.mySwitch.setOn(false, animated:true)
        } else {
            sender.mySwitch.setOn(true, animated:true)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var socialFeedData = [SocialFeedModel]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoPrivateCell", for: indexPath) as! PrivateTableViewCell
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableFeedCell", for: indexPath) as! SocialFeedViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        let feedModel:SocialFeedModel = socialFeedData[indexPath.row]
        cell.UserPhoto.image = UIImage(named: feedModel.profilePicture[0])
        
//        let currentTime = Date()
//        let numMinutes = Calendar.current.dateComponents([.minute], from: feedModel.updatedAt, to: currentTime).minute
//        if let rightNumMinutes = numMinutes {
//            if rightNumMinutes < 0 {
//                cell.timeAgo.text = "This post is from the future."
//            }
//            else {
//                if rightNumMinutes == 0 {
//                    cell.timeAgo.text = "Just now."
//
//                }
//                else if rightNumMinutes < 60 {
//                    cell.timeAgo.text = String(rightNumMinutes) + " minutes ago."
//
//                }
//                else if rightNumMinutes >= 120 && rightNumMinutes < 1440 {
//                    let numHours = String(rightNumMinutes / 60)
//                    cell.timeAgo.text = numHours + " hours ago."
//
//                }
//                else if rightNumMinutes >= 60 && rightNumMinutes < 120 {
//                    cell.timeAgo.text = "1 hour ago."
//
//                } else if rightNumMinutes == 1 {
//                    cell.timeAgo.text = "1 minute ago."
//
//                } else if rightNumMinutes >= 1440 && rightNumMinutes < 2880 {
//                    cell.timeAgo.text = "1 day ago."
//
//                } else {
//                    let numDays = String(rightNumMinutes / 1440 )
//                    cell.timeAgo.text = numDays + " days ago."
//
//                }
//
//            }
//
//        }
        
        
        
        //把cell里面的属性改成feedModel里面获取的属性
        cell.Like.text = String(feedModel.likes.count)
        cell.Comment.text = String(feedModel.comments.count)
        cell.message.text = feedModel.firstName + " " + feedModel.lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  
    
    


    func SocialFeedViewCellDidTapHeart(_ sender: SocialFeedViewCell) {
        //like s user's post
        var numberoftimeclicked = 0
        
        sender.LikeButton.setImage(UIImage(named:"not like"), for: .normal)
        numberoftimeclicked += 1
        if numberoftimeclicked%2 != 0{
            sender.Like.text = String(numberoftimeclicked)
        }
        if numberoftimeclicked != 0{
            sender.LikeButton.setImage(UIImage(named:"like"), for: .normal)
        }
    }
    
    func SocialFeedViewCellDidTapComment(_ sender: SocialFeedViewCell) {
        //eject keyboard
        performSegue(withIdentifier: "ShowFeedSegue", sender: self)
    }
    
    
    

    
    func getSocialFeedData(){
        SocketService.shared.getSocialFeed { (feed, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: error)
            } else {
                SVProgressHUD.dismiss()
                self.socialFeedData.removeAll()
                self.socialFeedData.append(contentsOf: feed!)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = sender as? SocialFeedViewCell{
            if let dest = segue.destination as? CommentViewController{
                dest.socialFeedData = socialFeedData[s.tag]
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getSocialFeedData()
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SocialFeed.runTimedCode), userInfo: nil, repeats: true)
        
        
        // Do any additional setup after loading the view.
    }
    @objc func runTimedCode(){
        self.tableView.reloadData()
    }
    
    
    // Do any additional setup after loading the view.
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
