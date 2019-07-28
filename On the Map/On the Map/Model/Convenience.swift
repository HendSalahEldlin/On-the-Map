//
//  Convenience.swift
//  On the Map
//
//  Created by Hend  on 7/19/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension OnTheMapClient{
    
    func login(userName: String, password:String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}"
        let headers = ["Accept":"application/json"]
        
        taskForPOSTMethod(URLExtentions.session, parameters: parameters, headers: headers, jsonBody: jsonBody, withFirst5: true) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                
                let dictionaryOfDictionaries = results as! [String : [String : AnyObject]]
                let userID = dictionaryOfDictionaries["account"]!["key"] as? String
                self.userID = userID
                completionHandlerForSession(true, nil)
            }
        }
    }
    
    func getUserData(completionHandlerForUserData: @escaping (_ success: Bool, _ firstName: String, _ lastName: String, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String : AnyObject]()
        taskForGETMethod("\(URLExtentions.users)/\(userID!)", parameters: parameters, withFirst5: true){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUserData(false, "", "", error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                
                let resultDictionry = results as? [String : AnyObject]
                let firstName = resultDictionry?["first_name"] as! String
                let lastName = resultDictionry?["last_name"] as! String
                completionHandlerForUserData(true, firstName, lastName, nil)
            }
        }
    }
    
    func getLocations(completionHandlerForStudentLocations: @escaping (_ success : Bool, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["order":"-updatedAt", "limit":"100"] as! [String : AnyObject]
        taskForGETMethod(URLExtentions.StudentLocation, parameters: parameters, withFirst5: false){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocations(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                    
                let resultDictionry = results as? [String: [[String : AnyObject]]]
                self.students = StudentInformation.studentLocationsFromResults(resultDictionry!["results"]!)
                //let arrayofDictionaries = StudentInformation.studentLocationsFromResults(resultSictionry!["results"]!)
                completionHandlerForStudentLocations(true, nil)
            }
        }
        
    }
 
    func DeleteSession(completionHandlerForDeleteSession: @escaping (_ success : Bool, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        taskForDELETEMethod(URLExtentions.session, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDeleteSession(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let resultDictionary = results as! [String : [String:AnyObject]]
                guard let sessionId = resultDictionary["session"]!["id"] as? String else{
                    completionHandlerForDeleteSession(false, "Something went wrong!")
                    return
                }
                completionHandlerForDeleteSession(true, nil)
            }
        }
    }
    
    func postStudent(firstName: String, lastName:String, lat:Double, long:Double, location:String, link: String, completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(link)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        let headers = [String:String]()
        
        taskForPOSTMethod(URLExtentions.StudentLocation, parameters: parameters, headers: headers, jsonBody: jsonBody, withFirst5:false) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostStudent(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                completionHandlerForPostStudent(true, nil)
            }
        }
    }
}
