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
		if let user = User.logged(), let token = user.token {
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

		request.logRequest(.simple)
//        request.logResponse(.verbose)
        debugPrint(request)

        request.validate().responseJSON { response in

            let statusCode = request.response?.statusCode ?? 0
            if 400..<500 ~= statusCode {
                let error = ResponseError.fetch(statusCode)
                completionHandler(Result.failure(error))
                UIViewController.goToLogin()
                return
            } else {
                switch response.result {
                    case .success(let value): completionHandler(Result.success(value))
                    case .failure(let error): completionHandler(Result.failure(error))
                }
            }
		}
	}

    @discardableResult
	static func requestImage(url: String, completion: @escaping AlamofireImageCompletionHandler) -> DataRequest {
		let request = Alamofire.request(url)
		return request.responseImage { response in
			completion(response.value)
		}
	}
}
