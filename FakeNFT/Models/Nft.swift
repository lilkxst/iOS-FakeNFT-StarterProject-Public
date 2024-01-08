import Foundation

struct Nft: Decodable {
    let id: String
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    var isLiked: Bool?
    let currencyId: String?
    var currency: Currency?
}
