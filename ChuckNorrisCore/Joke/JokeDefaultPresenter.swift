public final class JokeDefaultPresenter: JokePresenter, JokeOutputBoundary {
	private weak var view: JokeView?
	private let input: JokeInputBoundary

	public init(view: JokeView, input: JokeInputBoundary) {
		self.view = view
		self.input = input
	}

	public func fetchJoke(of category: Joke.Category?, forcing update: Bool = false) {
		input.fetchRandomJoke(of: category, forcing: update, using: self)
	}

	public func jokesAvailable(jokes: [Joke]) {
		view?.show(jokes: jokes)
	}

	public func handle(error: Error) {
		view?.showError(message: error.localizedDescription)
	}
}
