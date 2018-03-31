import XCTest
@testable import ChuckNorrisCore

final class JokeUserDefaultsDataSourceTests: XCTestCase {
	func testJokeDataSource_should_return_empty_array_when_userDefaults_is_empty() {
		//Given
		let userDefaults = UserDefaults(suiteName: #function)!
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		XCTAssertNil(userDefaults.object(forKey: JokeUserDefaultsDataSource.jokesKey))

		//When
		let jokes = dataSource.fetchAllJokes()

		XCTAssertEqual(jokes.count, 0)
	}

	func testJokeDataSource_should_return_empty_array_when_userDefaults_is_corrupted() {
		//Given
		let userDefaults = UserDefaults(suiteName: #function)!
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		userDefaults.mockCorrupted(for: JokeUserDefaultsDataSource.jokesKey)

		//When
		let jokes = dataSource.fetchAllJokes()

		//Then
		XCTAssertEqual(jokes.count, 0)
	}

	func testJokeDataSource_should_return_jokes_from_userDefaults() throws {
		//Given
		let jokesCount = 3
		let userDefaults = UserDefaults(suiteName: #function)!
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		try userDefaults.mockJokes(jokesCount, using: JokeUserDefaultsDataSource.jokesKey)

		//When
		let jokes = dataSource.fetchAllJokes()

		//Then
		XCTAssertEqual(jokes.count, 3)
	}

	func testJokeDataSource_should_throw_if_joke_already_exists() throws {
		//Given
		let userDefaults = UserDefaults(suiteName: #function)!
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		try userDefaults.insert(jokes: [Joke.mock()], using: JokeUserDefaultsDataSource.jokesKey)

		//Should throw
		XCTAssertThrowsError(try dataSource.save(joke: Joke.mock()))
	}

	func testJokeDataSource_should_save_on_userDefaults() throws {
		//Given
		let userDefaults = UserDefaults(suiteName: #function)!
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		let joke = Joke.mock()
		userDefaults.clear()

		//When
		try dataSource.save(joke: joke)

		//Then
		let expectedJokes = [joke]

		guard let dataArray = userDefaults.array(forKey: JokeUserDefaultsDataSource.jokesKey) as? [Data] else {
			XCTFail("Can't cast to [Data]")
			return
		}

		XCTAssertEqual(dataArray.count, 1)

		let decoder = JSONDecoder()

		do {
			let jokes = try dataArray.map { try decoder.decode(Joke.self, from: $0) }
			XCTAssertEqual(jokes, expectedJokes)
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
}
