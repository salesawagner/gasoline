//
//  AlamofireEndPoint.swift
//  Gasoline
//
//  Created by Wagner Sales on 11/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire

typealias AlamofireProvider = (url: String, httpMethod: HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding)

protocol AlamofireEndPoint {

	func provideValues() -> AlamofireProvider

	var url: URLConvertible { get }
	var httpMethod: HTTPMethod { get }
	var parameters: [String: Any]? { get }
	var encoding: ParameterEncoding { get }
}

extension AlamofireEndPoint {
	var url: URLConvertible { return provideValues().url }
	var httpMethod: HTTPMethod { return provideValues().httpMethod }
	var parameters: [String: Any]? { return provideValues().parameters }
	var encoding: ParameterEncoding { return provideValues().encoding }
}
