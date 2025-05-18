////
////  Untitled 2.swift
////  zign
////
////  Created by Diala Abdulnasser Fayoumi on 20/11/1446 AH.
////
//
//// FlowchartCanvas.swift
//import SwiftUI
//
//struct FlowchartCanvas: View {
//    @Binding var elements: [FlowchartElement]
//    @Binding var selectedElement: FlowchartElement?
//    @Binding var previousElementID: UUID?
//    @Binding var isEditing: Bool
//    @Binding var showingCorrectConnections: Bool
//    let currentScenario: FlowchartScenario
//    @Binding var incorrectElementIDs: [UUID]
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            RoundedRectangle(cornerRadius: 52)
//                .foregroundColor(.clear)
//                .frame(width: 976, height: 645)
//
//            Image("image")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 976, height: 645)
//                .clipped()
//                .cornerRadius(52)
//
//            ForEach(elements, id: \.\id) { fromElement in
//                ForEach(fromElement.connections, id: \.\self) { toID in
//                    if let toElement = elements.first(where: { $0.id == toID }) {
//                        let isCorrect = currentScenario.connections.contains {
//                            $0.0 == fromElement.text && $0.1 == toElement.text
//                        }
//
//                        let from = adjustedPoint(from: fromElement.position, to: toElement.position)
//                        let to = adjustedPoint(from: toElement.position, to: fromElement.position)
//                        let midX = (from.x + to.x) / 2
//                        let midY = (from.y + to.y) / 2
//
//                        Arrow(from: from, to: to)
//                            .stroke(showingCorrectConnections ? (isCorrect ? Color.green : Color.red) : Color.black, lineWidth: 2)
//
//                        if isEditing {
//                            Button(action: {
//                                if let fromIndex = elements.firstIndex(where: { $0.id == fromElement.id }) {
//                                    elements[fromIndex].connections.removeAll { $0 == toElement.id }
//                                }
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                                    .foregroundColor(.white)
//                                    .background(Color.red)
//                                    .clipShape(Circle())
//                            }
//                            .position(x: midX, y: midY)
//                        }
//                    }
//                }
//            }
//
//            ForEach(elements) { element in
//                FlowchartNode(element: element, isSelected: selectedElement?.id == element.id)
//                    .position(element.position)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                if let index = elements.firstIndex(where: { $0.id == element.id }) {
//                                    elements[index].position = value.location
//                                }
//                            }
//                    )
//                    .onDrop(of: [.text], isTargeted: nil) { providers in
//                        if let provider = providers.first {
//                            _ = provider.loadObject(ofClass: NSString.self) { object, _ in
//                                if let string = object as? String,
//                                   let index = elements.firstIndex(where: { $0.id == element.id }) {
//                                    DispatchQueue.main.async {
//                                        let oldText = elements[index].text
//                                        if oldText != "Drop text here" && !elements.contains(where: { $0.text == oldText }) {
//                                            elements.append(FlowchartElement(text: oldText, shape: .rectangle, position: .zero))
//                                        }
//                                        elements[index].text = string
//                                    }
//                                }
//                            }
//                            return true
//                        }
//                        return false
//                    }
//                    .onTapGesture {
//                        if isEditing {
//                            if let index = elements.firstIndex(where: { $0.id == element.id }) {
//                                let removed = elements.remove(at: index)
//                            }
//                        } else {
//                            if let fromID = previousElementID,
//                               let fromIndex = elements.firstIndex(where: { $0.id == fromID }),
//                               fromID != element.id {
//                                if elements[fromIndex].shape == .diamond &&
//                                    elements[fromIndex].connections.count >= 2 {
//                                    previousElementID = nil
//                                    return
//                                }
//
//                                if !elements[fromIndex].connections.contains(element.id) {
//                                    elements[fromIndex].connections.append(element.id)
//                                }
//                                previousElementID = nil
//                            } else {
//                                previousElementID = element.id
//                            }
//                        }
//                    }
//            }
//        }
//        .frame(width: 976, height: 645)
//    }
//
//    func adjustedPoint(from: CGPoint, to: CGPoint) -> CGPoint {
//        let dx = to.x - from.x
//        let dy = to.y - from.y
//        let angle = atan2(dy, dx)
//        let offset: CGFloat = 60
//        return CGPoint(x: from.x + cos(angle) * offset, y: from.y + sin(angle) * offset)
//    }
//}
