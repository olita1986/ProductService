import Vapor

struct ProductInput: Content {
    let name: String
    let price: Int
    let description: String
    let categoryId: Int
}
