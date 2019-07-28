//
//  TableViewController.swift
//  On the Map
//
//  Created by Hend  on 7/19/19.
//  Copyright © 2019 Hend . All rights reserved.
//
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
// MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var studentInformation  = OnTheMapClient.sharedInstance().students
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.studentInformation = OnTheMapClient.sharedInstance().students
        self.tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let studentData = self.studentInformation[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = "\(studentData.firstName) \(studentData.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = studentData.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let student = self.studentInformation[(indexPath as NSIndexPath).row]
        if let toOpen = student.mediaURL , toOpen != ""{
            app.openURL(URL(string: toOpen)!)
        }
    }
}
