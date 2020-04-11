import Vapor

struct ProductResponse: Content {
    let id: Int
    let name: String
    let price: Int
    let description: String
    let categoryId: Int
}
