//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/collections")

    }
}

struct ProfileRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/profile/1")

    }
}

struct LikeRequest: NetworkRequest {

    let httpMethod: HttpMethod = .put
    var dto: Encodable?
    var likes: Set<String> //[String]
    var body: Data? {
      
        return likesToString().data(using: .utf8)
    }
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    init(dto: Encodable? = nil, likes: Set<String>) {
        self.dto = dto
        self.likes = likes
    }
    
    func likesToString()->String{
         var likeString = "\(LikeRequestConstants.likes)="
        
        if likes.isEmpty {
            //Формируем пустую строку, чтобы массив лайков был пустой в профиле
            likeString = ""
        } else {
            //Добавляем id из массива
            for (index , like) in likes.enumerated() {
                likeString += like
                
                //Проверяем на разделитель
                if index != likes.count-1 {
                    likeString += ","
                }
            }
        }
        return likeString
    }
    
}

private enum LikeRequestConstants {
    static let likes = "likes"
}
