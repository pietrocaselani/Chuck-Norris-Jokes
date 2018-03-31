import XCTest
@testable import ChuckNorrisCore

final class JokeTests: XCTestCase {
	private func jsonDataForFile(with name: String) -> Data {
		let testBundle = Bundle(for: JokeTests.self)

		guard let jsonPath = testBundle.path(forResource: name, ofType: "json") else {
			Swift.fatalError("JSON with name \(name) not found")
		}

		let jsonURL = URL(fileURLWithPath: jsonPath)

		guard let data = try? Data(contentsOf: jsonURL) else {
			Swift.fatalError("Can't open JSON with name \(name)")
		}

		return data
	}

	func testJoke_should_parse_json_without_categories() throws {
		//Given
		let data = jsonDataForFile(with: "random_joke")

		//When
		let joke = try JSONDecoder().decode(Joke.self, from: data)

		//Then
		let expectedJoke = Joke.mock()
		XCTAssertEqual(joke, expectedJoke)
	}

	func testJoke_should_parse_json_with_categories() throws {
		//Given
		let data = jsonDataForFile(with: "dev_joke")

		//When
		let joke = try JSONDecoder().decode(Joke.self, from: data)

		//Then
		let expectedJoke = Joke.mock(category: ["dev"])
		XCTAssertEqual(joke, expectedJoke)
	}
}
