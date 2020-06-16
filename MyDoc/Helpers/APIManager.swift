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
    func getListBook(type: BookType, page: Int, callback: (([Book], Error?)->Void)?)
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
                        callback?(json, nil)
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
    
    func getListBook(type: BookType, page: Int, callback: (([Book], Error?) -> Void)?) {
        let url = "lists.json"
        let params: Parameters = [
            "offset": (page - 1) * kLimitItemPerPage,
            "list": type.rawValue
        ]
        
        self.sendRequest(method: .get, url: url, parameters: params) { (json, error) in
            if let error = error {
                callback?([], error)
                
            } else {
                let results = json["results"]
                let books: [Book] = Book.getArray(json: results)
                
                callback?(books, nil)
            }
        }
    }
    
}
