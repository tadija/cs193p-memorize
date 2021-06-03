//
//  View+HideKeyboard.swift
//  Memorize
//
//  Created by Marko Tadić on 6/21/20.
//  Copyright © 2020 Marko Tadić. All rights reserved.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
