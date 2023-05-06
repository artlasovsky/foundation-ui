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
    public let spacing: TokenizedValues<CGFloat>
    public init(
        padding: TokenizedValues<CGFloat> = .init(none: 0, xs: 4, sm: 6, base: 8, lg: 14, xl: 22),
        radius: TokenizedValues<CGFloat> = .init(none: 0, xs: 4, sm: 8, base: 10, lg: 14, xl: 18),
        spacing: TokenizedValues<CGFloat> = .init(none: 0, xs: 2, sm: 4, base: 8, lg: 12, xl: 16)
    ) {
        self.padding = padding
        self.radius = radius
        self.spacing = spacing
    }
}
