import Fluent
import Vapor

struct HomeContext: Encodable {
	var name: String
	var parsedPosts: [ParsedPost]
}

func routes(_ app: Application) throws {
    app.get { req async throws -> View in
		let posts = try await Post.query(on: req.db).with(\.$tags).all()
		let parsedPosts = posts.map { post in
			let tags = post.tags.map { $0.name }
			return ParsedPost(title: post.title, paragraphs: post.content.components(separatedBy: "\n"), tags: tags)
		}
        return try await req.view.render("index", HomeContext(name: "Helder Sérvio", parsedPosts: parsedPosts))
    }

    try app.register(collection: PostsController())
    try app.register(collection: TagsController())
}
