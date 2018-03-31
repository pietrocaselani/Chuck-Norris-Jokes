public enum Result<T: Hashable>: Hashable {
	case success(value: T)
	case fail(error: Error)

	public var hashValue: Int {
		switch self {
		case .success(let value):
			return "success".hashValue ^ value.hashValue
		case .fail:
			return "fail".hashValue
		}
	}

	public static func ==(lhs: Result<T>, rhs: Result<T>) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
