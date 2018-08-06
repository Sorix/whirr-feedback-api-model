import Foundation

public protocol PathMakeable {
	static var pathComponent: String { get }
	static var parentPath: PathMakeable.Type? { get }
}

public extension PathMakeable {
	static var parentPath: PathMakeable.Type? { return nil }
}
