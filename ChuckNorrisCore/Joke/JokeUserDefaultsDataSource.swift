import Foundation

public final class JokeUserDefaultsDataSource: JokeDataSource {
	static let jokesKey = "jokesKey"
	private let userDefaults: UserDefaults

	public init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	public func fetchAllJokes() -> [Joke] {
		let jokesData = fetchJokesDataFromUserDefaults()

		let decoder = JSONDecoder()
		let jokes: [Joke]

		do {
			jokes = try jokesData.map { try decoder.decode(Joke.self, from: $0) }
		} catch {
			jokes = [Joke]()
		}

		return jokes

//		return (try? jokesData.map { try decoder.decode(Joke.self, from: $0) }) ?? [Joke]()
	}

	public func save(joke: Joke) throws {
		let isJokeAbsentFromDataSource = !fetchAllJokes().contains(joke)
		guard isJokeAbsentFromDataSource else {
			throw JokeError.jokeAlreadyExistsOnDataSource
		}

		var dataArray = fetchJokesDataFromUserDefaults()
		let newJokeData = try JSONEncoder().encode(joke)

		dataArray.append(newJokeData)

		userDefaults.set(dataArray, forKey: JokeUserDefaultsDataSource.jokesKey)
	}

	private func fetchJokesDataFromUserDefaults() -> [Data] {
		return userDefaults.array(forKey: JokeUserDefaultsDataSource.jokesKey) as? [Data] ?? [Data]()
	}
}
