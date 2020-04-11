import Vapor
import Fluent

final class ProductsController {
    func get(_ request: Request) throws -> EventLoopFuture<[ProductResponse]> {
        let querybuilder = Product.query(on: request.db)

        if let categoryId = try request.query.get(Int?.self, at: "categoryId") {
            querybuilder.filter(\.$categoryId == categoryId)
        }
        if let query = try request.query.get(String?.self, at: "query") {
            querybuilder.filter(\.$name ~~ query)
            _ = querybuilder.group(.or) {
                $0.filter(\Product.$name ~~ query).filter(\Product.$description ~~ query)
            }
        }
        if let idsString = try request.query.get(String?.self, at: "ids") {
            let ids:[Int] = idsString.split(separator: ",").map { Int(String($0)) ?? 0 }
            querybuilder.filter(\.$id ~~ ids)
        }

        return querybuilder.all().map { products in
            return products.map { ProductResponse(id: $0.id!, name: $0.name, price: $0.price, description: $0.description, categoryId: $0.categoryId) }
        }
    }

    func new(_ request: Request) throws -> EventLoopFuture<ProductResponse> {
        let content = try request.content.decode(ProductInput.self)

        let product = Product(
            name: content.name,
            description: content.description,
            price: content.price,
            categoryId: content.categoryId
        )

        return product.save(on: request.db)
            .transform(to:
                ProductResponse(
                    id: product.id!,
                    name: product.name,
                    price: product.price,
                    description: product.description,
                    categoryId: product.categoryId
                )
            )
    }

    func edit(_ request: Request) throws -> EventLoopFuture<ProductResponse> {
        let id = request.parameters.get("id", as: Int.self)
        let content = try request.content.decode(ProductInput.self)

        return Product.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = content.name
                product.price = content.price
                product.description = content.description
                product.categoryId = content.categoryId

                return product.update(on: request.db)
                    .transform(to:
                        ProductResponse(
                            id: product.id!,
                            name: product.name,
                            price: product.price,
                            description: product.description,
                            categoryId: product.categoryId
                        )
                    )
            }
    }

    func delete(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let id = request.parameters.get("id", as: Int.self)

        return Product.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                return product.delete(on: request.db).transform(to: .ok)
            }
    }
}
