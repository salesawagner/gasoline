//
//  HandlerAPIProtocol.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire

//typealias APICompletionHandler = (Result<[String: Any]>) -> ()

let baseURL = "https://api.gotinder.com"

protocol APIHandlerProtocol {
	static func handle(result: Resultzz, completionHandler: APICompletionHandler)
	static func handleSuccessfulAPICall(for json: Any, completionHandler: APICompletionHandler)
	static func handleFailedAPICall(for error: Error, completionHandler: APICompletionHandler)
}

extension APIHandlerProtocol {

	static func handle(result: Result<Any>, completionHandler: APICompletionHandler) {
		switch result {
			case .success(let json): self.handleSuccessfulAPICall(for: json, completionHandler: completionHandler)
			case .failure(let error): self.handleFailedAPICall(for: error, completionHandler: completionHandler)
		}
	}

	static func handleSuccessfulAPICall(for json: Any, completionHandler: APICompletionHandler) {
		guard let json = json as? [String: Any] else {
			let error = NetworkError.badJSON
			self.handleFailedAPICall(for: error, completionHandler: completionHandler)
			return
		}
		completionHandler(Result.success(json))
	}

	static func handleFailedAPICall(for error: Error, completionHandler: APICompletionHandler) {
		completionHandler(Result.failure(error))
	}

}
