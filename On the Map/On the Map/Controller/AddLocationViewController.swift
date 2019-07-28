//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Hend  on 7/20/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancel_clicked))
        self.navigationItem.leftBarButtonItem = cancelBtn
    }
    
    @IBAction func FindLocationOnMap(_ sender: Any) {
        
        guard txtLocation.text != "" else {
            showAlert(title: "Invalid Location", messgae: "You must enter a location.")
            return
        }
        self.configureIndicator(isActive: true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(txtLocation.text!, completionHandler: {(placemarks, error) -> Void in
            
            guard error == nil else{
                self.showAlert(title: "Wrong location", messgae: "There is no place on the map with the name you entered!")
                self.configureIndicator(isActive: false)
                return
            }
            
            guard let placemark = placemarks?.first else{
                self.showAlert(title: "Location problem", messgae: "An error occurred while searching for the location.")
                self.configureIndicator(isActive: false)
                return
            }
            
            let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            
            OnTheMapClient.sharedInstance().getUserData(){(success, firstName, lastName, errorMessage) in
                if success{
                    DispatchQueue.main.async {
                        self.SetLocationOnMapView(firstName: firstName, lastName: lastName, coordinate: coordinates)
                        self.configureIndicator(isActive: false)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Download problem:", messgae:  "An error occurred while downloading user data\nDetails: \(errorMessage)")
                        self.configureIndicator(isActive: false)
                    }
                }
            }
            
        })
    }
    
    func SetLocationOnMapView(firstName:String, lastName:String, coordinate : CLLocationCoordinate2D){
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        controller.firstName = firstName
        controller.lastName = lastName
        controller.location = self.txtLocation.text!
        controller.coordinate = coordinate
        controller.mediaURL = self.txtLink.text!
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func showAlert(title:String, messgae:String){
        let alert = UIAlertController(title: title, message: messgae, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureIndicator(isActive:Bool){
        if isActive{
            self.activityIndicator.color = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.color = UIColor.white
            self.activityIndicator.startAnimating()
        }
    }
    
    @objc func btnCancel_clicked(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
