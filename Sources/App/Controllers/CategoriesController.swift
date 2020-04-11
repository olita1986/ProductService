import Vapor
import Fluent

final class CategoriesController {
    func get(_ request: Request) throws -> EventLoopFuture<[CategoryResponse]> {
        return Category.query(on: request.db)
            .all()
            .map { categories in
                return categories.map {
                    CategoryResponse(id: $0.id!, name: $0.name)
                }
            }
    }

    func new(_ request: Request) throws -> EventLoopFuture<CategoryResponse> {
        let content = try request.content.decode(CategoryInput.self)

        let category = Category(name: content.name)

        return category.save(on: request.db).transform(to: CategoryResponse(id: category.id!, name: category.name))
    }

    func edit(_ request: Request) throws -> EventLoopFuture<CategoryResponse> {
        let id = try request.query.get(Int?.self)
        let content = try request.content.decode(CategoryInput.self)

        return Category.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = content.name

                return category.update(on: request.db).transform(to: CategoryResponse(id: category.id!, name: category.name))
            }
    }

    func delete(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let id = try request.query.get(Int.self)

        return Category.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                return category.delete(on: request.db).transform(to: .ok)
            }
    }
}
