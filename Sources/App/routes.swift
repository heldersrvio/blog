import Fluent
import Vapor

let AUTHOR_NAME = "Helder Sérvio"
let POSTS_PER_PAGE = 1

struct HomeContext: Encodable {
	var name: String
	var parsedPosts: [ParsedPost]
	var previousPage: Int?
	var nextPage: Int?
}

struct PostContext: Encodable {
	var name: String
	var post: ParsedPost
}

func routes(_ app: Application) throws {
    app.get { req async throws -> View in
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy"

		let pageQuery = req.query["page"] ?? "1"
		let page = Int(pageQuery) ?? 1
		let posts = try await Post.query(on: req.db).with(\.$tags).paginate(PageRequest(page: page, per: POSTS_PER_PAGE))
		let previousPage = page > 1 ? page - 1 : nil
		let nextPage = page * POSTS_PER_PAGE < posts.metadata.total ? page + 1 : nil
		let parsedPosts = posts.items.map { post in
			let tags = post.tags.map { $0.name }
			let date = dateFormatter.string(from: post.createdAt!)
			return ParsedPost(id: post.id, title: post.title, paragraphs: post.content.components(separatedBy: "\n"), tags: tags, date: date)
		}
        return try await req.view.render("index", HomeContext(name: AUTHOR_NAME, parsedPosts: parsedPosts, previousPage: previousPage, nextPage: nextPage))
    }

	app.get("about") { req async throws -> View in
		try await req.view.render("About", ["name": AUTHOR_NAME])
	}

	app.get("cv") { req async throws -> View in
		try await req.view.render("CV", ["name": AUTHOR_NAME])
	}

    try app.register(collection: PostsController())
    try app.register(collection: TagsController())

	app.get(":post_id") { req async throws -> View in
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy"

		if let post = try await Post.query(on: req.db).filter(\.$id == req.parameters.get("post_id")!).with(\.$tags).first() {
			let tags = post.tags.map { $0.name }
			let date = dateFormatter.string(from: post.createdAt!)
			let parsedPost = ParsedPost(id: post.id, title: post.title, paragraphs: post.content.components(separatedBy: "\n"), tags: tags, date: date)
			return try await req.view.render("Post", PostContext(name: AUTHOR_NAME, post: parsedPost))
		}
		throw Abort(.notFound)
	}
}
