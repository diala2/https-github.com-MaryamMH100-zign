//
//  GridPattern.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI
struct GridPattern: View {
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 20
            Path { path in
                for x in stride(from: 0, to: geo.size.width, by: spacing) {
                    for y in stride(from: 0, to: geo.size.height, by: spacing) {
                        path.addEllipse(in: CGRect(x: x, y: y, width: 2, height: 2))
                    }
                }
            }
            .fill(Color.white.opacity(0.1))
        }
    }
}
