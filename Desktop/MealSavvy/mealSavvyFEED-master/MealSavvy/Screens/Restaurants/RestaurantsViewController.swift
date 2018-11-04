//
//  RestaurantsViewController.swift
//  MealSavvy
//
//  Created by JinJin Lee on 2018/8/20.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class RestaurantsViewController: BaseViewController {

    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var isFromSignup = false
    var isBasic = false
    var planType = 0

    let restaurants = [["image":"chipotle","name":"Chipotle","address":"2311 Telegraph Ave\nBerkeley, CA 94704"],
                       ["image":"subway","name":"Subway","address":"2490 Bancroft Way\nBerkeley, CA 94704"],
                       ["image":"pokebar","name":"Poke Bar","address":"2433 Durant Ave\nBerkeley, CA 94704"],
                       ["image":"jasminethai","name":"Jasmine Thai","address":"1805 Euclid Ave\nBerkeley, CA 94709"],
                       ["image":"chengdu","name":"Chengdu Style","address":"2600 Bancroft Way\nBerkeley, CA 94704"],
                       ["image":"res1","name":"La Val's Pizza","address":"1834 Euclid Ave\nBerkeley, CA 94709"],
                       ["image":"res2","name":"Momo Indian Cuisine","address":"2505 Hearst Ave\nBerkeley, CA 94709"],
                       ["image":"res3","name":"House of Curries","address":"2520 Durant Ave\nBerkeley, CA 94704"],
                       ["image":"res4","name":"Gong Cha","address":"2431 Durant Ave\nBerkeley, CA 94704"],
                       ["image":"res5","name":"Stuffed Inn","address":"1829 Euclid Ave\nBerkeley, CA 94709"],
                       ["image":"res6","name":"V&A Cafe","address":"2521 Hearst Ave\nBerkeley, CA 94709"],
                       ["image":"res7","name":"Nefeli Cafe","address":"1854 Euclid Ave\nBerkeley, CA 94709"],
                       ["image":"res8","name":"Mandarin House","address":"2519 Durant Ave\nBerkeley, CA 94704"],
                       ["image":"res9","name":"Shihlin Taiwan Street Snacks","address":"2505 Dwight Way\nBerkeley, CA 94704"],
                       ["image":"sushigogo","name":"Sushi Go Go","address":"2176 Kittredge St\nBerkeley, CA 94704"],
                       ["image":"ddccafe","name":"DDC Cafe","address":"2017 Shattuck Ave\nBerkeley, CA 94704"],
                       ["image":"nashkitchen","name":"Nash Kitchen","address":"2047 University Ave\nBerkeley, CA 94704"],
                       ["image":"res10","name":"Dumpling Express","address":"2505 Dwight Way\nBerkeley, CA 94704"],
                       ["image":"res11","name":"Abe's Pizza","address":"2505 Dwight Way\nBerkeley, CA 94704"],
                       ["image":"res12","name":"Boba Ninja","address":"2505 Dwight Way\nBerkeley, CA 94704"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event Handler
    @IBAction func onClickConfirm(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
            return
        }
        vc.isFromSignup = isFromSignup
        vc.isBasic = isBasic
        vc.planType = planType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Initialize Handler
    private func initViewController () {
        // confirm button
        confirmButton.makeRoundCorner(5)
    }
}

extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsTableViewCell", for: indexPath)
        
        let viewShadow = cell.viewWithTag(120)
        // let  viewContainer = cell.viewWithTag(100) //child
        viewShadow!.makeRoundCorner(10)
        viewShadow!.dropShadow(color: UIColor.gray, offSet: CGSize(width:-1, height:1))
        
        let imgView = cell.viewWithTag(101) as? UIImageView
        imgView!.makeRoundCorner(5)
        imgView!.makeBorder(1, color: UIColor.lightGray)
        if let strUrl = restaurants[indexPath.row]["image"] {
            imgView?.image = UIImage(named: strUrl)
        }
        
        let lblTitle = cell.viewWithTag(102) as? UILabel
        lblTitle?.text =  restaurants[indexPath.row]["name"]
        
        let lblAdd = cell.viewWithTag(210) as? UILabel
        lblAdd?.text = restaurants[indexPath.row]["address"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
