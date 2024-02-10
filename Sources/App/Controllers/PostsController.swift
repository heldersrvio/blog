import Vapor

struct PostsController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let posts = routes.grouped("posts")
		posts.get(use: index)
		posts.post(use: create)

		posts.group(":id") { post in
			post.get(use: show)
			post.put(use: update)
			post.delete(use: delete)
		}
	}

	func index(req: Request) async throws -> [Post] {
		try await Post.query(on: req.db).all()
	}

	func create(req: Request) async throws -> Post {
		let post = try req.content.decode(Post.self)
		try await post.save(on: req.db)
		return post
	}

	func show(req: Request) async throws -> Post {
		guard let post = try await Post.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		return post
	}

	func update(req: Request) async throws -> Post {
		guard let post = try await Post.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		let updatedPost = try req.content.decode(Post.self)
		post.title = updatedPost.title
		post.content = updatedPost.content
		try await post.save(on: req.db)
		return post
	}

	func delete(req: Request) async throws -> HTTPStatus {
		guard let post = try await Post.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		try await post.delete(on: req.db)
		return .ok
	}
}

