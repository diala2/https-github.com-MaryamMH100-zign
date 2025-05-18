//
//  ContentView.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 08/11/1446 AH.
//
import SwiftUI

struct ContentView: View {
    @State private var flowchartElements: [FlowchartElement] = []
    @State private var currentScenarioIndex: Int = 0
    @State private var textItems = ["At home", "Put on shoes", "Gather belongings",
                                     "Check for keys/wallet/phone", "Has everything?","Please check again" ,
                                    "Lock the door"
                                ,"Walk to car", "Unlock car",
                                     "Enter car", "In car"]
    @State private var draggedText: String?
    @State private var selectedElement: FlowchartElement?
    @State private var previousElementID: UUID?
    @State private var resultMessage: String?
    @State private var showingCorrectConnections = false
    @State private var isEditing = false
    @State private var incorrectElementIDs: [UUID] = []
    @State private var showingScore = false
    @State private var incorrectAnswersCount = 0


    
    private let scenarios: [FlowchartScenario] = [
        FlowchartScenario(
            title: "Level 1",
            prompt: "Create a flowchart showing the steps of a person leaving their house and getting into their car, from the start until they get in the car.",
            elements: [
              
                ("Start: At home", .oval),
                ("Put on shoes", .rectangle),
                ("Gather belongings", .rectangle),
                ("Check for keys/wallet/phone", .rectangle),
                ("Has everything?", .diamond),
                ("Lock the door", .rectangle),
                ("Walk to car", .rectangle),
                ("Unlock car", .rectangle),
                ("Enter car", .rectangle),
                ("End: In car", .oval),
                ("Please check again", .rectangle)  // New instruction if not everything is ready
            ],
            connections: [
                (" At home", "Put on shoes"),
                ("Put on shoes", "Gather belongings"),
                ("Gather belongings", "Check for keys/wallet/phone"),
                ("Check for keys/wallet/phone", "Has everything?"),
                ("Has everything?", "Lock the door"), // If everything is ready, continue
                ("Has everything?", "Please check again"), // If not everything is ready, instruct the user
                ("Please check again", "Gather belongings"), // User goes back to gather items after the instruction
                ("Lock the door", "Walk to car"),
                ("Walk to car", "Unlock car"),
                ("Unlock car", "Enter car"),
                ("Enter car", "In car")
            ]
        ),
        FlowchartScenario(
            title: "Level 2",
            prompt: "Help 'Sarah' create a new account in a home workout app. Arrange the UI flow so the user can register easily.",
            elements: [
                ("Open app", .oval),
                ("Tap sign up", .rectangle),
                ("Enter name", .rectangle),
                ("Enter email", .rectangle),
                ("Set password", .rectangle),
                ("Submit", .rectangle),
                ("Registration complete", .oval),
                ("Incomplete registration", .rectangle) // New path for incomplete registration
            ],
            connections: [
                ("Open app", "Tap sign up"),
                ("Tap sign up", "Enter name"),
                ("Enter name", "Enter email"),
                ("Enter email", "Set password"),
                ("Set password", "Submit"),
                ("Submit", "Registration complete"), // If all fields are correctly filled, complete registration
                ("Submit", "Incomplete registration"), // If something is missing, show incomplete registration message
                ("Incomplete registration", "Enter name"), // Go back to entering the required field (e.g., name)
                ("Registration complete", "End") // Successfully complete the registration and end the flow
            ]
        ),
        FlowchartScenario(
            title: "Level 3",
            prompt: "Create a flowchart that shows the steps of a person making a cup of coffee, starting from entering the kitchen until finishing. Include a decision step to check if there is hot water or not.",
            elements: [
                ("Enter kitchen", .oval),
                ("Boil water", .rectangle),
                ("Check if hot water?", .diamond),
                ("Use hot water", .rectangle),
                ("Boil water again", .rectangle),
                ("Add coffee", .rectangle),
                ("Stir & Drink", .oval)
            ],
            connections: [
                ("Enter kitchen", "Boil water"),
                ("Boil water", "Check if hot water?"),
                ("Check if hot water?", "Use hot water"), // Path 1: If hot water is available
                ("Check if hot water?", "Boil water again"), // Path 2: If no hot water
                ("Use hot water", "Add coffee"),
                ("Boil water again", "Add coffee"),
                ("Add coffee", "Stir & Drink")
            ]
        ),
        FlowchartScenario(
            title: "Level 4",
            prompt: "Create a flowchart starting with opening the flight booking app. Ask if the user wants a one-way or round-trip ticket. Based on the choice, show steps for selecting destination, dates, and availability. Include decisions for date selection and availability check.",
            elements: [
                ("Open flight app", .oval),
                ("Select trip type", .diamond),
                ("One-way selected", .rectangle),
                ("Round-trip selected", .rectangle),
                ("Choose destination", .rectangle),
                ("Select dates", .rectangle),
                ("Check availability", .diamond),
                ("Available", .rectangle),
                ("Not available", .rectangle),
                ("Choose new dates", .rectangle),
                ("Exit", .oval),
                ("Book flight", .oval)
            ],
            connections: [
                ("Open flight app", "Select trip type"),
                ("Select trip type", "One-way selected"), // If user selects one-way
                ("Select trip type", "Round-trip selected"), // If user selects round-trip
                ("One-way selected", "Choose destination"),
                ("Round-trip selected", "Choose destination"),
                ("Choose destination", "Select dates"),
                ("Select dates", "Check availability"),
                ("Check availability", "Available"), // If flight is available
                ("Check availability", "Not available"), // If flight is not available
                ("Not available", "Choose new dates"), // If flight is not available
                ("Choose new dates", "Select dates"), // Go back to selecting new dates if needed
                ("Available", "Book flight"), // If flight is available, proceed to booking
                ("Not available", "Exit"), // If the flight is not available and the user wants to exit
                ("Exit", "End") // End the process if the user exits
            ]
        ),
        FlowchartScenario(
            title: "Level 5",
            prompt: "Create a user flow for a food ordering app. Starting from opening the app, logging in or registering, selecting food, browsing the menu, adding items, choosing payment, delivery info, confirming, and receiving.",
            elements: [
                ("Open food app", .oval),
                ("Login/Register", .diamond),
                ("Login", .rectangle),
                ("Register", .rectangle),
                ("Select food type", .rectangle),
                ("Browse menu", .rectangle),
                ("Add to cart", .rectangle),
                ("Choose payment", .rectangle),
                ("Enter delivery details", .rectangle),
                ("Confirm order", .rectangle),
                ("Order received", .oval)
            ],
            connections: [
                ("Open food app", "Login/Register"),
                ("Login/Register", "Login"), // If user selects login
                ("Login/Register", "Register"), // If user selects register
                ("Login", "Select food type"),
                ("Register", "Select food type"),
                ("Select food type", "Browse menu"),
                ("Browse menu", "Add to cart"),
                ("Add to cart", "Choose payment"),
                ("Choose payment", "Enter delivery details"),
                ("Enter delivery details", "Confirm order"),
                ("Confirm order", "Order received")
            ]
        )
    ]

