import Foundation

// struct ExampleRequest: NetworkRequest {
//    var endpoint: URL? {
//        URL(string: "INSERT_URL_HERE")
//    }
// }

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "sortBy", value: "rating"),
            URLQueryItem(name: "order", value: "desc")
        ]
        return components?.url
    }
}
