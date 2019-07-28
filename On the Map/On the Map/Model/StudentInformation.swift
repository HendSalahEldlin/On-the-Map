//
//  Constants.swift
//  On the Map
//
//  Created by Hend  on 7/18/19.
//  Copyright © 2019 Hend . All rights reserved.
//

// MARK: - StudentInformation
struct StudentInformation {
    
    // MARK: Properties
    let createdAt : String
    let firstName : String
    let lastName : String
    let latitude : Double
    let longitude : Double
    let mapString : String?
    let mediaURL : String?
    let objectId : String
    let uniqueKey : String
    let updatedAt : String
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
    init(dictionary: [String:AnyObject]) {
        createdAt = dictionary[OnTheMapClient.JSONResponseKeys.createdAt] as! String
        firstName = dictionary[OnTheMapClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OnTheMapClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[OnTheMapClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[OnTheMapClient.JSONResponseKeys.longitude] as! Double
        mapString = dictionary[OnTheMapClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OnTheMapClient.JSONResponseKeys.mediaURL] as? String
        objectId = dictionary[OnTheMapClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[OnTheMapClient.JSONResponseKeys.uniqueKey] as! String
        updatedAt = dictionary[OnTheMapClient.JSONResponseKeys.updatedAt] as! String
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation ] {
        
        var StudentLocations = [StudentInformation ]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            StudentLocations.append(StudentInformation (dictionary: result))
        }
        
        return StudentLocations
    }
}
