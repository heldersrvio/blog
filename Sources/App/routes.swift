import Fluent
import Vapor

let AUTHOR_NAME = "Helder Sérvio"

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
        return try await req.view.render("index", HomeContext(name: AUTHOR_NAME, parsedPosts: parsedPosts))
    }

	app.get("about") { req async throws -> View in
		try await req.view.render("About", ["name": AUTHOR_NAME])
	}

	app.get("cv") { req async throws -> View in
		try await req.view.render("CV", ["name": AUTHOR_NAME])
	}

    try app.register(collection: PostsController())
    try app.register(collection: TagsController())
}
