//
//  Untitled.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI

struct FlowchartTool: View {
    let shape: FlowchartShape

    var body: some View {
        VStack {
            switch shape {
            case .rectangle:
                Rectangle().stroke(lineWidth: 2).frame(width: 40, height: 40)
            case .diamond:
                Diamond().stroke(lineWidth: 2).frame(width: 40, height: 40)
            case .oval:
                Ellipse().stroke(lineWidth: 2).frame(width: 40, height: 40)
            case .square:
                Rectangle().stroke( lineWidth: 2).frame(width: 40, height: 40)
            case .roundedRectangle:
                RoundedRectangle(cornerRadius: 10).stroke( lineWidth: 2).frame(width: 50, height: 30)
            case .parallelogram:
                Parallelogram().stroke( lineWidth: 2).frame(width: 50, height: 30)
            case .arrow:
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }

            Text(shape.rawValue)
                .font(.caption2)
                .foregroundColor(.white)
        }
    }
}
