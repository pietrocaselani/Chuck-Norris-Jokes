import ChuckNorrisCore
import Foundation

extension Joke {
	init(id: String, iconURL: String, link: String, value: String, category: [Category]?) {
		self.id = id
		self.iconURL = iconURL
		self.link = link
		self.value = value
		self.category = category
	}

	static func mock(id: String = "__6apjNfTNaygcAhe6Zh8w",
					 iconURL: String = "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
					 link: String = "https://api.chucknorris.io/jokes/__6apjNfTNaygcAhe6Zh8w",
					 value: String = "Once when Chuck Norris was a child.....who are we kidding, Chuck Norris was born a man",
					 category: [Category]? = nil) -> Joke {
		return Joke(id: id, iconURL: iconURL, link: link, value: value, category: category)
	}
}

extension UserDefaults {
	func mockJokes(_ count: Int, using key: String) throws {
		let jokes = (1...count).map { i in
			Joke.mock(id: "joke\(i)", iconURL: "iconURL\(i)", link: "link\(i)", value: "value\(i)", category: nil)
		}

		try insert(jokes: jokes, using: key)
	}

	func mockCorrupted(for key: String) {
		let jsonData = Bundle.testing.jsonData(with: "invalid_joke") ?? Data()
		self.set([jsonData], forKey: key)
	}

	func insert(jokes: [Joke], using key: String) throws {
		let encoder = JSONEncoder()

		let jokesData = try jokes.map { try encoder.encode($0) }

		self.set(jokesData, forKey: key)
	}

	func clear() {
		for (key, _) in self.dictionaryRepresentation() {
			self.removeObject(forKey: key)
		}
	}
}
