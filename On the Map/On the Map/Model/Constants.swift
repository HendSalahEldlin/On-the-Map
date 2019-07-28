//
//  OnTheMapClient.swift
//  On the Map
//
//  Created by Hend  on 7/19/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension OnTheMapClient {
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
    }
    
    // MARK: Methods
    struct URLExtentions {
        static let StudentLocation = "/StudentLocation"
        static let session = "/session"
        static let users = "/users"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        //MARK: session & users URL Keys
        static let objectId = "objectId"
        static let UserID = "user_id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        //MARK: StudentLocation Parameter Keys
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        static let uniqueKey = "uniqueKey"
    }
    
    // MARK: JSON Body Keys
    struct UdacityJSONBodyKeys {
        static let username = "username"
        static let password = "password"
    }
    // MARK: JSON Response Keys
    struct JSONResponseKeys{
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
    }
}
