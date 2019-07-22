//
//  URL+Social.swift
//  Gasoline
//
//  Created by Wagner Sales on 22/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

extension URL {
    private static func openUrl(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    static func openInstagram(_ userName: String) {
        let instagramHooks = String(format: "instagram://user?username=%@", userName)
        self.openUrl(instagramHooks)
    }

    static func openSnap(_ userName: String) {
        let snapHooks = String(format: " snapchat://add/[%@", userName)
        self.openUrl(snapHooks)
    }
}
