import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        var components = URLComponents(string: "https://\(RequestConstants.baseURL)/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "sortBy", value: "rating"),
            URLQueryItem(name: "order", value: "desc")
        ]
        return components?.url
    }
}

struct UserProfileRequest: NetworkRequest {
    let userId: String

    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/users/\(userId)")
    }
}

struct NFTsRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "https://\(RequestConstants.baseURL)/api/v1/nft")
    }
}

struct CurrencyRequest: NetworkRequest {
    let currencyId: String

    var endpoint: URL? {
        return URL(string: "https://\(RequestConstants.baseURL)/api/v1/currencies/\(currencyId)")
    }
}
