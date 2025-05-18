//
//  FlowchartViewModel.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 16/11/1446 AH.
//

import SwiftUI
import UniformTypeIdentifiers
class FlowchartViewModel: ObservableObject {
    @Published var flowchartElements: [FlowchartElement] = []
    @Published var currentScenarioIndex: Int = 0
    @Published var textItems: [String] = []
    @Published var draggedText: String?
    @Published var selectedElement: FlowchartElement?
    @Published var previousElementID: UUID?
    @Published var resultMessage: String?
    @Published var showingCorrectConnections = false
    @Published var isEditing = false
    
    let accentYellow = Color("cardyellow")
    
    let scenarios: [FlowchartScenario] = [ /* Same scenarios from your original code */ ]
    
    var currentScenario: FlowchartScenario {
        scenarios[currentScenarioIndex]
    }
    
    func addNewElement(shape: FlowchartShape) {
        let yOffset = CGFloat(flowchartElements.count) * 70 + 100
        let newElement = FlowchartElement(text: "Drop text here", shape: shape, position: CGPoint(x: 300, y: yOffset))
        flowchartElements.append(newElement)
        
        if let prevID = previousElementID,
           let fromIndex = flowchartElements.firstIndex(where: { $0.id == prevID }) {
            if flowchartElements[fromIndex].shape == .diamond && flowchartElements[fromIndex].connections.count >= 2 {
                return
            }
            flowchartElements[fromIndex].connections.append(newElement.id)
        }
    }
    
    func adjustedPoint(from: CGPoint, to: CGPoint) -> CGPoint {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let angle = atan2(dy, dx)
        let offset: CGFloat = 60
        return CGPoint(x: from.x + cos(angle) * offset, y: from.y + sin(angle) * offset)
    }
    
    func loadCurrentScenario() {
        let scenario = scenarios[currentScenarioIndex]
        flowchartElements = []
        textItems = scenario.elements.map { $0.0 }
    }
    
    func addDecisionArrows(for decisionElement: FlowchartElement) {
        // Check if this decision already has two arrows (don't add duplicates)
        let existingConnections = decisionElement.connections.count
        guard existingConnections < 2 else { return }
        
        // Calculate positions for the arrow endpoints (right and below the decision)
        let rightPosition = CGPoint(x: decisionElement.position.x + 150, y: decisionElement.position.y)
        let bottomPosition = CGPoint(x: decisionElement.position.x, y: decisionElement.position.y + 150)
        
        // Create arrow endpoints (invisible anchor points)
        let yesAnchor = FlowchartElement(
            text: "Yes",
            shape: .arrow,
            position: rightPosition
        )
        
        let noAnchor = FlowchartElement(
            text: "No",
            shape: .arrow,
            position: bottomPosition
        )
        
        // Add the new anchor points
        flowchartElements.append(yesAnchor)
        flowchartElements.append(noAnchor)
        
        // Connect the decision to both arrows
        if let decisionIndex = flowchartElements.firstIndex(where: { $0.id == decisionElement.id }) {
            flowchartElements[decisionIndex].connections.append(yesAnchor.id)
            flowchartElements[decisionIndex].connections.append(noAnchor.id)
        }
    }
}
