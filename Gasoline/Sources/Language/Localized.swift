//
//  Localized.swift
//  wascar
//
//  Created by Wagner Sales on 23/11/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import Foundation

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}

struct L {
	//LOADING
	static var wait: String {
		return "WAIT".localized
	}
	static var loading: String {
		return "LOADING".localized
	}
	//ALERT
	static var ok: String {
		return "OK".localized
	}
	static var sorry: String {
		return "SORRY".localized
	}
	static var somethingWentWrong: String {
		return "SOMETHING WRONG".localized
	}
	static var congratulations: String {
		return "CONGRATULATIONS".localized
	}
	static var newMatch: String {
		return "YOU HAVE A NEW MATCH".localized
	}
}
