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
	
	public enum Beacon {
		public static var pathComponent: String { return "beacon" }
		public static var parentPath: PathMakeable.Type? { return Search.self }
		
		public struct Request: Codable {
			public var major: Int
			public var minor: Int
			
			public init(major: Int, minor: Int) {
				self.major = major
				self.minor = minor
			}
		}
		
		public struct Response: Codable {
			public struct NotificationOptions: Codable {
				public let adaptiveID: AdaptiveID
				public var placeLogo: URL?
				public let notifyIn: TimeInterval
				public let notificationText: String
				
				public init(adaptiveID: AdaptiveID, notifyIn: TimeInterval, notificationText: String) {
					self.adaptiveID = adaptiveID
					self.notifyIn = notifyIn
					self.notificationText = notificationText
				}
			}
			
			public enum Action {
				case doNothing
				case showReviewPage(notificationOptions: NotificationOptions)
			}
			
			public let action: Action
			
			public init(action: Action) {
				self.action = action
			}
		}
	}
	
	public struct BusinessModel: Codable {
		public let adaptiveID: AdaptiveID
		public let title: String
		public let surveyID: UUID
		
		public init(id: AdaptiveID, title: String, surveyID: UUID) {
			self.adaptiveID = id
			self.title = title
			self.surveyID = surveyID
		}
	}
}

extension Search.Beacon.Response.Action: Codable {
	private enum CodingKeys: String, CodingKey {
		case value, notificationOptions
	}
	
	private enum CodableAction: String, Decodable {
		case doNothing, showReviewPage
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		switch self {
		case .doNothing:
			try container.encode(CodableAction.doNothing.rawValue, forKey: .value)
		case .showReviewPage(let notificationOptions):
			try container.encode(CodableAction.showReviewPage.rawValue, forKey: .value)
			try container.encode(notificationOptions, forKey: .notificationOptions)
		}
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let action = try container.decode(CodableAction.self, forKey: .value)
		
		switch action {
		case .doNothing: self = .doNothing
		case .showReviewPage:
			let options = try container.decode(Search.Beacon.Response.NotificationOptions.self, forKey: .notificationOptions)
			self = .showReviewPage(notificationOptions: options)
		}
	}
	
}

