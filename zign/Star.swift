//
//  Star.swift
//  zign
//
//  Created by Diala Abdulnasser Fayoumi on 20/11/1446 AH.
//

//
//  StarView.swift
//  zign
//
//  Created by Mariya Niazi on 20/11/1446 AH.
//

import SwiftUI

struct StarView: View {
    let incorrectAnswersCount: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            Text("Level 1")
                .font(.custom("Inter-Bold", size: 40))
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(.textSubtle)
                .offset(y: -600)
              
            Text("Your Score")
                .font(.system(size: 40))
                .bold()
                .foregroundColor(.textPrimary)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primaryYellow, lineWidth: 3)
                        .frame(width: 970, height: 180)
                )
                .offset(y: -450)
              
            Image("EllipsePink")
                .resizable()
                .scaledToFit()
                .frame(width: 2000, height: 2000)
                .position(x: UIScreen.main.bounds.width - 80,
                          y: UIScreen.main.bounds.height - 80)

            Image("Vector")
                .resizable()
                .scaledToFit()
                .frame(width: 800)
                .offset(x: 0, y: -150)

            ZStack {
                RoundedRectangle(cornerRadius: 52)
                    .fill(Color(red: 217/255, green: 217/255, blue: 217/255).opacity(0.12))
                    .frame(width: 877, height: 814)

                VStack(spacing: 30) {
                    HStack(spacing: -30) {
                        let filledStars = max(3 - incorrectAnswersCount, 0)
                        let emptyStars = min(incorrectAnswersCount, 3)

                        ForEach(0..<3, id: \.self) { index in
                            let isFilled = index < filledStars
                            let yOffset: CGFloat = (index == 1) ? -90 : 10  // Middle star up, others down

                            Image(systemName: isFilled ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .foregroundColor(.primaryYellow)
                                .offset(y: yOffset)
                        }
                    }
                    .offset(y: 80)

                    // Correct score message out of 6
                    Text("You got \(6 - incorrectAnswersCount) out of 6 correct!\nGet ready for the next exciting challenge ahead!")
                        .foregroundColor(.textPrimary)
                        .font(.custom("Inter", size: 40).weight(.bold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 700)
                        .offset(y: 90)

                    HStack(spacing: 20) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back")
                                .foregroundColor(.textPrimary)
                                .frame(width: 372, height: 74)
                                .font(.system(size: 32).bold())
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.primaryYellow, lineWidth: 3)
                                )
                                .cornerRadius(50)
                        }

                        Button(action: {
                            // Add your "Next" action here
                        }) {
                            Text("Next")
                                .foregroundColor(.black)
                                .frame(width: 372, height: 74)
                                .background(Color.primaryYellow)
                                .cornerRadius(50)
                                                                .font(.system(size: 32).bold())
                                                        }
                                                    }
                                                    .offset(y: 105)
                                                }
                                            }
                                            .offset(y: 100)
                                        }
                                    }
                                }

                                #Preview {
                                    StarView(incorrectAnswersCount: 2)
                                }
