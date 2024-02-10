import Fluent

struct CreatePosts: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tag")
            .id()
            .field("name", .string, .required)
            .create()
		try await database.schema("post")
			.id()
			.field("title", .string, .required)
			.field("content", .string, .required)
			.create()
		try await database.schema("post+tag")
			.id()
			.field("post_id", .uuid, .required)
			.field("tag_id", .uuid, .required)
			.foreignKey("post_id", references: "post", "id", onDelete: .cascade)
			.foreignKey("tag_id", references: "tag", "id", onDelete: .cascade)
			.unique(on: "post_id", "tag_id")
			.create()
    }

    func revert(on database: Database) async throws {
		try await database.schema("post+tag").delete()
        try await database.schema("post").delete()
		try await database.schema("tag").delete()
    }
}
