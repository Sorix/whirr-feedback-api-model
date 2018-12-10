import Foundation

public enum Settings: PathMakeable {
	public static var pathComponent: String { return "settings" }
	
	// MARK: - PUT /settings/profile
	
	public struct Profile: Codable {
		public static var pathComponent: String { return "profile" }
		
		public var name, email: String?
		public var age: Int?
		public var sex: Sex?
		
		public enum Sex: String, Codable {
			case male, female
		}
		
		public init() {}
	}
	
	// MARK: - GET /settings/allowed-place-categories
	
	public enum AllowedCategories {
		public static var pathComponent: String { return "allowed-place-categories" }
		
		public static let response = [String].self
	}
}
