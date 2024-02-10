import Fluent
import Vapor

final class PostTag: Model {
	static let schema = "post+tag"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "post_id")
	var post: Post

	@Parent(key: "tag_id")
	var tag: Tag

	init() { }

	init(id: UUID? = nil, post: Post, tag: Tag) throws {
		self.id = id
		self.$post.id = try post.requireID()
		self.$tag.id = try tag.requireID()
	}
}

