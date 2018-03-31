import XCTest
@testable import ChuckNorrisCore

final class JokeInteractorTests: XCTestCase {
	func testJokeInteractor_when_there_is_joke_on_dataSource_doesnot_hit_network() {
		//Given
		let dataSource = JokeMocks.DataSource(jokes: [Joke.mock()])
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(using: output)

		//Then
		XCTAssertTrue(dataSource.fetchInvoked)
		XCTAssertFalse(network.fetchInvoked)
		XCTAssertFalse(dataSource.saveInvoked)
	}

	func testJokeInteractor_when_there_is_joke_on_dataSource_and_force_update_hits_network() {
		//Given
		let dataSource = JokeMocks.DataSource(jokes: [Joke.mock()])
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(forcing: true, using: output)

		//Then
		XCTAssertTrue(dataSource.fetchInvoked)
		XCTAssertTrue(network.fetchInvoked)
		XCTAssertTrue(dataSource.saveInvoked)
	}

	func testJokeInteractor_when_there_is_no_joke_on_dataSource_fetches_from_network_and_saves_on_dataSource() {
		//Given
		let dataSource = JokeMocks.DataSource()
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(using: output)

		//Then
		XCTAssertTrue(dataSource.fetchInvoked)
		XCTAssertTrue(dataSource.saveInvoked)
		XCTAssertTrue(network.fetchInvoked)
	}

	func testJokeInteractor_when_network_throws_error_notify_output() {
		//Given
		let networkError = NSError(domain: "api.chucknorris.com", code: 100, userInfo: nil)
		let dataSource = JokeMocks.DataSource()
		let network = JokeMocks.Network(error: networkError)
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(using: output)

		//Then
		XCTAssertFalse(dataSource.saveInvoked)
		XCTAssertTrue(dataSource.fetchInvoked)
		XCTAssertTrue(network.fetchInvoked)
		XCTAssertTrue(output.handleErrorInvoked)
		XCTAssertFalse(output.jokesAvailableInvoked)
	}

	func testJokeInteractor_when_dataSource_throws_error_on_save_notify_output() {
		//Given
		let dataSourceError = NSError(domain: "datasource", code: 1, userInfo: nil)
		let dataSource = JokeMocks.DataSource(error: dataSourceError)
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(using: output)

		//Then
		XCTAssertTrue(dataSource.saveInvoked)
		XCTAssertTrue(dataSource.fetchInvoked)
		XCTAssertTrue(network.fetchInvoked)
		XCTAssertTrue(output.handleErrorInvoked)
		XCTAssertFalse(output.jokesAvailableInvoked)
	}

	func testJokeInteractor_call_network_without_category() {
		//Given
		let dataSource = JokeMocks.DataSource()
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(using: output)

		//Then
		XCTAssertTrue(network.fetchInvoked)
		XCTAssertNil(network.fetchParameters)
	}

	func testJokeInteractor_call_network_with_correct_parameters() {
		//Given
		let dataSource = JokeMocks.DataSource()
		let network = JokeMocks.Network()
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(of: "awesome", using: output)

		//Then
		XCTAssertTrue(network.fetchInvoked)
		XCTAssertEqual(network.fetchParameters, "awesome")
	}

	func testJokeInteractor_notify_output_with_jokes_from_dataSource_and_network() {
		//Given
		let dataSource = JokeMocks.DataSource(jokes: [Joke.mock()])
		let network = JokeMocks.Network(joke: Joke.mock(id: "id", iconURL: "url", link: "link", value: "hey"))
		let output = JokeMocks.Output()
		let interactor = JokeInteractor(dataSource: dataSource, network: network)

		//When
		interactor.fetchRandomJoke(forcing: true, using: output)

		//Then
		XCTAssertTrue(output.jokesAvailableInvoked)

		guard let parameters = output.jokesAvailableParameter else {
			XCTFail("Parameters can't be nil")
			return
		}

		XCTAssertEqual(parameters.count, 2)
	}
}
