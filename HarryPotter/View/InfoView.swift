//
//  InfoView.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-29.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                InfoBackground()
                VStack{
                    Image(.hat)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top,20)
                    ScrollView{
                        VStack{
                            Text("Welcome to Harry Potter Quiz")
                                .padding(.vertical,20)
                                .font(.title2)
                                .fontWeight(.semibold)

                            VStack(alignment:.leading) {
                                Text("Here you will be asked random questions from the books and you must guess the right answers or you loose points!!")
                                    .padding([.horizontal,.bottom],20)
                                
                                Text("Each question is worth 5 points, but if you guess wrong answer, you loose 1 point")
                                    .padding([.horizontal,.bottom],20)
                                
                                Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware using these also costs 1 point each")
                                    .padding([.horizontal,.bottom],20)
                                
                                Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score")
                                    .padding([.horizontal,.bottom],20)
                                
                            }
                            Text("Good Luck!!")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .shadow(radius: 15)

                    }
                    .padding(.horizontal)
                    .frame(height: geo.size.height/1.6)
                    .foregroundStyle(.thickMaterial)
                    
                    Button("Go Back"){
                        dismiss()
                    }
                    .goBackButton()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InfoView()
}
