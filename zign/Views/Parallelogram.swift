//
//  Parallelogram.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI
struct Parallelogram: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let slant: CGFloat = 20
        path.move(to: CGPoint(x: rect.minX + slant, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - slant, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
