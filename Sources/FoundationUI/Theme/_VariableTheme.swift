//
//  VariableTheme.swift
//  
//
//  Created by Art Lasovsky on 18/01/2024.
//

//import Foundation
//import SwiftUI
//
//struct Variable {
//    var value: CGFloat
//    
//    init(_ value: CGFloat) {
//        self.value = value
//    }
//    
//    func callAsFunction(_ variant: Self) -> CGFloat {
//        variant.value
//    }
//    
//    func callAsFunction(adjust: (CGFloat) -> CGFloat) -> CGFloat {
//        adjust(value)
//    }
//}
//
//extension Variable {
//    static let small = regular { $0 / 2 }
//    static let regular = Self(6)
//    static let large = Self(12)
//}
//
//#Preview {
//    VStack {
//        Text(Variable.small.description)
//    }
//    .padding()
//}
