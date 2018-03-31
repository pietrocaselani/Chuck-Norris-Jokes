import UIKit
import ChuckNorrisCore

final class JokeModule {
	private init() {}

	static func setupModule() -> JokeView {
		let storyboard = UIStoryboard(name: "Joke", bundle: Bundle.main)
		guard let jokeViewController = storyboard.instantiateInitialViewController() as? JokeViewController else {
			Swift.fatalError("Could not instantiate JokeViewController")
		}

		let userDefaults = UserDefaults.standard

		let network = JokeAlamorifeNetwork()
		let dataSource = JokeUserDefaultsDataSource(userDefaults: userDefaults)
		let interactor = JokeInteractor(dataSource: dataSource, network: network)
		let presenter = JokeDefaultPresenter(view: jokeViewController, input: interactor)

		jokeViewController.presenter = presenter

		return jokeViewController
	}
}
