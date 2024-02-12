import Fluent

struct AddDatesToPosts: AsyncMigration {
    func prepare(on database: Database) async throws {
		try await database.schema("post")
			.field("createdAt", .datetime, .required)
			.update()
		try await database.schema("post")
			.field("updatedAt", .datetime, .required)
			.update()
	}

    func revert(on database: Database) async throws {
        try await database.schema("post")
			.deleteField("createdAt")
			.update()
        try await database.schema("post")
			.deleteField("updatedAt")
			.update()
    }
}
