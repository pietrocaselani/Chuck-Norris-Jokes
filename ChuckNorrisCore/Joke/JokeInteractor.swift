public final class JokeInteractor: JokeInputBoundary {
	private let dataSource: JokeDataSource
	private let network: JokeNetwork

	public init(dataSource: JokeDataSource, network: JokeNetwork) {
		self.dataSource = dataSource
		self.network = network
	}

	public func fetchRandomJoke(of category: Joke.Category? = nil, forcing update: Bool = false, using output: JokeOutputBoundary) {
		let dataSource = self.dataSource
		var jokes = dataSource.fetchAllJokes()

		guard update || jokes.isEmpty else {
			output.jokesAvailable(jokes: jokes)
			return
		}

		network.fetchRandomJoke(of: category) { result in
			switch result {
			case .success(let joke):
				do {
					try dataSource.save(joke: joke)
					jokes.append(joke)
					output.jokesAvailable(jokes: jokes)
				} catch {
					output.handle(error: error)
				}
			case .fail(let error):
				output.handle(error: error)
			}
		}
	}
}