    let accentYellow = Color.primaryYellow
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            VStack(spacing: 20) {
                let scenario = scenarios[currentScenarioIndex]
                Text(scenario.title)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                Text(scenario.prompt)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).stroke(accentYellow, lineWidth: 3))
                    .padding(.horizontal)
                ZStack(alignment: .topLeading) {
                    // Canvas background
                    RoundedRectangle(cornerRadius: 52)
                        .foregroundColor(.clear)
                        .frame(width: 976, height: 645)
                    Image("image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 976, height: 645)
                        .clipped()
                        .cornerRadius(52)
                    
                    // Arrows
                    ForEach(flowchartElements, id: \.id) { fromElement in
                        ForEach(fromElement.connections, id: \.self) { toID in
                            if let toElement = flowchartElements.first(where: { $0.id == toID }) {
                                let isCorrect = scenarios[currentScenarioIndex].connections.contains {
                                    $0.0 == fromElement.text && $0.1 == toElement.text
                                }
                                
                                let from = adjustedPoint(from: fromElement.position, to: toElement.position)
                                let to = adjustedPoint(from: toElement.position, to: fromElement.position)
                                let midX = (from.x + to.x) / 2
                                let midY = (from.y + to.y) / 2
                                
                                Arrow(from: from, to: to)
                                    .stroke(showingCorrectConnections ? (isCorrect ? Color.green : Color.red) : Color.black, lineWidth: 2)
                                
                                if isEditing {
                                    Button(action: {
                                        if let fromIndex = flowchartElements.firstIndex(where: { $0.id == fromElement.id }) {
                                            flowchartElements[fromIndex].connections.removeAll { $0 == toElement.id }
                                            isEditing.toggle()
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                    .position(x: midX, y: midY)
                                }
                            }
                        }
                    }
                    
                    // Flowchart Nodes
                    ForEach(flowchartElements) { element in
                        FlowchartNode(element: element, isSelected: selectedElement?.id == element.id)
                            .position(element.position)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
                                            flowchartElements[index].position = value.location
                                        }
                                    }
                            )
                            .onDrop(of: [.text], isTargeted: nil) { providers in
                                if let provider = providers.first {
                                    _ = provider.loadObject(ofClass: NSString.self) { object, _ in
                                        if let string = object as? String,
                                           let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
                                            DispatchQueue.main.async {
                                                let oldText = flowchartElements[index].text
                                                if oldText != "Drop text here" && !textItems.contains(oldText) {
                                                    textItems.append(oldText)
                                                }
                                                
                                                flowchartElements[index].text = string
                                                if let removeIndex = textItems.firstIndex(of: string) {
                                                    textItems.remove(at: removeIndex)
                                                }
                                            }
                                        }
                                    }
                                    return true
                                }
                                return false
                            }
                            .onTapGesture {
                                if isEditing {
                                    if let index = flowchartElements.firstIndex(where: { $0.id == element.id }) {
                                        let removed = flowchartElements.remove(at: index)
                                        if removed.text != "Drop text here" {
                                            textItems.append(removed.text)
                                        }
                                    }
                                } else {
                                    if let fromID = previousElementID,
                                       let fromIndex = flowchartElements.firstIndex(where: { $0.id == fromID }),
                                       fromID != element.id {
                                        if flowchartElements[fromIndex].shape == .diamond &&
                                            flowchartElements[fromIndex].connections.count >= 2 {
                                            previousElementID = nil
                                            return
                                        }
                                        
                                        if !flowchartElements[fromIndex].connections.contains(element.id) {
                                            flowchartElements[fromIndex].connections.append(element.id)
                                        }
                                        previousElementID = nil
                                    } else {
                                        previousElementID = element.id
                                    }
                                }
                            }
                    }
                }
                .frame(width: 976, height: 645)
                
                ZStack {
                    HStack(spacing: 20) {
                        ForEach(FlowchartShape.allCases, id: \.self) { shape in
                            FlowchartTool(shape: shape)
                                .padding(8)
                                .cornerRadius(12)
                            
                                .onTapGesture {
                                    addNewElement(shape: shape)
                                }
                        }
                        Button(action: {
                                          isEditing.toggle()
                                      }) {
                                          Text(isEditing ? "Done Editing" : "Edit Mode")
                                              .font(.subheadline.bold())
                                              .padding(10)
                                              .background(Color.red.opacity(0.85))
                                              .foregroundColor(.white)
                                              .cornerRadius(12)
                                      }
                                      .padding(.bottom, 8)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 3)
                    .padding(-150)// Optional: space between canvas and toolbar
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(textItems, id: \.self) { text in
                            Text(text)
                                .font(.headline) // Adjust font style
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.gray.opacity(0.2)) // Match design
                                .cornerRadius(52)
                                .onTapGesture {
                                    if !textItems.contains(text) {
                                        textItems.append(text)
                                    }
                                }
                                .onDrag {
                                    draggedText = text
                                    return NSItemProvider(object: text as NSString)
                                }
                        }
                    }
                    .padding()
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.2)) // Background for the selector
                    .cornerRadius(16)
                }
                
                if let message = resultMessage {
                    Text(message)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                }
