import Fluent
import FluentPostgresDriver
import Vapor
import SimpleJWTMiddleware

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(CORSMiddleware())

    guard let jwksString = Environment.process.JWKS else {
        fatalError("No value was found at the given public jey environment 'JWKS'")
    }

    guard let postgresPassword = Environment.process.POSTGRES_CRED else {
        fatalError("No value was found at the given public key env 'POSTGRES_CRED'")
    }

    app.databases.use(
        .postgres(
            hostname: "localhost",
            port: 5432,
            username: "service_products",
            password: postgresPassword,
            database: "service_products"
        ),
        as: .psql
    )

    try app.jwt.signers.use(jwksJSON: jwksString)

    app.migrations.add(CreateProduct())
    app.migrations.add(CreateCategory())
    // register routes
    try routes(app)
}
