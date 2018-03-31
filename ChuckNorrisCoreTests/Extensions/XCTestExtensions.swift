import XCTest
import Mockingjay

extension XCTest {
	@discardableResult public func stub(url: String, jsonFileName: String) -> Mockingjay.Stub? {
		return stub(uri(url), jsonFileName: jsonFileName)
	}

	@discardableResult public func stub(_ matcher: @escaping Matcher, jsonFileName: String) -> Mockingjay.Stub? {
		guard let data = Bundle.testing.jsonData(with: jsonFileName) else {
			XCTFail("Could not read json file \(jsonFileName)")
			return nil
		}

		return stub(matcher, jsonData(data))
	}
}
