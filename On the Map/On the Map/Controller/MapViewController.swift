//
//  MapViewController.swift
//  On the Map
//
//  Created by Hend  on 7/18/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var studentInformation  = [StudentInformation]()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnFinish: BorderedButton!
    var firstName : String?
    var lastName : String?
    var location : String?
    var mediaURL : String?
    var coordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if self.coordinate == nil{
            OnTheMapClient.sharedInstance().getLocations(){ (success, errorString) in
                if success{
                    DispatchQueue.main.async {
                        self.setAnnotations()
                    }
                }else{
                    let alert = UIAlertController(title: "An error occurred while Downloading Student Locations", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         if self.coordinate != nil{
            self.setAnnotation()
        }else{
            self.setAnnotations()
        }
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! , toOpen != ""{
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func setAnnotation(){
        self.title = "Add Location"
        self.btnFinish.isHidden = false
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinate!
        annotation.title = self.location
        annotation.subtitle = mediaURL
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func setAnnotations(){
        self.title = "On The Map"
        self.btnFinish.isHidden = true
        self.studentInformation = OnTheMapClient.sharedInstance().students
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        for location in self.studentInformation {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude as! Double)
            let long = CLLocationDegrees(location.longitude as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName as! String
            let last = location.lastName as! String
            let mediaURL = location.mediaURL as? String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func AddStudent(_ sender: Any) {
        OnTheMapClient.sharedInstance().postStudent(firstName: self.firstName ?? "H", lastName: self.lastName ?? "S", lat: self.coordinate!.latitude as Double, long: self.coordinate!.longitude as Double, location: self.location!, link: self.mediaURL ?? ""){(success, errorString) in
            if success{
                OnTheMapClient.sharedInstance().getLocations(){(success, errorString) in
                    if success{
                        DispatchQueue.main.async {
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
}
