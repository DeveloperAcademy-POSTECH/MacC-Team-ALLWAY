//
//  String+Capitalize.swift
//  bisdam
//
//  Created by user on 4/11/24.
//

import Foundation

extension String {
    func capitalizeOnlyFirstLetter() -> Self {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}
