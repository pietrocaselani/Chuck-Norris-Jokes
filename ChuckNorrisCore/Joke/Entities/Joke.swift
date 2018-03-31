public struct Joke: Hashable, Codable {
	public typealias Category = String

	private enum CodingKeys: String, CodingKey {
		case id
		case iconURL = "icon_url"
		case link = "url"
		case value
		case category
	}

	public let id: String
	public let iconURL: String
	public let link: String
	public let value: String
	public let category: [Category]?

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(String.self, forKey: .id)
		self.iconURL = try container.decode(String.self, forKey: .iconURL)
		self.link = try container.decode(String.self, forKey: .link)
		self.value = try container.decode(String.self, forKey: .value)
		self.category = try container.decodeIfPresent([Category].self, forKey: .category)
	}

	public var hashValue: Int {
		var hash = id.hashValue ^ iconURL.hashValue ^ link.hashValue ^ value.hashValue

		guard let category = category else {
			return hash
		}

		category.forEach { c in
			hash = hash ^ c.hashValue
		}

		return hash
	}

	public static func ==(lhs: Joke, rhs: Joke) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
