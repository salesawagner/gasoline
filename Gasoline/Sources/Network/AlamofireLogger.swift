//
//  AlamofireLogger.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Alamofire

extension DataRequest {
	
	/// The logging level. `.simple` prints only a brief request/response description; `.verbose` prints the request/response body as well.
	public enum LogLevel {
		/// Prints the request and response at their respective `.simple` levels.
		case simple
		/// Prints the request and response at their respective `.verbose` levels.
		case verbose
	}
	
	/// Log the request and response at the specified `level`.
	public func log(_ level: LogLevel = .simple) -> Self {
		switch level {
		case .simple:
			return logRequest(.simple).logResponse(.simple)
		case .verbose:
			return logRequest(.verbose).logResponse(.verbose)
		}
	}
	
}

// MARK: - Request logging

extension DataRequest {
	
	/// The request logging level. `.simple` prints only the HTTP method and path; `.verbose` prints the request body as well.
	public enum RequestLogLevel {
		/// Print the request's HTTP method and path.
		case simple
		/// Print the request's HTTP method, path, and body.
		case verbose
	}
	
	/// Log the request at the specified `level`.
	@discardableResult public func logRequest(_ level: RequestLogLevel = .simple) -> Self {
		guard let method = request?.httpMethod, let path = request?.url?.absoluteString else {
			return self
		}
		
		if case .verbose = level, let data = request?.httpBody, let body = String(data: data, encoding: .utf8) {
			Log.n("\(method) \(path): \"\(body)\"")
		} else {
			Log.n("\(method) \(path)")
		}
		
		return self
	}
	
}

// MARK: - Response logging

extension DataRequest {
	
	/// The response logging level. `.simple` prints only the HTTP status code and path; `.verbose` prints the response body as well.
	public enum ResponseLogLevel {
		/// Print the response's HTTP status code and path, or error if one is returned.
		case simple
		/// Print the response's HTTP status code, path, and body, or error if one is returned.
		case verbose
	}
	
	/// Log the response at the specified `level`.
	@discardableResult public func logResponse(_ level: ResponseLogLevel = .simple) -> Self {
		return response { response in
			guard let code = response.response?.statusCode, let path = response.request?.url?.absoluteString else {
				return
			}
			
			if case .verbose = level, let data = response.data, let body = String(data: data, encoding: .utf8) {
				Log.n("\(code) \(path): \"\(body)\"")
			} else {
				Log.n("\(code) \(path)")
			}
		}
	}
	
}
