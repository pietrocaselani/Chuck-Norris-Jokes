public enum JokeError: Int, Error {
	case invalidNetworkResponse
	case jokeAlreadyExistsOnDataSource

	public var localizedDescription: String {
		switch self {
		case .invalidNetworkResponse:
			return "Problemas na conexão"
		case .jokeAlreadyExistsOnDataSource:
			return "Piada já existe no banco"
		}
	}
}
