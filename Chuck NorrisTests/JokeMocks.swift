import ChuckNorrisCore
import Foundation

final class JokeMocks {
	private init() {}

	final class Presenter: JokePresenter {
		var fetchInvoked = false
		var fetchInvokedCount = 0

		init(view: JokeView,
			 input: JokeInputBoundary = JokeInteractor(dataSource: JokeUserDefaultsDataSource(userDefaults: UserDefaults.standard), network: JokeAlamorifeNetwork())) {

		}

		func fetchJoke(of category: Joke.Category?, forcing update: Bool) {
			fetchInvoked = true
			fetchInvokedCount += 1
		}
	}
}
