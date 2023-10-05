//
//  Color.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif

private extension Color {
    /// HSBA components of Color
    func getHSBA() -> (hue: Double, saturation: Double, brightness: Double, alpha: Double) {
        var h: CGFloat = 0
        var b: CGFloat = 0
        var s: CGFloat = 0
        var a: CGFloat = 0
        #if os(macOS)
        NSColor(self)
            .getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        #endif
        #if os(iOS)
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        #endif
        return (h, s, b, a)
    }
}
