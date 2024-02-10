import Vapor

class ParsedPost: Codable {
    var title: String
	var paragraphs: [String]
	var tags: [String]

    init(title: String, paragraphs: [String], tags: [String]) {
        self.title = title
        self.paragraphs = paragraphs
		self.tags = tags
    }
}
