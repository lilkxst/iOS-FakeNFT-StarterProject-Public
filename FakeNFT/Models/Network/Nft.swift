import Foundation

struct Nft: Decodable {
        let createdAt, name: String
        let images: [URL]
        let rating: Int
        let description: String
        let price: Float
        let author: String
        let id: String
}
