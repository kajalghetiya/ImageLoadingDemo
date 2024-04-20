//
//  ImageViewModel.swift
//  PrashantAcharyaDemo
//
//  Created by Kajal Ghetiya on 18/04/24.
//

import Foundation

class ImageViewModel {
    
    var arrImages: [ImageModel]?

    func sendNetworkRequest(apiUrl: String, loderBlock: @escaping ((Bool) -> Void) , completionBlock: @escaping ((String, Bool) -> Void)) {
        loderBlock(true)
                ApiManager.sharedInstance.sendRequestToServer(apiURL: apiUrl , httpMethod: HttpMethod.get) { response, error in
                    loderBlock(false)
                    if response != nil {
                        self.arrImages = response
                    }
                    completionBlock("",true)
                }
    }
    
    
    
    
}
