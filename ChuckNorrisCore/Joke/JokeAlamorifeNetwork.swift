import Alamofire

public final class JokeAlamorifeNetwork: JokeNetwork {
	public init() {}

	public func fetchRandomJoke(of category: Joke.Category? = nil, then: @escaping (Result<Joke>) -> Void) {
		let url = "https://api.chucknorris.io/jokes/random"

		let parameters = category.map { ["category": $0] }

		let request = Alamofire.request(url,
										method: .get,
										parameters: parameters,
										encoding: URLEncoding.default,
										headers: nil)

		request.responseJSON { response in
			guard let data = response.data else {
				let error = response.error ?? JokeError.invalidNetworkResponse
				then(Result.fail(error: error))
				return
			}

			do {
				let joke = try JSONDecoder().decode(Joke.self, from: data)
				then(Result.success(value: joke))
			} catch {
				then(Result.fail(error: error))
			}
		}
	}
}
