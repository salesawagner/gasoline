//
//  TinderJSONClient.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

enum TinderJSONClient: HandlerJSONProtocol {

	static func auth(parameters: [String: Any], _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.auth(parameters: parameters)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func like(tinderID: String, _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.like(tinderID: tinderID)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func superLike(tinderID: String, _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.superLike(tinderID: tinderID)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func disLike(tinderID: String, _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.disLike(tinderID: tinderID)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func unMatch(matchID: String, _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.unMatch(matchID: matchID)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func user(tinderID: String, _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.user(tinderID: tinderID)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func profile(parameters: [String: Any], _ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.profile(parameters: parameters)) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func recs(_ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.recs) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func updates(_ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.updates) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

	static func topPicks(_ completionHandler: @escaping JSONCompletionHandler) {
		AlamoFireJSONClient.makeAPICall(to: TinderEndPoint.topPicks) { result in
			self.handle(result: result, completionHandler: completionHandler)
		}
	}

}
