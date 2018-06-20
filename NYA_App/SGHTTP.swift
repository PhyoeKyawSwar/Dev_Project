//
//  SGHTTP.swift
//  mmas_ios
//
//  Created by Htain Lin Shwe on 31/1/17.
//  Copyright © 2017 mmas. All rights reserved.
//

import Foundation
import PKHUD
struct SGHTTPResponse {
    var result: Any?
    var error: NSError?
    var status : Int?
    
}

class SGHTTP {
    
    private var statusCode = Int()
    private var headers: Dictionary<String,String> = Dictionary()
    
    private var debug = true
    
    enum Method: String {
        case GET = "GET",
        POST = "POST",
        PATCH = "PATCH",
        DELETE = "DELETE"
        
    }
    
    func setHeader(key: String,value: String) {
        headers[key] = value
    }
    
    func get(url: String,completion:@escaping ((SGHTTPResponse) -> Void)) {
        HUD.show(.systemActivity)
        self.send(url: url, httpMethod: .GET, param: nil, completion: completion)
        
    }
    func delete(url: String,completion:@escaping ((SGHTTPResponse) -> Void)) {
        HUD.show(.systemActivity)
        self.send(url: url, httpMethod: .DELETE, param: nil, completion: completion)
        
    }
    
    func post(url: String,params: Dictionary<String,String>?,completion:@escaping ((SGHTTPResponse) -> Void)) {
        HUD.show(.systemActivity)
        let paramString = paramToString(params: params)
        
        self.send(url: url, httpMethod: .POST, param: paramString, completion: completion)
        
    }
    func patch(url: String,params: Dictionary<String,String>?,completion:@escaping ((SGHTTPResponse) -> Void)) {
        
        HUD.show(.systemActivity)
        let paramString = paramToString(params: params)
        
        self.send(url: url, httpMethod: .PATCH, param: paramString, completion: completion)
        
    }
    
    private func send(url: String,httpMethod: Method,param: String?, completion: @escaping ((SGHTTPResponse) -> Void)) {
        
        
        let sendURL:URL = (URL(string: url))!
        let session = URLSession.shared
        
        var request = URLRequest(url: sendURL)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        for key in headers.keys {
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        if let paramString = param , httpMethod == .POST   {
            print("in http body")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                self.statusCode = httpStatus.statusCode
                
            }
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                
                let res = SGHTTPResponse(result: nil, error: error as NSError?,status : httpStatus?.statusCode)
                completion(res)
                return
            }
            
           
            
            do {
                
                if self.debug {
                    if let responseText = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseText)
                    }
                }
                
                
                let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                let httpres = SGHTTPResponse(result: res, error: nil,status : httpStatus?.statusCode)
                
                completion(httpres)
                return
            }
            catch {
                
                let userInfo =
                    [
                        NSLocalizedDescriptionKey:  "JSON ERROR",
                        NSLocalizedFailureReasonErrorKey : "JSON ERROR"
                ]
                
                let error = NSError(domain: "com.comquas.request", code: 909, userInfo: userInfo)
                
                let httpres = SGHTTPResponse(result: nil, error: error,status : httpStatus?.statusCode)
                completion(httpres)
                
                return
            }
            
           
        }
        DispatchQueue.main.async {
            HUD.hide()
        }
        task.resume()
        
        
    }
    
    
    private func paramToString(params: Dictionary<String,String>?) -> String {
        var paramString = ""
        
        if let params = params {
        
            for key in params.keys {
        
                paramString += key + "=" + params[key]! + "&"
            }
            if (paramString != "" ) {
                paramString.remove(at: paramString.index(before: paramString.endIndex))
            }
        }
        
        return paramString
    }
    
    
    
}
