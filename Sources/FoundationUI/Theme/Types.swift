//
//  File.swift
//  
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation

//public typealias Theme = FoundationUI

public protocol FoundationSize {
    static var xsmall: CGFloat { get }
    static var small: CGFloat { get }
    static var regular: CGFloat { get }
    static var large: CGFloat { get }
    static var xlarge: CGFloat { get }
}

extension FoundationUI {
    public struct SizeConfig {
        internal var multiplier: CGFloat
        internal var base: CGFloat
        
        internal var _xsmall: CGFloat?
        internal var _small: CGFloat?
        internal var _regular: CGFloat?
        internal var _large: CGFloat?
        internal var _xlarge: CGFloat?
        
        public init(multiplier: CGFloat, base: CGFloat) {
            self.multiplier = multiplier
            self.base = base
        }
        
        public init(xsmall: CGFloat, small: CGFloat, regular: CGFloat, large: CGFloat, xlarge: CGFloat) {
            self._xsmall = xsmall
            self._small = small
            self._regular = regular
            self._large = large
            self._xlarge = xlarge
            self.multiplier = 1
            self.base = 0
        }
        
        internal var xsmall: CGFloat { _xsmall ?? small / multiplier }
        internal var small: CGFloat { _small ?? regular / multiplier }
        internal var regular: CGFloat { _regular ?? base }
        internal var large: CGFloat { _large ?? regular * multiplier }
        internal var xlarge: CGFloat { _xlarge ?? large * multiplier }
    }
}
