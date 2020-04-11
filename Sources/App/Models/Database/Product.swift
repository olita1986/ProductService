import Vapor
import Fluent

final class Product: Model {
    static let schema: String = "products"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "price")
    var price: Int

    @Field(key: "categoryId")
    var categoryId: Int

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "deletedAt", on: .delete)
    var deletedAt: Date?

    @Timestamp(key: "updatedA", on: .update)
    var updatedAt: Date?

    init() {}

    init(
        id: Int? = nil,
        name: String,
        description: String,
        price: Int,
        categoryId: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.categoryId = categoryId
    }
}
