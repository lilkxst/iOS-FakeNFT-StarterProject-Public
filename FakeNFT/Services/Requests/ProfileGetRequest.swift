import Foundation

struct ProfileGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
