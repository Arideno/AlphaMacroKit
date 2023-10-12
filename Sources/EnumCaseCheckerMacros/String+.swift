//
//  File.swift
//  
//
//  Created by Andrii Moisol on 12.10.2023.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
