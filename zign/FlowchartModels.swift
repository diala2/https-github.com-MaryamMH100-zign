//
//  FlowchartModels.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//
import SwiftUI
struct FlowchartElement: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var shape: FlowchartShape
    var position: CGPoint
    var connections: [UUID] = []
}

enum FlowchartShape: String, CaseIterable {
    case square = "Square"
    case roundedRectangle = "Rounded"
    case parallelogram = "Data Input"
    case rectangle = "Process"
    case diamond = "Decision"
    case oval = "Start/End"
    case arrow = "Arrow"
}

// MARK: - Main View
struct FlowchartScenario {
    let title: String
    let prompt: String
    let elements: [(String, FlowchartShape)]
    let connections: [(String, String)]
}
