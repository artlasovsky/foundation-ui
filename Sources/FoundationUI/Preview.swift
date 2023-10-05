//
//  File.swift
//  
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI


#Preview {
    struct Preview: View {
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
            VStack {
                Text("Preview")
                    .foregroundColor(.theme.secondary)
                Text("Preview")
                    .foregroundColor(.theme.primary)
                    .padding(.theme.padding.regular)
            }
        }
    }
    return Preview()
}
