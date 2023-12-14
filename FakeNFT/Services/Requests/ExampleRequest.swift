import Foundation

// struct ExampleRequest: NetworkRequest {
//    var endpoint: URL? {
//        URL(string: "INSERT_URL_HERE")
//    }
// }

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
}
