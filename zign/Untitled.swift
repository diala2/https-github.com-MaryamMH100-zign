//import SwiftUI
//import UniformTypeIdentifiers
//
//// MARK: - Data Models
//struct FlowchartElement: Identifiable, Equatable {
//let id = UUID()
//var text: String
//var shape: FlowchartShape
//var position: CGPoint
//var connections: \[UUID] = \[]
//}
//
//enum FlowchartShape: String, CaseIterable {
//case square = "Square"
//case roundedRectangle = "Rounded"
//case parallelogram = "Data Input"
//case rectangle = "Process"
//case diamond = "Decision"
//case oval = "Start/End"
//case arrow = "Arrow"
//}
//
//// MARK: - Main View
//struct FlowchartScenario {
//let title: String
//let prompt: String
//let elements: \[(String, FlowchartShape)]
//let connections: \[(String, String)]
//}
//
//struct ContentView: View {
//@State private var flowchartElements: \[FlowchartElement] = \[]
//@State private var currentScenarioIndex: Int = 0
//@State private var textItems = \["Start: At home", "Put on shoes", "Gather belongings",
//"Check for keys/wallet/phone", "Has everything?",
//"Lock the door", "Walk to car", "Unlock car",
//"Enter car", "End: In car"]
//@State private var draggedText: String?
//@State private var selectedElement: FlowchartElement?
//@State private var previousElementID: UUID?
//@State private var resultMessage: String?
//@State private var showingCorrectConnections = false
//@State private var isEditing = false
//
//```
//private let scenarios: [FlowchartScenario] = [
//    FlowchartScenario(
//        title: "Level 1",
//        prompt: "Create a flowchart showing the steps of a person leaving their house and getting into their car, from the start until they get in the car.",
//        elements: [
//            ("Start: At home", .oval),
//            ("Put on shoes", .rectangle),
//            ("Gather belongings", .rectangle),
//            ("Check for keys/wallet/phone", .rectangle),
//            ("Has everything?", .diamond),
//            ("Lock the door", .rectangle),
//            ("Walk to car", .rectangle),
//            ("Unlock car", .rectangle),
//            ("Enter car", .rectangle),
//            ("End: In car", .oval)
//        ],
//        connections: [
//            ("Start: At home", "Put on shoes"),
//            ("Put on shoes", "Gather belongings"),
//            ("Gather belongings", "Check for keys/wallet/phone"),
//            ("Check for keys/wallet/phone", "Has everything?"),
//            ("Has everything?", "Lock the door"),
//            ("Lock the door", "Walk to car"),
//            ("Walk to car", "Unlock car"),
//            ("Unlock car", "Enter car"),
//            ("Enter car", "End: In car")
//        ]
//    ),
//    FlowchartScenario(
//        title: "Help Sarah Register",
//        prompt: "Help 'Sarah' create a new account in a home workout app. Arrange the UI flow so the user can register easily.",
//        elements: [
//            ("Open app", .oval),
//            ("Tap sign up", .rectangle),
//            ("Enter name", .rectangle),
//            ("Enter email", .rectangle),
//            ("Set password", .rectangle),
//            ("Submit", .rectangle),
//            ("Registration complete", .oval)
//        ],
//        connections: [
//            ("Open app", "Tap sign up"),
//            ("Tap sign up", "Enter name"),
//            ("Enter name", "Enter email"),
//            ("Enter email", "Set password"),
//            ("Set password", "Submit"),
//            ("Submit", "Registration complete")
//        ]
//    ),
//    FlowchartScenario(
//        title: "Make Coffee",
//        prompt: "Create a flowchart that shows the steps of a person making a cup of coffee, starting from entering the kitchen until finishing. Include a decision step to check if there is hot water or not.",
//        elements: [
//            ("Enter kitchen", .oval),
//            ("Boil water", .rectangle),
//            ("Check if hot water?", .diamond),
//            ("Use hot water", .rectangle),
//            ("Boil water again", .rectangle),
//            ("Add coffee", .rectangle),
//            ("Stir & Drink", .oval)
//        ],
//        connections: [
//            ("Enter kitchen", "Boil water"),
//            ("Boil water", "Check if hot water?"),
//            ("Check if hot water?", "Use hot water"),
//            ("Check if hot water?", "Boil water again"),
//            ("Use hot water", "Add coffee"),
//            ("Boil water again", "Add coffee"),
//            ("Add coffee", "Stir & Drink")
//        ]
//    ),
//    FlowchartScenario(
//        title: "Flight Booking",
//        prompt: "Create a flowchart starting with opening the flight booking app. Ask if the user wants a one-way or round-trip ticket. Based on the choice, show steps for selecting destination, dates, and availability. Include decisions for date selection and availability check.",
//        elements: [
//            ("Open flight app", .oval),
//            ("Select trip type", .diamond),
//            ("One-way selected", .rectangle),
//            ("Round-trip selected", .rectangle),
//            ("Choose destination", .rectangle),
//            ("Select dates", .rectangle),
//            ("Check availability", .diamond),
//            ("Available", .rectangle),
//            ("Not available", .rectangle),
//            ("Book flight", .oval)
//        ],
//        connections: [
//            ("Open flight app", "Select trip type"),
//            ("Select trip type", "One-way selected"),
//            ("Select trip type", "Round-trip selected"),
//            ("One-way selected", "Choose destination"),
//            ("Round-trip selected", "Choose destination"),
//            ("Choose destination", "Select dates"),
//            ("Select dates", "Check availability"),
//            ("Check availability", "Available"),
//            ("Check availability", "Not available"),
//            ("Available", "Book flight")
//        ]
//    ),
//    FlowchartScenario(
//        title: "Food Order",
//        prompt: "Create a user flow for a food ordering app. Starting from opening the app, logging in or registering, selecting food, browsing the menu, adding items, choosing payment, delivery info, confirming, and receiving.",
//        elements: [
//            ("Open food app", .oval),
//            ("Login/Register", .diamond),
//            ("Login", .rectangle),
//            ("Register", .rectangle),
//            ("Select food type", .rectangle),
//            ("Browse menu", .rectangle),
//            ("Add to cart", .rectangle),
//            ("Choose payment", .rectangle),
//            ("Enter delivery details", .rectangle),
//            ("Confirm order", .rectangle),
//            ("Order received", .oval)
//        ],
//        connections: [
//            ("Open food app", "Login/Register"),
//            ("Login/Register", "Login"),
//            ("Login/Register", "Register"),
//            ("Login", "Select food type"),
//            ("Register", "Select food type"),
//            ("Select food type", "Browse menu"),
//            ("Browse menu", "Add to cart"),
//            ("Add to cart", "Choose payment"),
//            ("Choose payment", "Enter delivery details"),
//            ("Enter delivery details", "Confirm order"),
//            ("Confirm order", "Order received")
//        ]
//    )
//]
//let accentYellow = Color(red: 0.99, green: 0.75, blue: 0.31)
//
//var body: some View {
//    GeometryReader { geometry in
//        let screenHeight = geometry.size.height
//        
//        VStack(spacing: 20) {
//            let scenario = scenarios[currentScenarioIndex]
//            Text(scenario.title)
//                .font(.system(size: 36, weight: .bold))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(accentYellow)
//                .cornerRadius(20)
//                .padding(.horizontal)
//            
//            Text(scenario.prompt)
//                .font(.title2.bold())
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 20).stroke(accentYellow, lineWidth: 3))
//                .padding(.horizontal)
//            
//            ZStack {
//                // Background
//                RoundedRectangle(cornerRadius: 40)
//                    .fill(Color.white)
//                    .overlay(GridPattern())
//                    .frame(height: screenHeight * 0.45)
//                
//                // Arrows
//                ForEach(flowchartElements, id: \.id) { fromElement in
//                    ForEach(fromElement.connections, id: \.self) { toID in
//                        if let toElement = flowchartElements.first(where: { $0.id == toID }) {
//                            let scenario = scenarios[currentScenarioIndex]
//                            let isCorrect = scenario.connections.contains { connection in
//                                connection.0 == fromElement.text && connection.1 == toElement.text
//                            }
//
//                            let from = adjustedPoint(from: fromElement.position, to: toElement.position)
//                            let to = adjustedPoint(from: toElement.position, to: fromElement.position)
//                            let midX = (from.x + to.x) / 2
//                            let midY = (from.y + to.y) / 2
//
//                            ZStack {
//                                Arrow(from: from, to: to)
//                                    .stroke(showingCorrectConnections ? (isCorrect ? Color.green : Color.red) : Color.black, lineWidth: 2)
//
//                                if isEditing {
//                                    Button(action: {
//                                        if let fromIndex = flowchartElements.firstIndex(where: { $0.id == fromElement.id }) {
//                                            flowchartElements[fromIndex].connections.removeAll { $0 == toElement.id }
//                                        }
//                                    }) {
//                                        Image(systemName: "xmark.circle.fill")
//                                            .foregroundColor(.white)
//                                            .background(Color.red)
//                                            .clipShape(Circle())
//                                    }
//                                    .frame(width: 24, height: 24)
//                                    .position(x: midX, y: midY)
//                                }
//                            }
//
//                        }
//                    }
//                }
//
//                
//                // Shapes
//                ForEach(flowchartElements) { element in
//                    FlowchartNode(element: element, isSelected: selectedElement?.id == element.id)
//                        .onTapGesture {
//                            if let fromID = previousElementID,
//                               let fromIndex = flowchartElements.firstIndex(where: { $0.id == fromID }),
//                               fromID != element.id {
//
//                                var from = flowchartElements[fromIndex]
//
//                                if from.shape == .diamond && from.connections.count >= 2 &&
//                                    !from.connections.contains(element.id) {
//                                    previousElementID = nil
//                                    return
//                                }
//
//                                if from.connections.contains(element.id) {
//                                    flowchartElements[fromIndex].connections.removeAll { $0 == element.id }
//                                } else {
//                                    flowchartElements[fromIndex].connections.append(element.id)
//                                }
//
//                                previousElementID = nil
//                            } else {
//                                previousElementID = element.id
//                            }
//                        }
//
//
//                        .onDrop(of: [.text], isTargeted: nil) { providers in
//                            if let provider = providers.first {
//                                _ = provider.loadObject(ofClass: NSString.self) { object, _ in
//                                    if let string = object as? String,
//                                       let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
//                                        DispatchQueue.main.async {
//                                            let oldText = flowchartElements[index].text
//                                            if oldText != "Drop text here" && !textItems.contains(oldText) {
//                                                textItems.append(oldText)
//                                            }
//
//                                            flowchartElements[index].text = string
//                                            if let removeIndex = textItems.firstIndex(of: string) {
//                                                textItems.remove(at: removeIndex)
//                                            }
//
//                                            // ❌ Do not update previousElementID here
//                                        }
//                                    }
//                                }
//                                return true
//                            }
//                            return false
//                        }
//
//                        .position(element.position)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    if let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
//                                        flowchartElements[index].position = value.location
//                                    }
//                                }
//                        )
//                        .onTapGesture {
//                            if let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
//                                let removed = flowchartElements.remove(at: index)
//                                if removed.text != "Drop text here" {
//                                    textItems.append(removed.text)
//                                }
//                            }
//                        }
//                }
//            }
//            .padding(.horizontal)
//            
//            HStack(spacing: 20) {
//                ForEach(FlowchartShape.allCases, id: \.self) { shape in
//                    FlowchartTool(shape: shape)
//                        .padding(8)
//                        .background(Color.black)
//                        .cornerRadius(12)
//                        .shadow(radius: 2)
//                        .onTapGesture {
//                            addNewElement(shape: shape)
//                        }
//                }
//            }
//            .background(Color.white.opacity(0.05))
//            .cornerRadius(20)
//            .padding(.vertical)
//            
//            ScrollView(.horizontal) {
//                HStack(spacing: 15) {
//                    ForEach(textItems, id: \.self) { text in
//                        Text(text)
//                            .foregroundColor(.black)
//                            .padding(10)
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .onTapGesture {
//                                if !textItems.contains(text) {
//                                    textItems.append(text)
//                                }
//                            }
//                            .onDrag {
//                                draggedText = text
//                                return NSItemProvider(object: text as NSString)
//                            }
//                    }
//                }
//                .padding()
//            }
//            
//            if let message = resultMessage {
//                Text(message)
//                    .foregroundColor(.white)
//                    .padding(.bottom, 10)
//            }
//            Button(action: {
//                isEditing.toggle()
//            }) {
//                Text(isEditing ? "Done Editing" : "Edit Mode")
//                    .font(.subheadline.bold())
//                    .padding(10)
//                    .background(Color.red.opacity(0.85))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 8)
//            Button(action: {
//                showingCorrectConnections = true
//                let currentScenario = scenarios[currentScenarioIndex]
//                let elementsCorrect = currentScenario.elements.allSatisfy { item in
//                    flowchartElements.contains(where: { $0.text == item.0 && $0.shape == item.1 })
//                }
//                
//                var connectionsCorrect = true
//                for (fromText, toText) in currentScenario.connections {
//                    guard let fromElement = flowchartElements.first(where: { $0.text == fromText }),
//                          let toElement = flowchartElements.first(where: { $0.text == toText }) else {
//                        connectionsCorrect = false
//                        break
//                    }
//                    
//                    if fromElement.shape == .diamond {
//                        let expectedTargets = currentScenario.connections.filter { $0.0 == fromText }.compactMap { pair in
//                            flowchartElements.first(where: { $0.text == pair.1 })?.id
//                        }
//                        if !expectedTargets.allSatisfy({ fromElement.connections.contains($0) }) {
//                            connectionsCorrect = false
//                            break
//                        }
//                    } else {
//                        if !fromElement.connections.contains(toElement.id) {
//                            connectionsCorrect = false
//                            break
//                        }
//                    }
//                }
//                
//                if elementsCorrect && connectionsCorrect {
//                    resultMessage = "✅ Correct!"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        resultMessage = nil
//                        currentScenarioIndex = min(currentScenarioIndex + 1, scenarios.count - 1)
//                        loadCurrentScenario()
//                    }
//                } else {
//                    resultMessage = "❌ Incorrect. Check both elements and connections."
//                }
//                "✅ Correct flowchart!"; "❌ Incorrect. Check both elements and connections."
//            }) {
//                Text("Check")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(accentYellow)
//                    .cornerRadius(40)
//                    .padding(.horizontal)
//            }
//        }
//        .background(Color(red: 0.08, green: 0.08, blue: 0.08))
//        .ignoresSafeArea()
//    }
//}
//private func addNewElement(shape: FlowchartShape) {
//    let yOffset = CGFloat(flowchartElements.count) * 70 + 100
//    let newElement = FlowchartElement(
//        text: "Drop text here",
//        shape: shape,
//        position: CGPoint(x: 300, y: yOffset)
//    )
//    
//    flowchartElements.append(newElement)
//
//    // Connect from previous if allowed
//    if let prevID = previousElementID,
//       let fromIndex = flowchartElements.firstIndex(where: { $0.id == prevID }) {
//
//        var from = flowchartElements[fromIndex]
//
//        if from.shape == .diamond && from.connections.count >= 2 {
//            return
//        }
//
//        if !from.connections.contains(newElement.id) {
//            flowchartElements[fromIndex].connections.append(newElement.id)
//        }
//    }
//}
//
//
//
//private func adjustedPoint(from: CGPoint, to: CGPoint) -> CGPoint {
//    let dx = to.x - from.x
//    let dy = to.y - from.y
//    let angle = atan2(dy, dx)
//    let offset: CGFloat = 60
//    return CGPoint(x: from.x + cos(angle) * offset, y: from.y + sin(angle) * offset)
//}
//
//
//
//private func loadCurrentScenario() {
//    let scenario = scenarios[currentScenarioIndex]
//    flowchartElements = []
//    textItems.removeAll()
//    for text in scenario.elements.map({ $0.0 }) {
//        if !flowchartElements.contains(where: { $0.text == text }) {
//            textItems.append(text)
//        }
//    }
//}
//private func addDecisionArrows(for decisionElement: FlowchartElement) {
//    // Check if this decision already has two arrows (don't add duplicates)
//    let existingConnections = decisionElement.connections.count
//    guard existingConnections < 2 else { return }
//    
//    // Calculate positions for the arrow endpoints (right and below the decision)
//    let rightPosition = CGPoint(x: decisionElement.position.x + 150, y: decisionElement.position.y)
//    let bottomPosition = CGPoint(x: decisionElement.position.x, y: decisionElement.position.y + 150)
//    
//    // Create arrow endpoints (invisible anchor points)
//    let yesAnchor = FlowchartElement(
//        text: "Yes",
//        shape: .arrow,
//        position: rightPosition
//    )
//    
//    let noAnchor = FlowchartElement(
//        text: "No",
//        shape: .arrow,
//        position: bottomPosition
//    )
//    
//    // Add the new anchor points
//    flowchartElements.append(yesAnchor)
//    flowchartElements.append(noAnchor)
//    
//    // Connect the decision to both arrows
//    if let decisionIndex = flowchartElements.firstIndex(where: { $0.id == decisionElement.id }) {
//        flowchartElements[decisionIndex].connections.append(yesAnchor.id)
//        flowchartElements[decisionIndex].connections.append(noAnchor.id)
//    }
//}
//
//
//}
//
//// MARK: - Flowchart Node View
//struct FlowchartNode: View {
//let element: FlowchartElement
//let isSelected: Bool
//
//```
//var body: some View {
//    Group {
//        switch element.shape {
//        case .rectangle:
//            Rectangle().fill(Color.blue.opacity(0.2)).frame(width: 200, height: 60)
//        case .diamond:
//            Diamond().fill(Color.green.opacity(0.2)).frame(width: 120, height: 120)
//        case .oval:
//            Ellipse().fill(Color.orange.opacity(0.2)).frame(width: 180, height: 60)
//        case .square:
//            Rectangle().fill(Color.purple.opacity(0.2)).frame(width: 80, height: 80)
//        case .roundedRectangle:
//            RoundedRectangle(cornerRadius: 15).fill(Color.cyan.opacity(0.2)).frame(width: 150, height: 70)
//        case .parallelogram:
//            Parallelogram().fill(Color.mint.opacity(0.2)).frame(width: 180, height: 60)
//        case .arrow:
//            ArrowSymbol().stroke(Color.black, lineWidth: 2).frame(width: 50, height: 30)
//        }
//    }
//    .overlay(
//        Text(element.text)
//            .foregroundColor(.black)
//            .padding(8)
//            .multilineTextAlignment(.center)
//    )
//    .overlay(
//        RoundedRectangle(cornerRadius: 4)
//            .stroke(isSelected ? Color.red : Color.gray, lineWidth: isSelected ? 3 : 1)
//    )
//}
//```
//
//}
//
//// MARK: - Shape Selector
//struct FlowchartTool: View {
//let shape: FlowchartShape
//
//```
//var body: some View {
//    VStack {
//        switch shape {
//        case .rectangle:
//            Rectangle().fill(Color.blue).frame(width: 40, height: 40)
//        case .diamond:
//            Diamond().fill(Color.green).frame(width: 40, height: 40)
//        case .oval:
//            Ellipse().fill(Color.orange).frame(width: 40, height: 40)
//        case .square:
//            Rectangle().stroke(Color.purple, lineWidth: 2).frame(width: 40, height: 40)
//        case .roundedRectangle:
//            RoundedRectangle(cornerRadius: 10).stroke(Color.cyan, lineWidth: 2).frame(width: 50, height: 30)
//        case .parallelogram:
//            Parallelogram().stroke(Color.mint, lineWidth: 2).frame(width: 50, height: 30)
//        case .arrow:
//            ArrowSymbol().stroke(Color.black, lineWidth: 2).frame(width: 50, height: 30)
//        }
//
//        Text(shape.rawValue)
//            .font(.caption2)
//            .foregroundColor(.white)
//    }
//}
//```
//
//}
//
//// MARK: - Arrow Symbol
//struct ArrowSymbol: Shape {
//func path(in rect: CGRect) -> Path {
//var path = Path()
//path.move(to: CGPoint(x: rect.minX, y: rect.midY))
//path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.midY))
//path.move(to: CGPoint(x: rect.maxX - 10, y: rect.midY - 10))
//path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.midY + 10))
//return path
//}
//}
//
//// MARK: - Parallelogram Shape
//struct Parallelogram: Shape {
//func path(in rect: CGRect) -> Path {
//var path = Path()
//let offset: CGFloat = rect.width \* 0.2
//path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY))
//path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.maxY))
//path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//path.closeSubpath()
//return path
//}
//}
//
//// MARK: - Diamond Shape
//struct Diamond: Shape {
//func path(in rect: CGRect) -> Path {
//var path = Path()
//path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
//path.closeSubpath()
//return path
//}
//}
//
//// MARK: - Arrow Shape
//struct Arrow: Shape {
//var from: CGPoint
//var to: CGPoint
//
//```
//func path(in rect: CGRect) -> Path {
//    var path = Path()
//    path.move(to: from)
//    path.addLine(to: to)
//
//    let angle = atan2(to.y - from.y, to.x - from.x)
//    let arrowLength: CGFloat = 10
//    let arrowAngle = CGFloat.pi / 6
//
//    let point1 = CGPoint(
//        x: to.x - arrowLength * cos(angle + arrowAngle),
//        y: to.y - arrowLength * sin(angle + arrowAngle)
//    )
//    let point2 = CGPoint(
//        x: to.x - arrowLength * cos(angle - arrowAngle),
//        y: to.y - arrowLength * sin(angle - arrowAngle)
//    )
//
//    path.move(to: to)
//    path.addLine(to: point1)
//    path.move(to: to)
//    path.addLine(to: point2)
//
//    return path
//}
//```
//
//}
//
//// MARK: - Background Grid
//struct GridPattern: View {
//var body: some View {
//GeometryReader { geo in
//let spacing: CGFloat = 20
//Path { path in
//for x in stride(from: 0, to: geo.size.width, by: spacing) {
//for y in stride(from: 0, to: geo.size.height, by: spacing) {
//path.addEllipse(in: CGRect(x: x, y: y, width: 2, height: 2))
//}
//}
//}
//.fill(Color.white.opacity(0.1))
//}
//}
//}
//
//// MARK: - App Entry
//@main
//struct FlowchartApp: App {
//var body: some Scene {
//WindowGroup {
//ContentView()
//}
//}
//}

