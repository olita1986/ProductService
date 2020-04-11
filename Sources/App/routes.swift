import Fluent
import Vapor
import SimpleJWTMiddleware

func routes(_ app: Application) throws {
    let root = app.grouped(.anything, "users")
    let auth = root.grouped(SimpleJWTMiddleware())
    app.get(.anything, "name", "health") { req in
        return "Healthy!"
    }

    let productsController = ProductsController()
    let categoriesController = CategoriesController()

    root.get("categories", use: categoriesController.get)
    auth.post("categories", use: categoriesController.new)
    auth.patch("categories/:id", use: categoriesController.edit)
    auth.delete("categories/:id", use: categoriesController.delete)

    root.get("", use: productsController.get)
    auth.post("", use: productsController.new)
    auth.patch(":id", use: productsController.edit)
    auth.delete(":id", use: productsController.delete)
}
