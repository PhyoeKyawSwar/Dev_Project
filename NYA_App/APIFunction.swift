//
//  APIFunction.swift
//  EatInMyanmar
//
//  Created by Phyo Kyaw Swar on 6/9/17.
//  Copyright © 2017 Creative. All rights reserved.
//

import UIKit
import PKHUD
private let _shareInstance = APIFunction()

class APIFunction: NSObject {
    
    var USER_ID = Int()
    var url_string = String()

    override init()
    {
        
    }
    class var sharedInstance: APIFunction {
        
        return _shareInstance
        
    }
    
   
    func apiFunction (method : String, parameter : [String : Any], methodType : String , completion: @escaping (NSDictionary , Int ) -> ())
    {
        
        var request = URLRequest(url: URL(string: "\(BASE_URL_LOCAL)/" + method.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        print(parameter)
        request.httpMethod = methodType
        request.timeoutInterval = 30
        
        if !parameter.isEmpty
        {
            if method == url_string
            {
                if let json = try? JSONSerialization.data(withJSONObject: parameter, options: [])  {
                    
                    request.httpBody = json
                    print("json",request.httpBody)
                    
                }
            }
            else
            {
                for dict in parameter
                {
                    request.addValue(dict.value as! String, forHTTPHeaderField: dict.key)
                }
            }
            
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN")
        {
            request.addValue("Bearer \(token as! String)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                 return
            }
            
            var dict = NSDictionary()
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 , httpStatus.statusCode != 201 , httpStatus.statusCode != 204 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                
                completion(dict, httpStatus.statusCode)
            }
            else
            {
                let httpStatus = response as? HTTPURLResponse
                do {
                    dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    completion(dict , (httpStatus?.statusCode)!)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
           
        }
        task.resume()
        
        
    }
    
   /* func apiFunctionforAuth (method : String, parameter : [String : Any], methodType : String , completion: @escaping (NSDictionary) -> ())
    {
        
        var request = URLRequest(url: URL(string: auth_url  + method.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        print(request)
        request.httpMethod = methodType
        request.timeoutInterval = 30
        
        if let json = try? JSONSerialization.data(withJSONObject: parameter, options: [])  {
            
            request.httpBody = json
            
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                HUD.hide()
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                HUD.hide()
            }
            print("response = \(String(describing: response))",data)
            
            var dict = NSDictionary()
            
            do {
                dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                completion(dict)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
 
 */
    
    func userAuthicate(parems : Dictionary<String, String> , completion: @escaping ((Dictionary<String,Any>?) -> Void)) {
        
       
        let authURL = "\(auth_url)"
        
        let authHTTP = SGHTTP()
       
        print("URL",auth_url)
        authHTTP.post(url: authURL, params: parems ) { (response) in
            
            if response.error == nil {
                guard let res = response.result as? Dictionary<String,Any> else {
                    completion(nil)
                    return
                }
                
                print(response.result)
               /* if let cart = res["shopping_cart"] as? Dictionary<String,Any> {
                    completion(cart)
                    return
                }
 */
               
                completion(nil)
            }
            completion(nil)
        }
    }
    
    func apiPATCHMethod(method : String ,parems : Dictionary<String, String> , completion: @escaping ((SGHTTPResponse) -> Void)) {
        
       
        let authURL = "\(BASE_URL_LOCAL)/\(method)"
        
        let authHTTP = SGHTTP()
        authHTTP.setHeader(key: "Accept", value: "application/json")
       // authHTTP.setHeader(key: "Content-Type", value: "application/json")
        
        authHTTP.setHeader(key: "Authorization", value: "Bearer \(UserDefaults.standard.value(forKey: "ACCESS_TOKEN") as! String)")
        print("URL",authURL)
        authHTTP.patch(url: authURL, params: parems, completion: completion)
        
        
        /*authHTTP.post(url: authURL, params: parems ) { (response) in
         
         if response.error == nil {
         guard let res = response.result as? Dictionary<String,Any> else {
         completion(nil)
         
         return
         }
         
         print("Response",response.result)
         
         completion(res)
         return
         }
         completion(nil)
         return
         }
         */
    }
    
    func apiPOSTMethod(method : String ,parems : Dictionary<String, String> , completion: @escaping ((SGHTTPResponse) -> Void)) {
        
       
        let authURL = "\(BASE_URL_LOCAL)/\(method)"
        
        let authHTTP = SGHTTP()
        print("Parameter",parems)
        authHTTP.setHeader(key: "Accept", value: "application/json")
      
        if method != "login" && method != "social_login"
        {
            authHTTP.setHeader(key: "Content-Type", value: "application/json")
            
        }
 
        if let token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN") as? String
        {
            authHTTP.setHeader(key: "Authorization", value: "Bearer \(token)")
            
        }
        print("URL",authURL)
        authHTTP.post(url: authURL, params: parems , completion: completion)
        
        
        /*authHTTP.post(url: authURL, params: parems ) { (response) in
            
            if response.error == nil {
                guard let res = response.result as? Dictionary<String,Any> else {
                    completion(nil)
                    
                    return
                }
                
                print("Response",response.result)
                
                completion(res)
                return
            }
            completion(nil)
            return
        }
 */
    }
    
    func apiGETMethod(method : String  ,completion: @escaping ((SGHTTPResponse) -> Void)) {
        
       
        let url = "\(BASE_URL_LOCAL)/\(method.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        print("URL ::::",url)
        let http = SGHTTP()
        
        if let token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN")
        {
            http.setHeader(key: "Authorization", value: "Bearer \(token as! String))")
        //    print("User Token ::::", token as! String)
        
        }
        http.setHeader(key: "Accept", value: "application/json")
       // http.setHeader(key: "Content-Type", value: "application/json")
        http.get(url: url, completion: completion)
        
       
       /* http.get(url: url) { (response) in
           if response.error == nil {
                guard let res = response.result as? Dictionary<String,Any> else {
                    completion(nil)
                    
                    return
                }
                
                print("Response",response.result)
                
                completion(res)
            return
            }
            completion(nil)
            return
 
        } */
        
    }
    
    func apiDELETEMethod(method : String  ,completion: @escaping ((SGHTTPResponse) -> Void)) {
        
        
        let url = "\(BASE_URL_LOCAL)/\(method)"
        print("URL ::::",url)
        let http = SGHTTP()
        if let token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN")
        {
            http.setHeader(key: "Authorization", value: "Bearer \(token as! String))")
            
        }
        http.setHeader(key: "Accept", value: "application/json")
        // http.setHeader(key: "Content-Type", value: "application/json")
        http.delete(url: url, completion: completion)
        
        
        /* http.get(url: url) { (response) in
         if response.error == nil {
         guard let res = response.result as? Dictionary<String,Any> else {
         completion(nil)
         
         return
         }
         
         print("Response",response.result)
         
         completion(res)
         return
         }
         completion(nil)
         return
         
         } */
        
    }
    
    
    
    
}
