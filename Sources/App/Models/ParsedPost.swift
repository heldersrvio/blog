import Vapor

class ParsedPost: Codable {
	var id: UUID?
    var title: String
	var paragraphs: [String]
	var tags: [String]
	var date: String

    init(id: UUID?, title: String, paragraphs: [String], tags: [String], date: String) {
		self.id = id
        self.title = title
        self.paragraphs = paragraphs
		self.tags = tags
		self.date = date
    }
}
