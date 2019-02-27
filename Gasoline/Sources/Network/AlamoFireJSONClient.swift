//
//  AlamoFireJSONClient.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire

typealias AlamofireJSONCompletionHandler = (Result<Any>) -> ()
typealias AlamofireImageCompletionHandler = (_ image: UIImage?) -> ()

enum AlamoFireJSONClient {

	static var headers: HTTPHeaders {

		var headers = HTTPHeaders()
		headers["platform"] = "ios"
		if let user = MTPUser.userLogged, let token = user.tinderToken {
			headers["X-Auth-Token"] = token
		}

		return headers
	}

	static func makeAPICall(to endPoint: AlamofireEndPoint,
							completionHandler: @escaping AlamofireJSONCompletionHandler) {

		let request = Alamofire.request(endPoint.url,
										method: endPoint.httpMethod,
										parameters: endPoint.parameters,
										encoding: endPoint.encoding,
										headers: AlamoFireJSONClient.headers)

		request.logRequest(.verbose).logResponse(.simple).validate().responseJSON { response in

			if 400..<500 ~= response.response?.statusCode ?? 0 {
				UIViewController.goToLogin()
			}

			switch response.result {
				case .success(let value): completionHandler(Result.success(value))
				case .failure(let error): completionHandler(Result.failure(error))
			}

		}

	}

	static func requestImage(url: String, completion: @escaping AlamofireImageCompletionHandler) {

		let request = Alamofire.request(url)
		request.responseImage { response in
			completion(response.value)
		}

	}

}
