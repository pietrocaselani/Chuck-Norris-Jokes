public protocol JokeView: class {
	var presenter: JokePresenter! { get }

	func show(jokes: [Joke])
	func showError(message: String)
}

public protocol JokePresenter {
	init(view: JokeView, input: JokeInputBoundary)

	func fetchJoke(of category: Joke.Category?, forcing update: Bool)
}

public protocol JokeOutputBoundary {
	func jokesAvailable(jokes: [Joke])
	func handle(error: Error)
}

public protocol JokeInputBoundary {
	init(dataSource: JokeDataSource, network: JokeNetwork)

	func fetchRandomJoke(of category: Joke.Category?, forcing update: Bool, using output: JokeOutputBoundary)
}

public protocol JokeNetwork {
	func fetchRandomJoke(of category: Joke.Category?, then: @escaping (Result<Joke>) -> Void)
}

public protocol JokeDataSource {
	func fetchAllJokes() -> [Joke]
	func save(joke: Joke) throws
}
