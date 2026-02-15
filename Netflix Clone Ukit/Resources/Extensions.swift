//
//  Extensions.swift
//  Netflix Clone Ukit
//
//  Created by Giorgi Mekvabishvili on 14.02.26.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased()+self.lowercased().dropFirst()
    }
}
