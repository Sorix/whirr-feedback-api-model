import Foundation

public enum Survey: PathMakeable {
	public static var pathComponent: String { return "survey" }
	
	// MARK: - GET /survey/:id
	
	public enum GetSurvey {
		public static var parentPath: PathMakeable.Type? { return Survey.self }
		
		/// Server's response model for `GET /survey/:id`
		public struct Response: Codable {
			public let surveyID: UUID
			public let questions: [String]
			public var additionalInformationRequirement: AdditionalInformation?
			public var thanksForFillingSurveyText: String
			public var templateForPlaceCategory: String?
			
			public init(surveyID: UUID, questions: [String], thanksForFillingSurveyText: String) {
				self.surveyID = surveyID
				self.questions = questions
				self.thanksForFillingSurveyText = thanksForFillingSurveyText
			}
			
			public struct AdditionalInformation: Codable {
				public var requirementText: String
				public var terms: URL?
				public var answerValidatorPredicate: String = "true"
				
				public init(requirementText: String) {
					self.requirementText = requirementText
				}
			}
		}
	}
	
	// MARK: - /survey/:id/response
	
	public enum SurveyResponse {
		public static var pathComponent: String { return "response" }
		public static var parentPath: PathMakeable.Type? { return Survey.self }
		
		// MARK: POST /survey/:id/answer
		
		public enum Create {
			/// Expected request model for `POST /survey/:survey-idid/response`
			public struct Request: Codable {
				public let adaptiveID: AdaptiveID
				public let questions: [Question]
				public var additionalInformation: String?
				
				public init(adaptiveID: AdaptiveID, questions: [Question]) {
					self.adaptiveID = adaptiveID
					self.questions = questions
				}
				
				@available(*, deprecated, message: "Use `.init(adaptiveID:surveyID,questions:)` in future")
				public init(businessID: String, questions: [Question]) throws {
					self.adaptiveID = try AdaptiveID(stringValue: businessID)
					self.questions = questions
				}
				
				public struct Question: Codable {
					public let questionText: String
					public let rating: Double
					
					public init(text: String, rating: Double) {
						self.questionText = text
						self.rating = rating
					}
				}
			}
			
			/// Server's response model for `POST /survey/:id/answer`
			public struct Response: Codable {
				public let surveyResponseID: UUID
				public let thankYouText: String
				public let reviewSites: [ReviewSiteWithURL]
				
				public init(responseID: UUID, thankYouText: String, reviewSites: [ReviewSiteWithURL]) {
					self.surveyResponseID = responseID
					self.thankYouText = thankYouText
					self.reviewSites = reviewSites
				}
				
				public struct ReviewSiteWithURL: Codable {
					public let siteName: ReviewSiteName
					public let reviewURL: URL
					
					public init(siteName: ReviewSiteName, url: URL) {
						self.siteName = siteName
						self.reviewURL = url
					}
				}
			}
		}
	}
	
	// MARK: - GET /survey/:survey-id/response/:response-id/status
	public struct GetSurveyResponse {
		public static var pathComponent: String { return "status" }
		
		public struct ServerResponse: Codable {
			public enum ReplyStatus {
				case replied(text: String, coupon: Coupon?)
				case notReplied
			}
			
			public struct Coordinate: Codable {
				public var latitude, longitude: Double
				
				public init(latitude: Double, longitude: Double) {
					self.latitude = latitude
					self.longitude = longitude
				}
			}
			
			public struct Coupon: Codable {
				public let title: String
				public let detailInfo: String
				public let validTo: Date?
				public let imageUrl: URL?
				public let location: Coordinate?
				public let termsUrl: URL?
				public let passUrl: URL
			}
			
			public let status: ReplyStatus
			
			public init(status: ReplyStatus) {
				self.status = status
			}
		}
	}
	
	// MARK: - Check additional information
	public enum CheckAdditionalInformation {
		public static var pathComponent: String { return "check-additional-information" }
		public struct Response: Codable {
			public let status: Status
			
			public init(status: Status) {
				self.status = status
			}
			
			public enum Status: String, Codable {
				case valid, invalid
			}
		}
	}
}

// MARK:
extension Survey.GetSurveyResponse.ServerResponse.ReplyStatus: Codable {
	private enum CodableAction: String, Codable {
		case replied, notReplied
	}
	
	private enum CodingKeys: String, CodingKey {
		case value, text, coupon
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		switch self {
		case .notReplied: try container.encode(CodableAction.notReplied, forKey: .value)
		case .replied(let text, let coupon):
			try container.encode(CodableAction.replied, forKey: .value)
			try container.encode(text, forKey: .text)
			try container.encode(coupon, forKey: .coupon)
		}
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let action = try container.decode(CodableAction.self, forKey: .value)
		
		switch action {
		case .notReplied: self = .notReplied
		case .replied:
			let text = try container.decode(String.self, forKey: .text)
			let coupon = try container.decodeIfPresent(Survey.GetSurveyResponse.ServerResponse.Coupon.self, forKey: .coupon)
			
			self = .replied(text: text, coupon: coupon)
		}
		
	}
}
