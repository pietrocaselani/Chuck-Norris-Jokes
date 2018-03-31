import Foundation

extension Bundle {
	static var testing: Bundle {
		guard let bundle = Bundle(identifier: "io.github.pietrocaselani.ChuckNorrisCoreTests") else {
			Swift.fatalError("Bundle not found")
		}

		return bundle
	}

	func jsonString(with name: String) -> String? {
		guard let data = jsonData(with: name) else {
			return nil
		}

		return String(data: data, encoding: .utf8)
	}

	func jsonData(with name: String) -> Data? {
		guard let jsonPath = Bundle.testing.path(forResource: name, ofType: "json") else {
			return nil
		}

		return try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
	}
}
