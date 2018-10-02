import Foundation

public enum Search: PathMakeable {
	public static var pathComponent: String { return "search" }
	
	// MARK: - /search/coordinate
	
	public enum Coordinate: PathMakeable {
		public static var pathComponent: String { return "coordinate" }
		public static var parentPath: PathMakeable.Type? { return Search.self }
		
		public struct URLParametersRequest {
			public var latitude: Double
			public var longitude: Double
			
			public init(latitude: Double, longitude: Double) {
				self.latitude = latitude
				self.longitude = longitude
			}
		}
		
		public typealias Response = [BusinessModel]
	}
	
	public enum Code: PathMakeable {
		public static var pathComponent: String { return "code" }
		public static var parentPath: PathMakeable.Type? { return Search.self }
		
		public struct URLParametersRequest {
			public var code: Int
			
			public init(code: Int) {
				self.code = code
			}
		}
		
		public typealias Response = BusinessModel
	}
	
	public enum BusinessID: PathMakeable {
		public static var pathComponent: String { return "business-id" }
		public static var parentPath: PathMakeable.Type? { return Search.self }
		
		public typealias Response = BusinessModel
	}
	
	public struct BusinessModel: Codable {
		public let businessID: String
		public let title: String
		public let surveyID: UUID
		
		public init(id: String, title: String, surveyID: UUID) {
			self.businessID = id
			self.title = title
			self.surveyID = surveyID
		}
	}
}
