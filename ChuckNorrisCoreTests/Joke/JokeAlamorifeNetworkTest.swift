import XCTest
import Mockingjay
@testable import ChuckNorrisCore

final class JokeAlamorifeNetworkTest: XCTestCase {
	func testJokeNetwork_should_emit_error_when_json_is_invalid() {
		//Given
		let network = JokeAlamorifeNetwork()
		self.stub(everything, jsonFileName: "invalid_joke")

		//When
		let networkExpectation = expectation(description: "Should emit error")

		network.fetchRandomJoke { result in
			//Then
			networkExpectation.fulfill()

			switch result {
			case .success:
				XCTFail("Should be fail!")
			case .fail(let error):
				let expectedErrorMessage = "The data couldn’t be read because it is missing."
				XCTAssertEqual(error.localizedDescription, expectedErrorMessage)
			}
		}

		wait(for: [networkExpectation], timeout: 1)
	}

	func testJokeNetwork_should_emit_joke_when_json_is_valid() {
		//Given
		let network = JokeAlamorifeNetwork()
		self.stub(everything, jsonFileName: "random_joke")

		//When
		let networkExpectation = expectation(description: "Should emit joke")

		network.fetchRandomJoke { result in
			//Then
			networkExpectation.fulfill()

			switch result {
			case .fail:
				XCTFail("Should be success!")
			case .success(let joke):
				let expectedJoke = Joke.mock()
				XCTAssertEqual(joke, expectedJoke)
			}
		}

		wait(for: [networkExpectation], timeout: 1)
	}
}
