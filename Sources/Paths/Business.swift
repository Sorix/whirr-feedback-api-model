import Foundation

public enum Business {
	public static var pathComponent: String { return "business" }
	
	// MARK: - /business/logo
	
	public enum Logo {
		public static var pathComponent: String { return "logo" }
		public typealias Response = URL?
	}
	
	public enum GetShortInfo {
		public typealias Response = Search.BusinessModel
	}
}
