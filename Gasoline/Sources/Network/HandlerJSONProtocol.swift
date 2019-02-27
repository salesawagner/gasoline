//
//  HandlerJSONProtocol.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONCompletionHandler = (Result<[String: Any]>) -> ()

let baseURL = "https://api.gotinder.com"

protocol HandlerJSONProtocol {
	static func handle(result: Result<Any>, completionHandler: JSONCompletionHandler)
	static func handleSuccessfulAPICall(for json: Any, completionHandler: JSONCompletionHandler)
	static func handleFailedAPICall(for error: Error, completionHandler: JSONCompletionHandler)
}

extension HandlerJSONProtocol {

	static func handle(result: Result<Any>, completionHandler: JSONCompletionHandler) {
		switch result {
			case .success(let json): self.handleSuccessfulAPICall(for: json, completionHandler: completionHandler)
			case .failure(let error): self.handleFailedAPICall(for: error, completionHandler: completionHandler)
		}
	}

	static func handleSuccessfulAPICall(for json: Any, completionHandler: JSONCompletionHandler) {
		guard let json = json as? [String: Any] else {
			let error = NetworkError.badJSON
			self.handleFailedAPICall(for: error, completionHandler: completionHandler)
			return
		}
		completionHandler(Result.success(json))
	}

	static func handleFailedAPICall(for error: Error, completionHandler: JSONCompletionHandler) {
		completionHandler(Result.failure(error))
	}

}
