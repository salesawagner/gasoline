//
//  Definitions.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 13/03/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

//import UIKit
import SwiftyJSON
typealias Completion = () -> Void
typealias RequestCompletion = (_ response: JSON, _ error: Error?, _ statusCode: Int) -> Void
typealias CompletionSuccess = (_ success: Bool) -> Void
