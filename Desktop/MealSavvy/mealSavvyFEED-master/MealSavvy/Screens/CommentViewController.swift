//
//  CommentViewController.swift
//  MealSavvy
//
//  Created by CiCi on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    //var delegate : AppDelegate
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var socialFeedData = SocialFeedModel()
    

    
    // these should be hard-coded


    // those are the variables for the first thing that appears (doesn't belong to tableview)
    
    //let data =
    @IBOutlet var UserPhoto: UIImageView!
    
    @IBOutlet var UserComment: UILabel! /*someone ate at restaurant 10 */
    
    @IBOutlet var UserTimeAgo: UILabel!
    
    @IBOutlet var UserLikes: UILabel! /*is a number*/
    
    @IBOutlet var UserComments: UILabel! /*is a number*/
    
    @IBOutlet var LikesString: UILabel! /*UserA, USERB Likes the activity*/
    
    @IBOutlet var CommentTable: UITableView!
    
    @IBOutlet var CommentTextField: UITextField!
    
    var comments         : [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UserComment.text =  socialFeedData.firstName + socialFeedData.lastName + "ate at " + socialFeedData.restaurant_name
        
        self.UserPhoto.image = UIImage(named: socialFeedData.profilePicture[0])
        
        self.UserLikes.text = String(socialFeedData.likes.count)
        
        self.UserComments.text = String(socialFeedData.comments.count)
        
        self.comments = socialFeedData.comments
        
        //self.UserTimeAgo.text = socialFeedData.updatedAt
        
    
        // Do any additional setup after loading the view.
    }
    
    /*update the current interface with the new added comment but I don't know how to do so*/
    @IBAction func CommentSendButtom(_ sender: UIButton) { /*create a new commentcell*/
        var _:String = CommentTextField.text ?? ""
        CommentTable.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pcell = CommentTable.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! CommentViewCell
        pcell.commentmessage.text = comments[indexPath.row]["message"] as! String
        return pcell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(comments.count)
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