//                Button(action: {
//                    isEditing.toggle()
//                }) {
//                    Text(isEditing ? "Done Editing" : "Edit Mode")
//                        .font(.subheadline.bold())
//                        .padding(10)
//                        .background(Color.red.opacity(0.85))
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .padding(.bottom, 8)
                Button(action: {
                    showingCorrectConnections = true
                    let currentScenario = scenarios[currentScenarioIndex]
                    
                    incorrectElementIDs = []
                    
                    // Check element shapes
                    for (expectedText, expectedShape) in currentScenario.elements {
                        if let element = flowchartElements.first(where: { $0.text == expectedText }) {
                            if element.shape != expectedShape {
                                incorrectElementIDs.append(element.id)
                            }
                        }
                    }
                    
                    // Check connections
                    for (fromText, toText) in currentScenario.connections {
                        guard let fromElement = flowchartElements.first(where: { $0.text == fromText }),
                              let toElement = flowchartElements.first(where: { $0.text == toText }) else {
                            continue
                        }
                        if !fromElement.connections.contains(toElement.id) {
                            incorrectElementIDs.append(fromElement.id)
                        }
                    }
                    
                    // Count incorrects and show score
                    incorrectAnswersCount = incorrectElementIDs.count
                    showingScore = true
                    
                }) {
                    Text("Check")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(accentYellow)
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
            }
            
            .frame(maxHeight: .infinity)
            .background(Color(red: 0.08, green: 0.08, blue: 0.08))
            .edgesIgnoringSafeArea(.all)

        }
        
    }


    func adjustedPoint(from: CGPoint, to: CGPoint) -> CGPoint {
       let dx = to.x - from.x
       let dy = to.y - from.y
       let angle = atan2(dy, dx)
       let offset: CGFloat = 60
       return CGPoint(x: from.x + cos(angle) * offset, y: from.y + sin(angle) * offset)
   }


       func addNewElement(shape: FlowchartShape) {
           let whiteboardWidth: CGFloat = 976
           let whiteboardHeight: CGFloat = 645
           let xPadding: CGFloat = 100
           let yPadding: CGFloat = 80

           let column = flowchartElements.count % 3
           let row = flowchartElements.count / 3

           let spacingX: CGFloat = 180
           let spacingY: CGFloat = 100

           let x = CGFloat(column) * spacingX + xPadding
           let y = whiteboardHeight - yPadding - CGFloat(row) * spacingY

           let newElement = FlowchartElement(
               text: "Drop text here",
               shape: shape,
               position: CGPoint(x: x, y: y)
           )

           flowchartElements.append(newElement)

           if let prevID = previousElementID,
              let fromIndex = flowchartElements.firstIndex(where: { $0.id == prevID }) {
               if flowchartElements[fromIndex].shape == .diamond &&
                   flowchartElements[fromIndex].connections.count >= 2 {
                   return
               }

               if !flowchartElements[fromIndex].connections.contains(newElement.id) {
                   flowchartElements[fromIndex].connections.append(newElement.id)
               }
           }
       }


 func loadCurrentScenario() {
    let scenario = scenarios[currentScenarioIndex]
    flowchartElements = []
    textItems.removeAll()
    for text in scenario.elements.map({ $0.0 }) {
        if !flowchartElements.contains(where: { $0.text == text }) {
            textItems.append(text)
        }
    }
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

#Preview {
    ContentView()
}
