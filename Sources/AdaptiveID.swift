import Foundation

/// Adaptive ID that can be used as unified identfier for local business IDs (partners) and 3rd party ID (like Google Place ID) in one string.
public enum AdaptiveID {
	public static var googlePrefix: String { return "google_place_id_" }
	
	case google(String)
	case partner(UUID)
	
	public var stringValue: String {
		switch self {
		case .google(let placeId): return AdaptiveID.googlePrefix + placeId
		case .partner(let id): return id.uuidString
		}
	}
	
	public init(stringValue: String) throws {
		try self.init(stringValue: stringValue, codingPath: [CodingKey]())
	}
	
	internal init(stringValue: String, codingPath: [CodingKey]) throws {
		if stringValue.hasPrefix(AdaptiveID.googlePrefix) {
			let valueWithoutPrefix = stringValue.replacingOccurrences(of: AdaptiveID.googlePrefix, with: String())
			self = .google(valueWithoutPrefix)
		} else {
			guard let uuid = UUID(uuidString: stringValue) else {
				throw DecodingError.typeMismatch(UUID.self, DecodingError.Context(codingPath: codingPath, debugDescription: String()))
			}
			self = .partner(uuid)
		}
	}
}

extension AdaptiveID: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let string = try container.decode(String.self)
		
		try self.init(stringValue: string, codingPath: container.codingPath)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(stringValue)
	}
}
