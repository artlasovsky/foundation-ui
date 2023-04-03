//
//  File.swift
//  
//
//  Created by Art Lasovsky on 1/4/2023.
//

import Foundation
import SwiftUI

private struct FoundationRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
private struct FontTintKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}
//private struct StrokeTint: EnvironmentKey {
//    static let defaultValue: Color? = nil
//}
//private struct BackgroundTint: EnvironmentKey {
//    static let defaultValue: Color? = nil
//}

extension EnvironmentValues {
    var foundationRadius: CGFloat {
        get { self[FoundationRadiusKey.self] }
        set { self[FoundationRadiusKey.self] = newValue }
    }
    var fontTint: Color? {
        get { self[FontTintKey.self] }
        set { self[FontTintKey.self] = newValue }
    }
//    var backgroundTint: Color? {
//        get { self[BackgroundTint.self] }
//        set { self[BackgroundTint.self] = newValue }
//    }
//    var strokeTint: Color? {
//        get { self[StrokeTint.self] }
//        set { self[StrokeTint.self] = newValue }
//    }
}
