//
//  RootViewController.swift
//  MealSavvy
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitialViewController ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initialize Handler
    private func setInitialViewController () {
        if GlobalData.shared.me != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
                return
            }
            navigationController?.pushViewController(vc, animated: false)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "AuthNavigationController") else {
                return
            }
            present(vc, animated: false, completion: nil)
            /*
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
                return
            }
            navigationController?.pushViewController(vc, animated: false)
            */
        }
    }
    
    // MARK: - Location Handler
    private func initLocationManager () {
        LocationManager.shared.startMonitoringLocation()
        LocationManager.shared.getUserCurrentLocation { (location) in
//            GlobalData.shared.userLocation = location
        }
    }
}
