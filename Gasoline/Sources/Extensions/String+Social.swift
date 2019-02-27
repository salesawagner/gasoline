//
//  String+Social.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

extension String {
	var instagram: String {

		var username = ""
		for string in String.instagramArray {
			guard let match = self.matches(for: String.createPattern(string: string)).first else { continue }
			username = match.replacingOccurrences(of: string, with: "")
			break
		}

		return username
	}

	var snapchat: String {

		var username = ""
		for string in String.snapchatArray {
			guard let match = self.matches(for: String.createPattern(string: string)).first else { continue }
			username = match.replacingOccurrences(of: string, with: "")
			break
		}

		return username
	}
}

extension String {
	func matches(for regex: String) -> [String] {

		let text = self.lowercased()

		do {
			let regex = try NSRegularExpression(pattern: regex)
			let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
			return results.map {
				String(text[Range($0.range, in: text)!])
			}
		} catch let error {
			Log.e("invalid regex: \(error.localizedDescription)")
		}

		return []
	}
}

extension String {
	static var instagramArray: [String] {
		var regArray = [String]()
		
		regArray.append("@")
		
		regArray.append("insta ")
		regArray.append("insta:")
		regArray.append("insta: ")
		regArray.append("insta : ")
		regArray.append("insta📷:")
		regArray.append("insta📷: ")
		regArray.append("insta📷 : ")
		regArray.append("insta📷 ")
		regArray.append("insta📸:")
		regArray.append("insta📸: ")
		regArray.append("insta📸 : ")
		regArray.append("insta📸 ")
		
		regArray.append("instagram ")
		regArray.append("instagram:")
		regArray.append("instagram: ")
		regArray.append("instagram : ")
		regArray.append("instagram📷:")
		regArray.append("instagram📷: ")
		regArray.append("instagram📷 : ")
		regArray.append("instagram📷 ")
		regArray.append("instagram📸:")
		regArray.append("instagram📸: ")
		regArray.append("instagram📸 : ")
		regArray.append("instagram📸 ")
		
		regArray.append("ig ")
		regArray.append("ig:")
		regArray.append("ig: ")
		regArray.append("ig : ")
		regArray.append("ig📷:")
		regArray.append("ig📷: ")
		regArray.append("ig📷 : ")
		regArray.append("ig📷 ")
		regArray.append("ig📸:")
		regArray.append("ig📸: ")
		regArray.append("ig📸 : ")
		regArray.append("ig📸 ")
		
		regArray.append("📷:")
		regArray.append("📷: ")
		regArray.append("📷 : ")
		regArray.append("📷 ")
		regArray.append("📸:")
		regArray.append("📸: ")
		regArray.append("📸 : ")
		regArray.append("📸 ")
		
		return regArray
	}
	
	static var snapchatArray: [String] {
		
		var regArray = [String]()
		
		regArray.append("snap ")
		regArray.append("snap:")
		regArray.append("snap: ")
		regArray.append("snap : ")
		
		regArray.append("snap👻 ")
		regArray.append("snap👻:")
		regArray.append("snap👻: ")
		regArray.append("snap👻 : ")
		
		regArray.append("snapchat ")
		regArray.append("snapchat:")
		regArray.append("snapchat: ")
		regArray.append("snapchat : ")
		
		regArray.append("snapchat👻 ")
		regArray.append("snapchat👻:")
		regArray.append("snapchat👻: ")
		regArray.append("snapchat👻 : ")
		
		regArray.append("👻")
		regArray.append("👻 ")
		regArray.append("👻:")
		regArray.append("👻: ")
		regArray.append("👻 : ")
		
		return regArray
	}
	
	static func createPattern(string: String) -> String {
		return "(?:\(string))([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\\.(?!\\.))){0,28}(?:[A-Za-z0-9_]))?)"
	}
}
