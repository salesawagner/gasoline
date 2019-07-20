//
//  ResponseError.swift
//  Gasoline
//
//  Created by Wagner Sales on 19/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

enum ResponseError: Int, Error {

    case unknownError = 0
    case invalidRequest = 400
    case invalidCredentials = 401
    case notFound = 404
    case serverError = 500
    case timeOut = -1001

    static func fetch(_ errorCode: Int) -> ResponseError {
        return ResponseError(rawValue: errorCode) ?? .unknownError
    }
}
