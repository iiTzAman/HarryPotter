//
//  ContentView.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var scalePlayBtn = false
    @State private var moveBackground = false
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top,3)
                    .offset(x: moveBackground ? geo.size.width * 1 : geo.size.width * -1)
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
                    .animation(.easeOut(duration: 2).delay(2), value:animateViewsIn)


                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            VStack{
                                Text("Recent Scores")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.bottom,5)
                                Text("33")
                                Text("44")
                                Text("50")
                            }
                            .font(.title3)
                            .padding(20)
                            .foregroundStyle(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black))
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 2).delay(2), value:animateViewsIn)
                    
                    Spacer()

                    VStack {
                        if animateViewsIn {
                            HStack{
                                Spacer()

                                Button{
                                    
                                } label: {
                                   Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.thickMaterial)
                                        .shadow(radius: 5)
                                }
                                Spacer()
                                Button{
                                    
                                } label: {
                                   Text("Play")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.black)
                                        .padding(.vertical,7)
                                        .padding(.horizontal,50)
                                        .background(.regularMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayBtn ? 1.1 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 2).repeatForever()){
                                        scalePlayBtn.toggle()
                                    }
                                }
                                
                                Spacer()
                                
                                Button{
                                    
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
                    .animation(.easeOut(duration: 2).delay(2), value: animateViewsIn)
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)

            
        }
        .ignoresSafeArea()
        .onAppear{
            animateViewsIn = true
            playAudio()
        }
    }
    
    private func playAudio(){
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
}

#Preview {
    ContentView()
}
