//
//  ApiManager .swift
//  PrashantAcharyaDemo
//
//  Created by Kajal Ghetiya on 18/04/24.
//

import Foundation
import Network

enum HttpMethod {
    case post
    case get
    case delete
}



class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    
    private override init() {
        super.init()
    }
    
     func sendRequestToServer(apiURL: String, httpMethod: HttpMethod, completionHandler: @escaping (([ImageModel]?, String?) -> Void)) {
         
        if NetworkMonitor.shared.isReachable == false {
            completionHandler(nil,ErrorConstant.noInterNet)
        } else {
            guard let url = URL(string: apiURL) else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    completionHandler(nil,error?.localizedDescription)
                }
                guard data != nil else {
                    print("data is nil")
                    return
                }
                let decoder = JSONDecoder()
                let decodedData = try? decoder.decode([ImageModel].self, from: data!)
                completionHandler(decodedData,nil)
            }.resume()
        }
    }
    
    
    
}
