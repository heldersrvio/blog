import Fluent
import Vapor

final class Tag: Model, Content {
	static let schema = "tag"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

	@Siblings(through: PostTag.self, from: \.$tag, to: \.$post)
	public var posts: [Post]
    
	init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

