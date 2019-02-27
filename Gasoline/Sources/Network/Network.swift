//
//  Network.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 09/02/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

let kBaseUrl	= "https://api.gotinder.com/"
let kUpdate		= "updates"

typealias Response = DataResponse<Any>

public enum Services: String {
	
	case Auth		= "auth"

	// swiftlint:disable:next cyclomatic_complexity
	func getStringUrl(_ tinder: GASTinder? = nil) -> String {
		return kBaseUrl + self.rawValue
	}
}

// MARK: - Class -

class Network: NSObject {

	// MARK: - Singleton

	static let shared = Network()

	// MARK: - Properties

	var headers: HTTPHeaders {
		var defaultHeaders = HTTPHeaders()
		if let user = MTPUser.userLogged, let token = user.tinderToken {
			defaultHeaders["X-Auth-Token"] = token
		}
		
		return defaultHeaders
	}
	
	// MARK: - Constructors

	private override init() {
		super.init()
	}

	// MARK: - Private Methods

	private func statusCode(response: Response) -> Int {
		var statusCode = 0
		if let response = response.response {
			statusCode = response.statusCode
		}
		if statusCode == 401 {
			UIViewController.goToLogin()
		}
		return statusCode
	}

	private func networkActivity(visible: Bool) {
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = visible
		}
	}

	// MARK: - Internal Methods

	func request(url: String,
	             method: HTTPMethod,
	             parameters: [String: Any]? = nil,
	             completion: @escaping RequestCompletion) {

		self.networkActivity(visible: true)

		let request = Alamofire.request(url,
		                                method: method,
		                                parameters: parameters,
		                                encoding: JSONEncoding.default,
		                                headers: self.headers)

		request.response { _ in
			self.networkActivity(visible: false)
		}

		request.validate(contentType: ["application/json"]).responseJSON { response in
			let statusCode = self.statusCode(response: response)
			let json = JSON(response.result.value ?? JSON([:]))
			completion(json, response.error, statusCode)
		}
	}

}
