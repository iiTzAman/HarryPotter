//
//  ContentView.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: GameViewModel
    @State private var scalePlayBtn = false
    @State private var moveBackground = false
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var showInfoScreen = false
    @State private var showSettingsScreen = false
    @State private var startGameScreen = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top,3)
                    .offset(x: moveBackground ? geo.size.width * 0.9 : geo.size.width * -0.9)
                    .offset(y:50)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 30).repeatForever()){
                            moveBackground.toggle()
                        }
                    }
                
                VStack{
                    VStack{
                        if animateViewsIn {
                            VStack{
                                Text("Harry Potter Quiz")
                                    .font(.custom(Constants.hpFont, size: 50))
                            }
                            .padding(.top,90)
                            .padding(.bottom,20)
                            .shadow(color:.white,radius: 2)
                            .frame(width: geo.size.width)
                            .background(.white.opacity(0.5))
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(1), value:animateViewsIn)


                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            VStack{
                                Text("Recent Scores")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.bottom,5)
                                Text("\(game.recentScores[0])")
                                Text("\(game.recentScores[1])")
                                Text("\(game.recentScores[2])")
                            }
                            .font(.title3)
                            .padding(20)
                            .foregroundStyle(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black))
                            .background(.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(1), value:animateViewsIn)
                    
                    Spacer()

                    VStack {
                        if animateViewsIn {
                            HStack{
                                Spacer()

                                Button{
                                    showInfoScreen.toggle()
                                } label: {
                                   Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.thickMaterial)
                                        .shadow(radius: 5)
                                }
                                Spacer()
                                Button{
                                    filterQuestions()
                                    game.startGame()
                                    startGameScreen.toggle()
                                } label: {
                                   Text("Play")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.black)
                                        .padding(.vertical,7)
                                        .padding(.horizontal,50)
                                        .background(store.books.contains(.active) ? .regularMaterial :  .ultraThin)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .shadow(radius: 5)
                                        
                                }
                                .scaleEffect(scalePlayBtn ? 1.1 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 2).repeatForever()){
                                        scalePlayBtn.toggle()
                                    }
                                }
                                .disabled(store.books.contains(.active) ? false : true)
                                
                                
                                Spacer()
                                
                                Button{
                                    showSettingsScreen.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                         .font(.largeTitle)
                                         .foregroundStyle(.thickMaterial)
                                         .shadow(radius: 5)
                                }
                                Spacer()

                            }
                            .frame(width: geo.size.width)
                            .transition(.offset(y: geo.size.width))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(1), value: animateViewsIn)
                    if !store.books.contains(.active){
                        Text("No Books selected, select a book from settings")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                            .padding(20)
                    }
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)

            
        }
        .ignoresSafeArea()
        .onAppear{
            animateViewsIn = true
            playAudio(file: "magic-in-the-air", loop: -1)
        }
        .sheet(isPresented: $showInfoScreen){
            InfoView()
        }
        .sheet(isPresented: $showSettingsScreen){
            SettingsView()
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $startGameScreen, content: {
            GameScreenView()
                .environmentObject(game)
                .onAppear{
                    audioPlayer.setVolume(0, fadeDuration: 1)
                }
                .onDisappear{
                    audioPlayer.setVolume(1, fadeDuration: 1)
                }
        })
    }
    
    private func playAudio(file: String, loop: Int){
        let sound = Bundle.main.path(forResource: file, ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = loop
        audioPlayer.play()
    }
    
    private func filterQuestions(){
        var books: [Int] = []
        
        for (index, status) in store.books.enumerated() {
            if status == .active {
                books.append(index+1)
            }
        }
        game.filterQuestions(of: books)
        game.nextQuestion()
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(GameViewModel())
}
