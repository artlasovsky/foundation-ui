//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

public class FoundationUIConfig {
    public let padding: TokenizedValues<CGFloat>
    public let radius: TokenizedValues<CGFloat>
    public init(
        padding: TokenizedValues<CGFloat> = .init(xs: 2, sm: 4, base: 8, lg: 14, xl: 18),
        radius: TokenizedValues<CGFloat> = .init(xs: 2, sm: 4, base: 8, lg: 14, xl: 18)
    ) {
        self.padding = padding
        self.radius = radius
    }
}
