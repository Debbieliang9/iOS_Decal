//
//  BaseViewController.swift
//  MealSavvy
//
//  Created by JinJin Lee on 2018/8/20.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Event Handler
    @IBAction func onClickBack (_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}
