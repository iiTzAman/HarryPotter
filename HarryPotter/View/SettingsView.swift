//
//  SettingsView.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-29.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var store: Store
    var body: some View {
        ZStack{
            InfoBackground()
            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .shadow(radius: 1)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                ScrollView{
                    LazyVGrid(columns: [GridItem(), GridItem()], content: {
                        ForEach(0..<7){ i in
                            if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")) {
                                VStack{
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                    HStack{
                                        Spacer()
                                        Text("Added")
                                            .padding(.leading)
                                            .font(.caption)
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                            .padding(10)
                                        
                                    }
                                    .background(.regularMaterial)
                                }
                                .padding(15)
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    store.saveBooks()
                                }
                                .task {
                                    store.books[i] = .active
                                    store.saveBooks()
                                }
                            }
                            else if store.books[i] == .inactive {
                                VStack{
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .opacity(0.9)
                                    HStack{
                                        Spacer()
                                        Text("Not Added")
                                            .padding(.leading)
                                            .font(.caption)
                                        Spacer()
                                        Image(systemName: "checkmark.circle")
                                            .foregroundStyle(.black)
                                            .padding(10)
                                            .shadow(radius: 0)
                                    }
                                    .background(.gray)
                                }
                                .shadow(radius: 5)
                                .padding(15)
                                .onTapGesture {
                                    store.books[i] = .active
                                    store.saveBooks()

                                }
                                
                            }
                            else {
                                ZStack(alignment:.center) {
                                    VStack{
                                        Image("hp\(i+1)")
                                            .resizable()
                                            .scaledToFit()
                                            .overlay{
                                                Rectangle().fill(.opacity(0.6))
                                            }
                                        HStack{
                                            Spacer()
                                            Text("Locked")
                                                .padding(.leading)
                                                .font(.caption)
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "lock.fill")
                                                .foregroundStyle(.white)
                                                .padding(10)
                                        }
                                        .background(.black)
                                    }
                                    .background(.black)
                                    .padding(15)
                                    .shadow(radius: 5)
                                    Text("Tap to purchase")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                }
                                .onTapGesture {
                                    let product = store.products[i-3]
                                    
                                    Task {
                                        await
                                        store.purchase(product)
                                    }
                                }
                                
                            }
                        }
                    })
                }
                .padding(.bottom)
                Button("Go Back"){
                    dismiss()
                }
                .goBackButton()
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Store())
}
