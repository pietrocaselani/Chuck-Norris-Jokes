public protocol JokeView: class {
	var presenter: JokePresenter! { get }
	func show(jokes: [Joke])
	func showError(message: String)
}

public protocol JokePresenter {
	init(view: JokeView, input: JokeInputBoundary)
	func fetchJoke(of category: Joke.Category?)
}

public protocol JokeOutputBoundary {
	func jokesAvailable(jokes: [Joke])
	func handle(error: Error)
}

public protocol JokeInputBoundary {
	init(repository: JokeRepository)
	func fetchRandomJoke(of category: Joke.Category?, using output: JokeOutputBoundary)
}

public protocol JokeRepository {
    func fetchAllJokes() [Joke]
    func save(joke: Joke) throws
}