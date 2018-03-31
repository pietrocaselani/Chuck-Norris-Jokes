import ChuckNorrisCore

final class JokeMocks {
	private init() {}

	final class DataSource: JokeDataSource {
		var fetchInvoked = false
		var saveInvoked = false
		var saveParameters: Joke?

		private var jokes: [Joke]
		private let error: Error?

		init(jokes: [Joke] = [Joke](), error: Error? = nil) {
			self.jokes = jokes
			self.error = error
		}

		func fetchAllJokes() -> [Joke] {
			fetchInvoked = true
			return jokes
		}

		func save(joke: Joke) throws {
			saveInvoked = true
			saveParameters = joke

			if let error = error {
				throw error
			} else {
				jokes.append(joke)
			}
		}
	}

	final class Network: JokeNetwork {
		var fetchInvoked = false
		var fetchParameters: Joke.Category?

		private let joke: Joke
		private let error: Error?

		init(joke: Joke = Joke.mock(), error: Error? = nil) {
			self.joke = joke
			self.error = error
		}

		func fetchRandomJoke(of category: Joke.Category?, then: @escaping (Result<Joke>) -> Void) {
			fetchInvoked = true
			fetchParameters = category

			if let error = error {
				then(Result.fail(error: error))
			} else {
				then(Result.success(value: joke))
			}
		}
	}

	final class Output: JokeOutputBoundary {
		var jokesAvailableInvoked = false
		var jokesAvailableParameter: [Joke]?
		var handleErrorInvoked = false
		var handleErrorParameter: Error?

		func jokesAvailable(jokes: [Joke]) {
			jokesAvailableInvoked = true
			jokesAvailableParameter = jokes
		}

		func handle(error: Error) {
			handleErrorInvoked = true
			handleErrorParameter = error
		}
	}
}
