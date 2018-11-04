//
//  CustomerStatusVC.swift
//  TooLow
//
//  Created by AppsInvo  on 28/03/18.
//  Copyright © 2018 HVN_Pivotal. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import SVProgressHUD

class CustomerStatusVC: UIViewController {
    
    @IBOutlet weak var lblPicupTime: UILabel!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var viewPicupTime: UIView!
    @IBOutlet weak var viewPickupLocation: UIView!
    @IBOutlet weak var viewOrderInfo: UIView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblMeal: UILabel!
    @IBOutlet weak var lblRestraurantName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnRefresh: UIButton!
    
//    var selectedService = MAEvent()
    var services:[ServiceModel]!
    var history:PaymentHistoryModel!
    var timer = Timer()
    var secondCount = 0
//    var currentBookService: Service?
    var book:BookModel!
    
    var bookingId = ""
    var comment:String!
    var isFrom = ""
    var isFromConfirmScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewComment.makeRoundCorner(5)
        txtViewComment.makeBorder(1, color: UIColor.lightGray)

        checkBookingStatus()
        
        if isFrom == "book" {
            self.showBookDetails()
        }
        else {
            self.showHistoryDetails()
        }
        
        
//        if let _ = selectedService.service {
//            lblOrderNumber.text = "ORDER #\(selectedService.bookingId!)"
//            lblMeal.text = selectedService.service.name
//        }
        
//        if let service = self.currentBookService {
//            lblOrderNumber.text = "ORDER #\(bookingId)"
//            let address = "\(service.salonInfo.address!), \(service.salonInfo.city!), \(service.salonInfo.state!)"
//            lblMeal.text = "1x  \(service.name!)"
//            lblAddress.text = address
//            lblRestraurantName.text =  service.salonInfo.businessName
//        }
        mapView.delegate = self
//        MKCoordinateRegion region;
//        region.center.latitude     = booth.latitude;
//        region.center.longitude    = booth.longitude;
//        region.span.latitudeDelta  = .0001;
//        region.span.longitudeDelta = .0005;
//        [map setRegion:region animated:YES];
        
        if self.isFrom == "book"{
            var information = MKPointAnnotation()

            information.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(services[0].supplierLatitude), CLLocationDegrees(services[0].supplierLongitude))
            information.title = services[0].supplierName
            information.subtitle = services[0].supplierAddress
            mapView.addAnnotation(information)
            let cam = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(CLLocationDegrees(services[0].supplierLatitude), CLLocationDegrees(services[0].supplierLongitude)), fromEyeCoordinate: CLLocationCoordinate2DMake(CLLocationDegrees(services[0].supplierLatitude), CLLocationDegrees(services[0].supplierLongitude)), eyeAltitude: 0)
            mapView.camera = cam
        }
        

