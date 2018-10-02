import Foundation

public enum Business {
	public static var pathComponent: String { return "business" }
	
	// MARK: - /business/logo
	
	public enum Logo {
		public typealias Response = Data
	}
}
