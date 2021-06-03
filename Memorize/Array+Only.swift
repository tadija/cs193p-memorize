//
//  Array+Only.swift
//  Memorize
//
//  Created by Marko Tadić on 5/28/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first: nil
    }
}
