//
//  Crashlytics+Logging.swift
//  LVLive
//
//  Created by Fabien Mirault on 29/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation
import Crashlytics

func XBLog(_ object: NSObject?) {
    guard let object = object else { return }
    #if DEBUG
        CLSNSLogv("%@", getVaList([object]))
    #else
        CLSLogv("%@", getVaList([object]))
    #endif
}

func XBLog(_ string: String) {
    #if DEBUG
        CLSNSLogv(string, getVaList([]))
    #else
        CLSLogv(string, getVaList([]))
    #endif
}

