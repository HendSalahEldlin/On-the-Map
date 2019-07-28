//
//  Client.swift
//  On the Map
//
//  Created by Hend  on 7/19/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
class OnTheMapClient : NSObject {
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var userID : String? = nil
    public var students = [StudentInformation]()
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // create a URL from parameters
    func createURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = OnTheMapClient.Constants.ApiScheme
        components.host = OnTheMapClient.Constants.ApiHost
        components.path = OnTheMapClient.Constants.ApiPath + (withPathExtension ?? "")
        if parameters.count > 0{
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    // MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], withFirst5 : Bool, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var urlParameters = parameters
    
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: createURLFromParameters(urlParameters, withPathExtension: method))
        print(request.url!)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, withFirst5: withFirst5, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], headers: [String : String],jsonBody: String, withFirst5:Bool, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var urlParameters = parameters
        var requestHeaders = headers
        requestHeaders["content-type"] = "application/json"
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: createURLFromParameters(urlParameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print(request.url)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, withFirst5: withFirst5, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var urlParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: createURLFromParameters(urlParameters, withPathExtension: method))
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        print(request.url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, withFirst5: true, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, withFirst5: Bool, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var newData : Data
        if withFirst5{
            let range = 5..<data.count
            newData = data.subdata(in: range) /* subset response data! */
        }else{
            newData = data
        }
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> OnTheMapClient {
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        return Singleton.sharedInstance
    }
}
