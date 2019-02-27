//
//  NetworkError.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {

	case badJSON

	public var errorDescription: String? {
		switch self {
		case .badJSON:
			return NSLocalizedString("The data from the server came back in a way we couldn't use", comment: "")
		}
	}

}
