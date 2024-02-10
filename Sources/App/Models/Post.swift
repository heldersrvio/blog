import Fluent
import Vapor

final class Post: Model, Content {
    static let schema = "post"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

	@Field(key: "content")
	var content: String

	@Siblings(through: PostTag.self, from: \.$post, to: \.$tag)
	var tags: [Tag]

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
