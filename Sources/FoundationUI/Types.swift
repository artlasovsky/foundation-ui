//
//  File.swift
//  
//
//  Created by Art Lasovsky on 1/4/2023.
//

import Foundation
import SwiftUI

public typealias ValueWithVariant<K: VariantKey, V> = (default: V, variants: Variant<K, V>)
public typealias Variant<K: VariantKey, V> = [K:V]
public protocol VariantKey: Hashable {}
public enum SizeVariant: VariantKey {
    case small
    case medium
    case large
}
public enum RadiusVariant: VariantKey {
    case small
    case medium
    case large
    case full
}
public enum TintVariant: VariantKey {
    case primary
    case secondary
    case tertiary
    case quaternary
    case accent
    case destructive
    case warning
    case custom(_ color: Color)
}
