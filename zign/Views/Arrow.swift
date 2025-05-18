//
//  Arrow.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI
struct Arrow: Shape {
    var from: CGPoint
    var to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)

        let arrowSize: CGFloat = 10.0
        let angle = atan2(to.y - from.y, to.x - from.x)

        let arrowPoint1 = CGPoint(
            x: to.x - arrowSize * cos(angle - .pi / 6),
            y: to.y - arrowSize * sin(angle - .pi / 6)
        )

        let arrowPoint2 = CGPoint(
            x: to.x - arrowSize * cos(angle + .pi / 6),
            y: to.y - arrowSize * sin(angle + .pi / 6)
        )

        path.move(to: to)
        path.addLine(to: arrowPoint1)
        path.move(to: to)
        path.addLine(to: arrowPoint2)

        return path
    }
}
