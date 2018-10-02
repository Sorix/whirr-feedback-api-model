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
			
			public init(surveyID: UUID, questions: [String]) {
				self.surveyID = surveyID
				self.questions = questions
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
			/// Expected request model for `POST /survey/:id/answer`
			public struct Request: Codable {
				public let businessID: String
				public let surveyID: UUID
				public let questions: [Question]
				public var additionalInformation: String?
				
				public init(businessID: String, surveyID: UUID, questions: [Question]) {
					self.businessID = businessID
					self.surveyID = surveyID
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
