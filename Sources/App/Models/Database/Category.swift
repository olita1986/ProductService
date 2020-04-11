import Vapor
import Fluent

final class Category: Model {
    static let schema: String = "categories"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    init() {}

    init(name: String ) {
        self.name = name
    }
}
