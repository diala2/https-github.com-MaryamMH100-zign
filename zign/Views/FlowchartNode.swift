//
//  Untitled.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI

struct FlowchartNode: View {
    let element: FlowchartElement
    let isSelected: Bool

    var body: some View {
        ZStack {
            switch element.shape {
            case .rectangle:
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 200, height: 60)
                    .overlay(
                        Rectangle()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            case .diamond:
                Diamond()
                    .fill(Color.white)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Diamond()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                        
                    )

            case .oval:
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            case .square:
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Rectangle()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            case .roundedRectangle:
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width: 150, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            case .parallelogram:
                Parallelogram()
                    .fill(Color.white)
                    .frame(width: 180, height: 60)
                    .overlay(
                        Parallelogram()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            case .arrow:
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.red : Color.black, lineWidth: isSelected ? 3 : 1)
                    )

            }

            Text(element.text)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .medium))
                .padding(8)
        }
    }
}
