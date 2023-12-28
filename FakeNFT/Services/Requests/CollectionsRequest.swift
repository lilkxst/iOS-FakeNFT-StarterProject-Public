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

struct OrdersGetRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct OrdersPutRequest: NetworkRequest {
    
    let httpMethod: HttpMethod = .put
    var id: String
    var orders: Set<String>
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }
    
    init(id:String, orders: Set<String>) {
        self.orders = orders
        self.id = id
    }
    
    func ordersToString() ->String {
        var ordersString = "\(CatalogRequestConstants.orders)="
        
            if orders.isEmpty {
                //Формируем пустую строку, чтобы массив лайков был пустой в профиле
                ordersString += ""
            } else {
                //Добавляем id из массива
                for (index , order) in orders.enumerated() {
                    ordersString += order
                    
                    //Проверяем на разделитель
                    if index != orders.count-1 {
                        ordersString += ","
                    }
                }
            }
        //Добавляем id заказа
        ordersString += "&\(CatalogRequestConstants.id)=\(id)"
        print(ordersString)
        return ordersString
    }

}


struct LikeRequest: NetworkRequest {

    let httpMethod: HttpMethod = .put
    var dto: Encodable?
    var likes: Set<String>
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
         var likeString = "\(CatalogRequestConstants.likes)="
        
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

public enum CatalogRequestConstants {
    static let likes = "likes"
    static let orders = "nfts"
    static let id = "id"
}
