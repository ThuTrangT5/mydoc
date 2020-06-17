//
//  APIManager.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/15/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol BookAPIProtocol {
    //    func getListBook(type: BookType, page: Int, callback: (([Book], Error?)->Void)?)
    func getListBook(page: Int, callback: (([Book], Error?)->Void)?)
}

enum APIResponseStatus: String {
    
    case error = "ERROR"
    case success = "OK"
    case unknown
}

class APIManager: NSObject, BookAPIProtocol {
    
    static let shared = APIManager()
    
    private override init() {
        super.init()
    }
    
    private static let baseAPI = "https://api.nytimes.com/svc/books/v3"
    
    func sendRequest(method: HTTPMethod, url: String, parameters: Parameters? = nil, callback:((JSON, Error?)-> Void)?) {
        
        let fullURL = APIManager.baseAPI + "/\(url)"
        var fullParams: Parameters = parameters ?? [:]
        if let apikey = self.getAPIKey() {
            fullParams["api-key"] = apikey
        }
        
        
        let request = AF.request(fullURL, method: method, parameters: fullParams)
        
        request.responseJSON { (response) in
            print("Request cURL:\(request.cURLDescription())")
            
            switch response.result {
            case .success:
                if let value = response.value {
                    let json = JSON(value)
                    
                    let status = APIResponseStatus(rawValue: json["status"].stringValue) ?? .unknown
                    if status == .success {
                        callback?(json["results"], nil)
                        
                    } else {
                        let errorMessage = (json["errors"].arrayObject as? [String])?.joined()
                            ?? "There is an unexpected error. Please check your request!"
                        let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage])
                        callback?(JSON.null, error)
                    }
                    
                } else {
                    callback?(JSON.null, nil)
                }
                break
                
            case let .failure(error):
                callback?(JSON.null, error)
                break
            }
        }
    }
    
    private func getAPIKey() -> String? {
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let nsDictionary = NSDictionary(contentsOfFile: path) as? [String: Any],
            let key = nsDictionary["NY_TIME_API_KEY"] as? String {
            return key
        }
        
        return nil
    }
    
    //    func getListBook(type: BookType, page: Int, callback: (([Book], Error?) -> Void)?) {
    func getListBook(page: Int, callback: (([Book], Error?) -> Void)?) {
        let url = "lists/best-sellers/history.json"
        let params: Parameters = [
//            "list": type.rawValue
            "offset": (page - 1) * kLimitItemPerPage
        ]
        
        self.sendRequest(method: .get, url: url, parameters: params) { (json, error) in
            if let error = error {
                callback?([], error)
                
            } else {
                let books: [Book] = Book.getArray(json: json)
                callback?(books, nil)
            }
        }
    }
    
}
