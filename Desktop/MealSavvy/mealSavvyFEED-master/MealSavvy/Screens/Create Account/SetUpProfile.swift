//
//  SetUpProfile.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 08/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class SetUpProfile: UIViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var imgOutProfile: UIImageView!
    //MARK:- IBOutlet
    @IBOutlet weak var imgUploadPhoto: UIImageView!
    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    //MARK:- Other Variables
    var tapRecognizer: UITapGestureRecognizer!
    let picker = UIImagePickerController()
    var image: UIImage!
    var phone        = ""
    var pasword      = ""
    var email        = ""
    var images       =  Array<Data>()
    var lat          = ""
    var latitude     = ""
    var longitude    = ""
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    //MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        GMSPlacesClient.provideAPIKey("AIzaSyB4YuZAeMoTnSV-Bfg7RsOR_HK-YDLuvZY")
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imgOutProfile.addShadowWithRoundCorner(roundRadius: 46.0, shadowRadius: 2.0, shadowColor: UIColor.init(rgb: 0x000000, a: 1.0), shadowOpacity: 0.16, shadowWidth: 1.0, shadowHeight: 1.0, borderWidth: 0.0)
        imgUploadPhoto.makeRoundCorner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBActions
    @IBAction func tapFinish(_ sender: UIButton) {
        if validate() {
             let first_name = txtFirstName.text!
             let last_name = txtLastName.text!
            view.endEditing(true)
            SVProgressHUD.show(withStatus: "Login ...")
            SocketService.shared.signUp(phone, email: email, password: pasword, first_name: first_name, last_name: last_name, deviceToken: GlobalData.shared.deviceToken, address: txtAddress.text!, images: images, longitude: self.longitude, latitude: self.latitude, isEncrypted: true, completion: {  (user, error) in
                if let _ = error {
                    SVProgressHUD.showError(withStatus: error)
                } else {
                    SVProgressHUD.dismiss()
                    GlobalData.shared.me = user
                    
                    let instance = self.storyboard?.instantiateViewController(withIdentifier: "tabNavigation") as! UINavigationController
                    APP_DELEDATE.window?.rootViewController = instance
                    
//                    let moveToProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//                    self.navigationController?.pushViewController(moveToProfileVC, animated: true)
//                    print("profile SettedUp")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.latitude   = "\(locValue.latitude)"
        self.longitude  = "\(locValue.longitude)"
        self.setCurrentLocation(locValue)
    }
    
    func setCurrentLocation(_ loc:CLLocationCoordinate2D){
        let geocoder = GMSGeocoder()
        
//        SVProgressHUD.show(withStatus: "Get Current Location ...")
        geocoder.reverseGeocodeCoordinate(loc) { response , error in
//            SVProgressHUD.dismiss()
            if let address = response?.firstResult() {
                let lines = address.lines as! [String]
                self.txtAddress.text = lines.joined(separator: ",")
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    @IBAction func tapOnAddress(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)

    }
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.latitude   = "\(place.coordinate.latitude)"
        self.longitude  = "\(place.coordinate.longitude)"
        
        self.setCurrentLocation(place.coordinate)

        viewController.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        viewController.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    //MARK:- Other Helper Methods
    func configure() {
        viewStack.addShadowWithRadius(radius: 2, cornerRadius: 10)
        btnFinish.makeRoundCorner(20)
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPhoto))
        imgUploadPhoto.isUserInteractionEnabled = true
        imgUploadPhoto.addGestureRecognizer(tapRecognizer)
//        viewImage.makeRounded()
    }
    
    func validate() -> Bool {
        if txtFirstName.text == "" {
            self.showOkAlert("Please Enter Your First Name")
            return false
        } else if txtLastName.text == "" {
            self.showOkAlert("Please Enter Your Last Name")
            return false
        } else if txtAddress.text == "" {
            self.showOkAlert("Please Enter Your Address")
        }
        return true
    }
    @objc func uploadPhoto() {
        chooseFile()
    }
    func chooseFile() {
        let alert : UIAlertController = UIAlertController(title: "Choose a file?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true, completion: nil)
    }
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else{
            _ =  self.showOkAlert("warning!!! You Don't Have camera")
        }
        }
    func openLibrary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}

extension SetUpProfile: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        imgUploadPhoto.contentMode = .scaleAspectFit
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgUploadPhoto.image = image
        
//        let url = info["UIImagePickerControllerImageURL"] as? NSURL
//
//        if let theProfileImageUrl = url{
//            do {
//                let imageData = try Data(contentsOf: theProfileImageUrl as URL)
//                print(imageData)
//                print(imageData.base64EncodedString(options: .lineLength64Characters))
//            } catch {
//                print("Unable to load data: \(error)")
//            }
//        }

        dismiss(animated: true, completion: nil)
    }
}

extension SetUpProfile: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtAddress.becomeFirstResponder()
        } else {
            txtAddress.endEditing(true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName {
            var totalFirstNameCount = txtFirstName.text!.count + string.count
            return totalFirstNameCount <= 50
        } else if textField == txtLastName {
            var totalLastNameCount = txtLastName.text!.count + string.count
            return totalLastNameCount <= 50
        }
        return true
    }
}

extension SetUpProfile: UINavigationControllerDelegate {
    
}
