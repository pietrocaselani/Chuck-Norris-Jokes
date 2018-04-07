import XCTest
import ChuckNorrisCore
@testable import Chuck_Norris

class JokeViewControllerTests: XCTestCase {
	private var viewController: JokeViewController!
	private var presenter: JokeMocks.Presenter!
	private var alertVerifier: QCOMockAlertVerifier!

	override func setUp() {
		super.setUp()

		let storyboard = UIStoryboard(name: "Joke", bundle: nil)
		guard let jokeViewController = storyboard.instantiateInitialViewController() as? JokeViewController else {
			Swift.fatalError("Could not instantiate JokeViewController")
		}

		presenter = JokeMocks.Presenter(view: jokeViewController)
		jokeViewController.presenter = presenter

		viewController = jokeViewController

		alertVerifier = QCOMockAlertVerifier()
	}

	override func tearDown() {
		viewController = nil
		presenter = nil
		alertVerifier = nil
		super.tearDown()
	}

	func testJokeViewController_when_view_is_loaded_notify_presenter() {
		//App starts

		//When
		viewController.preloadView()

		//Then
		XCTAssertTrue(presenter.fetchInvoked)
		XCTAssertEqual(presenter.fetchInvokedCount, 1)
	}

	func testJokeViewController_when_user_ask_for_more_jokes_notify_presenter() {
		//Given
		viewController.preloadView()

		//When
		viewController.addJoke(self)
		viewController.addJoke(self)

		//Then
		XCTAssertEqual(presenter.fetchInvokedCount, 3)
	}

	func testJokeViewController_when_user_clicks_on_addJokeButton_should_notify_presenter() {
		//Given
		viewController.preloadView()

		//When
		viewController.addJokeButton.sendActions(for: .touchUpInside)

		//Then
		XCTAssertTrue(presenter.fetchInvoked)
	}

	func testJokeViewController_tableView_should_display_the_same_jokes_count() {
		//Given
		viewController.preloadView()
		let jokes = [Joke.mock(), Joke.mock()]
		viewController.show(jokes: jokes)

		//When
		let rows = viewController.tableView.numberOfRows(inSection: 0)

		//Then
		XCTAssertEqual(rows, 2)
	}

	func testJokeViewController_tableView_should_display_cells_with_joke() {
		//Given
		viewController.preloadView()
		let jokes = [Joke.mock(value: "joke1"), Joke.mock(value: "joke2"), Joke.mock(value: "joke3")]
		viewController.show(jokes: jokes)

		//When
		let cell1 = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? JokeCell
		let cell2 = viewController.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? JokeCell
		let cell3 = viewController.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? JokeCell

		XCTAssertEqual(cell1?.jokeLabel.text, "joke1")
		XCTAssertEqual(cell2?.jokeLabel.text, "joke2")
		XCTAssertEqual(cell3?.jokeLabel.text, "joke3")
	}

	func testJokeViewController_should_display_alert_when_receives_error() {
		//Given
		viewController.preloadView()
		UIApplication.shared.keyWindow?.rootViewController = viewController

		//When
		let message = "Connection unavailable"
		viewController.showError(message: message)

		//Then
		guard let actionsTitle = alertVerifier.actionTitles as? [String] else {
			XCTFail("Should be an instance of [String]")
			return
		}

		XCTAssertEqual(alertVerifier.title, "Error")
		XCTAssertEqual(alertVerifier.message, message)
		XCTAssertEqual(actionsTitle, ["OK"])
	}

	func testJokeViewController_when_user_clicks_ok_alert_should_dismiss_alert() {
		//Given
		viewController.preloadView()
		UIApplication.shared.keyWindow?.rootViewController = viewController
		viewController.showError(message: "Connection unavailable")

		//When
		alertVerifier.executeActionForButton(withTitle: "OK")

		//Then
		XCTAssertNil(viewController.presentingViewController)
	}
}
