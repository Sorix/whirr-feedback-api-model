import Foundation

public enum MobileDevice: PathMakeable {
	public static var pathComponent: String { return "mobile-device" }
	
	// MARK: - /mobile-device/entered-beacon-zone
	
	public enum EnteredBeaconZone: PathMakeable {
		public static var parentPath: PathMakeable.Type? { return MobileDevice.self }
		public static var pathComponent: String { return "entered-beacon-zone" }
		
		public struct Request: Codable {
			public let uuid: UUID
			public let majorValue: Int
			public let minorValue: Int?
			
			public init(uuid: UUID, majorValue: Int, minorValue: Int?) {
				self.uuid = uuid
				self.majorValue = majorValue
				self.minorValue = minorValue
			}
		}
	}
	
	// MARK: - /mobile-device/register-for-push
	
	public enum RegisterForPushNotifications {
		public static var pathComponent: String { return "register-for-push" }
		public static var parentPath: PathMakeable.Type? { return MobileDevice.self }
		
		public struct Request: Codable {
			public let base64EncodedToken: String
			
			public init(base64EncodedToken: String) {
				self.base64EncodedToken = base64EncodedToken
			}
		}
	}
}