//        if let annotaion = getAnnotations() {
//            mapView.delegate = self
//            mapView.addAnnotation(annotaion)
//            setZoomOnMap()
//            print(mapView.annotations,"all annoatations")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFrom != "book" {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSeconds), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewPicupTime.addShadowWithRoundCorner(roundRadius: 5, shadowRadius: 2)
        viewOrderInfo.addShadowWithRoundCorner(roundRadius: 5, shadowRadius: 2)
        viewPickupLocation.addShadowWithRoundCorner(roundRadius: 5, shadowRadius: 2)
        btnCancelOrder.addShadowWithRoundCorner(roundRadius: 5, shadowRadius: 2)
    }
    
    @objc func updateSeconds() {
        secondCount = secondCount+1
        if secondCount >= 15 {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnCancelOrder.alpha = 0.0
            })
            timer.invalidate()
        }
    }
    
    private func showBookDetails() {
        if self.book != nil {
            lblOrderNumber.text = "ORDER #\(book.booking_id!)"
        }
        
        var info:String = ""
        for eachSer:ServiceModel in services {
            info = info + eachSer.name + ", "
        }
        info = String(info.dropLast())
        info = String(info.dropLast())
        
        lblMeal.text = info
        lblRestraurantName.text = services[0].supplierName
        lblAddress.text = services[0].supplierAddress
        txtViewComment.text = comment
    }
    
    private func showHistoryDetails() {
        lblOrderNumber.text = "ORDER #\(String(history.transaction_hid.suffix(7)))"
        lblMeal.text = history.service_name
        lblRestraurantName.text = history.supplier_name
    }
    
    func setZoomOnMap() {
//        guard let salonInfo = self.currentBookService?.salonInfo else {
//            return
//        }
//        var miles = MBUtils.calculateDistanceBetweenTwoPoint(CGFloat(Filter.shared().latitude), long1: CGFloat(Filter.shared().longitude), lat2:  CGFloat(salonInfo.latitude), long2:  CGFloat(salonInfo.longitude))
//        if miles > 100{
//            miles = 100
//        }
//        let coordinate = CLLocationCoordinate2D(latitude: salonInfo.latitude, longitude: salonInfo.longitude)
//        mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, CLLocationDistance(miles*1600), CLLocationDistance(miles*1600)), animated: false)
    }
    
    func checkBookingStatus() {
        
        if self.isFrom != "book" || self.book == nil {
            return
        }
        
        SocketService.shared.checkBooking(self.book) { (outBook, error) in
            
            if let _ = error{
                SVProgressHUD.showError(withStatus: error)
            }else{
                self.configureScreen(outBook!)
            }
        }
    }
    
    
    func configureScreen(_ outBook:BookModel){
        if isFrom == "book" {
            if outBook.status == "empty" {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSeconds), userInfo: nil, repeats: true)
                self.lblPicupTime.text = "Waiting for restaurant to accept order.."
                self.btnCancelOrder.setTitle("CANCEL ORDER", for: .normal)
                self.btnCancelOrder.alpha = 1.0
            } else if outBook.status == "declined" {
                self.btnCancelOrder.setTitle("ORDER CANCELLED", for: .normal)
                self.btnCancelOrder.isEnabled = false
                self.btnCancelOrder.alpha = 1.0
            } else if outBook.status == "accepted" {
                self.btnCancelOrder.alpha = 0.0
                self.lblPicupTime.text = "Pickup in \(outBook.prep_time) minutes"
            }
        }
        else {
                self.btnCancelOrder.alpha = 1.0
                self.lblPicupTime.text = "Pickup in \(outBook.prep_time) minutes"
                if outBook.status == "declined" {
                    self.btnCancelOrder.setTitle("ORDER CANCELLED", for: .normal)
                    self.btnCancelOrder.isEnabled = false
                    self.btnCancelOrder.alpha = 1.0
                }
        }
    }
    
    @IBAction func tapCancelOrder(_ sender: Any) {
        if self.isFrom != "book" ||  self.book == nil {
            return
        }
        
        SocketService.shared.cancelOrder(self.book, status: "declined") { (book, error) in
            
            if let _ = error{
                SVProgressHUD.showError(withStatus: error)
            }else{
                self.btnCancelOrder.setTitle("ORDER CANCELLED", for: .normal)
            }
        }
    }
    
    @IBAction func onClickRefreshTime(_ sender: Any) {
//        checkBookingStatus ()
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        if self.isFrom == "book" {
            if let viewController = self.navigationController?.viewControllers {
                print(viewController)
                for vc in viewController {
                    if vc is GetFoodDetailVC {
                        vc.tabBarController?.selectedIndex = 0
                        self.navigationController!.popToViewController(vc, animated: true)
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        else {
            if self.navigationController != nil {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func hitAcceptDeclinedAPI(status: String) {
        
        var bookingID = ""
//        if let id = selectedService.bookingId {
//            bookingID = id
//        }else {
//            bookingID = self.bookingId
//        }
//        if bookingID == "" {
//            return
//        }
//        let dictData = ["booking_id":bookingID,
//                        "status":status,
//                        "token":Profile.shared().token]
//        print(dictData)
//        ManagerConnection.createRequest(withAction: "service:booking:accepted", withData: dictData, successBlock: { (operation :AFHTTPRequestOperation?, array: Any) in
//            LoadingMaskView.hide()
//            if let arr = array as? [[String:Any]], arr.count > 0, let success = arr[0]["success"] as? Bool {
//                if success {
//                    print("seuccess",status)
//                    self.btnCancelOrder.setTitle("ORDER CANCELLED", for: .normal)
//                }else {
//                    if let data = arr[0]["data"] as? [String:Any] {
//                        self.showOkAlertWithHandler(data["message"] as? String ?? "", handler: {
//
//                        })
//                    }
//                }
//                return
//            }
//
//            print(array)
//        }) { (operation :AFHTTPRequestOperation?, error: Error?) in
//            if let strongError = error{
//                LoadingMaskView.hide()
//                print(strongError)
//            }
//        }
    }

}

extension CustomerStatusVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "location")
        }
        
        return annotationView
        
//        if let anno = annotation as? JPSThumbnailAnnotationProtocol {
//            return anno.annotationView(inMap: mapView)
//        }
//        return nil
    }
}




