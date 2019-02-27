//
//  AuthManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 03/03/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class AuthManager: NSObject {

	/// Login on Facebook and Tinder
	///
	/// - Parameters:
	///   - viewcontroller: ViewController that will appear facebooklogin
	///   - completion: Closure with success or Fail
	class func login(_ viewcontroller: UIViewController, completion: @escaping CompletionSuccess) {
		guard FBSDKAccessToken.current() == nil else {
			self.loginTinder(completion: completion)
			return
		}
		self.loginFace(viewcontroller, completion: completion)
	}

	class func loginFace(_ viewcontroller: UIViewController, completion: @escaping CompletionSuccess) {
		let permissions = ["public_profile"]
		let login = FBSDKLoginManager()
		login.logIn(withReadPermissions: permissions, from: viewcontroller) { (result, _) in
			guard let result = result, result.isCancelled == false else {
				completion(false)
				return
			}
			self.loginTinder(completion: completion)
		}
	}

	class func loginTinder(completion: @escaping (_ sucess: Bool) -> Void) {
		guard let facebookToken = FBSDKAccessToken.current() else {
			completion(false)
			return
		}

		// Params
		var params = [String: Any]()
		params["facebook_token"] = facebookToken.tokenString
		params["facebook_id"] = facebookToken.userID

		TinderJSONClient.auth(parameters: params) { result in
			switch result {
				case .success(let json): do {
					if let _ = MTPUser(json: JSON(json)) {
						completion(true)
					} else {
						completion(false)
						Log.e("Não foi possivel criar usuario")
					}
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					completion(false)
				}
			}
		}

	}

	class func logout() {
		FBSDKAccessToken.setCurrent(nil)
		MTPUser.delete()
	}
}
