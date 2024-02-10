import Vapor

struct TagsController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let tags = routes.grouped("tags")
		tags.get(use: index)
		tags.post(use: create)

		tags.group(":id") { tag in
			tag.get(use: show)
			tag.put(use: update)
			tag.delete(use: delete)
		}
	}

	func index(req: Request) async throws -> [Tag] {
		try await Tag.query(on: req.db).all()
	}

	func create(req: Request) async throws -> Tag {
		let tag = try req.content.decode(Tag.self)
		try await tag.save(on: req.db)
		return tag
	}

	func show(req: Request) async throws -> Tag {
		guard let tag = try await Tag.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		return tag
	}

	func update(req: Request) async throws -> Tag {
		guard let tag = try await Tag.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		let updatedTag = try req.content.decode(Tag.self)
		tag.name = updatedTag.name
		try await tag.save(on: req.db)
		return tag
	}

	func delete(req: Request) async throws -> HTTPStatus {
		guard let tag = try await Tag.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		try await tag.delete(on: req.db)
		return .ok
	}
}

