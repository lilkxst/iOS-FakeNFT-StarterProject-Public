import UIKit

// struct User {
//    let ranking: Int
//    let avatarURL: String
//    let username: String
//    let nftCount: Int
// }

struct User: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
