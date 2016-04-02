//
//  Utils.swift
//  instagram
//
//  Created by Antonio Sejas on 2/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}