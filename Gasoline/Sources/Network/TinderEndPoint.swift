//
//  TinderEndPoint.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire


enum TinderEndPoint: AlamofireEndPoint {

	case auth(parameters: Parameters)
	case like(tinderID: String)
	case superLike(tinderID: String)
	case disLike(tinderID: String)
	case unMatch(matchID: String)
	case user(tinderID: String)
	case profile(parameters: Parameters)
	case recs
	case updates
	case topPicks

	// MARK: - AlamofireEndPoint conforming methods

	func provideValues() -> AlamofireProvider {

		switch self {

			case .auth(let parameters):
				let url = baseURL + "/v2/auth/login/facebook"
				return (url: url, httpMethod: .post, parameters: parameters, encoding: JSONEncoding.default)

			case .like(let tinderID):
				let url = baseURL + "/like/" + tinderID
				return (url: url, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)

			case .superLike(let tinderID):
				let url = baseURL + "/like/" + tinderID + "/super"
				return (url: url, httpMethod: .post, parameters: nil, encoding: URLEncoding.default)

			case .disLike(let tinderID):
				let url = baseURL + "/pass/" + tinderID
				return (url: url, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)

			case .unMatch(let matchID):
				let url = baseURL + "/user/matches/" + matchID
				return (url: url, httpMethod: .delete, parameters: nil, encoding: URLEncoding.default)

			case .user(let tinderID):
				let url = baseURL + "/user/" + tinderID
				return (url: url, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)

			case .profile(let parameters):
				let url = baseURL + "/v2/profile/user"
				return (url: url, httpMethod: .post, parameters: parameters, encoding: JSONEncoding.default)

			case .recs:
				let url = baseURL + "/v2/recs/core"
				return (url: url, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)

			case .updates:
				let url = baseURL + "/updates"
				return (url: url, httpMethod: .post, parameters: [:], encoding: JSONEncoding.default)

			case .topPicks:
				let url = baseURL + "/v2/top-picks/preview"
				return (url: url, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)
		}
	}
}
