//
//  GameScreenView.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-05-02.
//

import SwiftUI
import AVKit

struct GameScreenView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var game: GameViewModel
    
    @Namespace private var namespace
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var showGameScreen = false
    @State private var showBackground = false
    @State private var showCelebrationScreen = false
    @State private var wiggleEffect = false
    @State private var pointAnimation = false
    @State private var nextQuestionScale = false
    @State private var showHints = false
    @State private var showBook = false
    @State private var onTappedWrongAnswer: [Int] = []
    
    private let answer = [true, false, false, false]
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                // MARK: Background
                Image(.hogwarts)
                    .resizable()
                    .scaledToFit()
                    .offset(y:geo.size.height / 4.5)
                    .overlay{
                        Rectangle().fill(.black.opacity(0.6))
                    }
                    .frame(width: geo.size.width *  3.5, height: geo.size.height * 1.1)
                
                VStack{
                    // MARK: Controls
                    HStack{
                        Button {
                            game.endGame()
                            dismiss()
                        } label: {
                            Text("End Game")
                                .padding(8)
                                .padding(.horizontal)
                                .background(.red.opacity(0.3))
                                .foregroundStyle(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius:4))
                                .font(.headline)
                                .transition(.opacity)
                            
                        }
                        Spacer()
                        HStack{
                            Text("Score:")
                            Text("\(game.gameScore)")
                        }
                        .transition(.opacity)
                        .font(.headline)
                    }
                    .padding(.top, 50)
                    .padding()
                    
                    // MARK: Question
                    VStack{
                        if showGameScreen {
                            Text("\(game.currentQuestion.question)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                                .padding(.top,30)
                                .padding(.horizontal,30)
                                .frame(maxHeight: geo.size.height/5)
                                .transition(.asymmetric(insertion: .offset(y:-300).combined(with: .scale), removal: .opacity.animation(.easeOut(duration: 0.1))))
                        }
                    }
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: showGameScreen)
                    
                    if showGameScreen {
                        Spacer()
                    }
                    
                    // MARK: Hints
                    HStack(alignment:.firstTextBaseline){
                        VStack {
                            VStack{
                                if showGameScreen {
                                    
                                    Image(systemName: "questionmark.app.fill")
                                        .font(.largeTitle)
                                        .scaleEffect(2)
                                        .padding(.leading,20)
                                        .foregroundStyle(.thinMaterial.opacity(0.8))
                                        .imageScale(.large)
                                        .rotationEffect(.degrees(wiggleEffect ? 0 : -5))
                                        .onAppear{
                                            withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)){
                                                wiggleEffect = true
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                showHints.toggle()
                                                game.questionScore -= 1
                                                playFlipSound()
                                            }
                                        }
                                        .rotation3DEffect(
                                            .degrees(showHints ? 1440 : 0),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(showHints ? 5 : 1)
                                        .opacity(showHints ? 0 : 1)
                                        .offset(x: showHints ? geo.size.width/2 : 0)
                                        .overlay(
                                            Text(game.currentQuestion.hint)
                                                .padding(.leading,10)
                                                .multilineTextAlignment(.center)
                                                .minimumScaleFactor(0.5)
                                                .opacity(showHints ? 1 : 0)
                                                .scaleEffect(showHints ? 1.33 : 1)
                                        )
                                        .opacity(showCelebrationScreen ? 0 : 1)
                                        .transition(.asymmetric(insertion: .offset(x:-200), removal: .opacity.animation(.easeOut(duration: 0.1))))
                                        .disabled(showHints)
                                }
                            }
                            .animation(.easeOut(duration: 1).delay(3), value: showGameScreen)
                        }
                        
                        if showGameScreen {
                            Spacer()
                        }
                        
                        VStack {
                            VStack{
                                if showGameScreen {
                                    
                                    Image(systemName: "book.fill")
                                        .font(.largeTitle)
                                        .scaleEffect(2)
                                        .padding(.trailing,20)
                                        .foregroundStyle(.thinMaterial.opacity(0.8))
                                        .imageScale(.medium)
                                        .transition(.asymmetric(insertion: .offset(x:200), removal: .opacity.animation(.easeOut(duration: 0.1))))
                                        .rotationEffect(.degrees(wiggleEffect ? 0 : 5))
                                        .onAppear{
                                            withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)){
                                                wiggleEffect = true
                                            }
                                        }
                                        .opacity(showCelebrationScreen ? 0 : 1)
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                showBook.toggle()
                                                game.questionScore -= 1
                                                playFlipSound()
                                            }
                                        }
                                        .rotation3DEffect(
                                            .degrees(showBook ? 1440 : 0),
                                            axis: (x: 0, y: 1, z: 0.0)
                                        )
                                        .scaleEffect(showBook ? 5 : 1)
                                        .opacity(showBook ? 0 : 1)
                                        .offset(x: showBook ? -geo.size.width/2 : 0)
                                        .overlay(
                                            Image("hp\(game.currentQuestion.book)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .padding(.trailing,10)
                                                .opacity(showBook ? 1 : 0)
                                                .offset(y:-20)
                                        )
                                        .disabled(showBook)
                                }
                            }
                            .animation(.easeOut(duration: 1).delay(3), value: showGameScreen)
                        }
                    }
                    .padding()
                    .foregroundStyle(.white)
                    
                    // MARK: Divider
                    VStack{
                        if showGameScreen {
                            Divider()
                                .overlay{
                                    Rectangle().fill(.white)
                                }
                                .padding(.bottom,10)
                                .transition(.asymmetric(insertion: .opacity, removal: .opacity.animation(.easeInOut(duration: 0.1))))
                        }
                    }
                    .padding(.top,20)
                    .animation(.easeOut.delay(2.5), value: showGameScreen)
                    
                    // MARK: Answers
                    VStack{
                        if showGameScreen {
                            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                                ForEach(Array(game.answers.enumerated()), id: \.offset){ i, answer in
                                    if game.currentQuestion.answer[answer] == true {
                                        if !showCelebrationScreen {
                                            Text("\(answer)")
                                                .padding(20)
                                                .font(.title2)
                                                .multilineTextAlignment(.center)
                                                .minimumScaleFactor(0.5)
                                                .frame(width: geo.size.width/2.3, height: geo.size.height/8)
                                                .background(.midnight.opacity(0.4))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .padding(.vertical,10)
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale:5).combined(with: .opacity.animation(.easeOut(duration: 0.1)))))
                                                .opacity(showCelebrationScreen ? 0 : 1)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 1)) {
                                                        playCorrectSound()
                                                        showCelebrationScreen = true
                                                        showGameScreen = false
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                            game.correct()
                                                        }
                                                    }
                                                }
                                        }
                                    } else {
                                        Text("\(answer)")
                                            .padding(20)
                                            .font(.title2)
                                            .multilineTextAlignment(.center)
                                            .minimumScaleFactor(0.2)
                                            .frame(width: geo.size.width/2.3, height: geo.size.height/8)
                                            .background(onTappedWrongAnswer.contains(i) ? .red.opacity(0.4) : .midnight.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.vertical,10)
                                            .opacity(showCelebrationScreen ? 0 : 1)
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 1)) {
                                                    playWrongSound()
                                                    playWrongFeedback()
                                                    game.questionScore -= 1
                                                    onTappedWrongAnswer.append(i)
                                                }
                                            }
                                            .disabled(onTappedWrongAnswer.contains(i))
                                    }
                                }
                            })
                            .padding(.bottom,30)
                            .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity.animation(.easeInOut(duration: 0.1))))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(1.5), value: showGameScreen)
                    
                    
                    // MARK: CELEBRATION
                    VStack{
                        VStack{
                            if showCelebrationScreen {
                                Text("\(game.questionScore)")
                                    .font(.system(size: 50, weight: .heavy))
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity.animation(.easeInOut(duration: 0.1))))
                            }
                        }
                        .animation(.easeOut(duration: 1), value: showCelebrationScreen)
                        
                        VStack{
                            if showCelebrationScreen {
                                Text("\(game.questionScore)")
                                    .font(.system(size: 50, weight: .heavy))
                                    .offset(y:-60)
                                    .transition(.asymmetric(insertion: .opacity, removal: .opacity.animation(.easeInOut(duration: 0.1))))
                                    .offset(x: pointAnimation ? geo.size.width / 2.3 : 0, y: pointAnimation ? geo.size.height / -9 : 0)
                                    .opacity(pointAnimation ? 0 : 1)
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 1.5).delay(1)){
                                            pointAnimation = true
                                        }
                                    }
                            }
                        }
                        .animation(.easeOut(duration: 1).delay(1), value: showCelebrationScreen)
                        
                        VStack{
                            if showCelebrationScreen {
                                Text("Points")
                                    .font(.callout)
                                    .transition(.asymmetric(insertion: .opacity, removal: .opacity.animation(.easeInOut(duration: 0.1))))                                    .offset(y:-60)
                            }
                        }
                        .animation(.easeOut.delay(1), value: showCelebrationScreen)
                        
                        VStack{
                            if showCelebrationScreen {
                                Text("Good Job !!")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(.top,50)
                                .transition(.asymmetric(insertion: .opacity, removal: .opacity.animation(.easeInOut(duration: 0.1))))                            }
                        }
                        .animation(.easeOut(duration: 1).delay(1.3), value: showCelebrationScreen)
                        
                        VStack{
                            if showCelebrationScreen {
                                Text(game.correctAnswer)
                                    .padding(20)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(width: geo.size.width/1.1, height: 200)
                                    .background(.purple.opacity(0.05))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.top,50)
                                    .transition(.asymmetric(insertion: .opacity, removal: .opacity.animation(.easeInOut(duration: 0.1))))
                            }
                        }
                        .animation(.easeOut(duration: 1).delay(1.5), value: showCelebrationScreen)
                        
                        if showCelebrationScreen {
                            Spacer()
                        }
                        
                        VStack{
                            if showCelebrationScreen {
                                Button {
                                    showCelebrationScreen = false
                                    showGameScreen = true
                                    showBook = false
                                    showHints = false
                                    onTappedWrongAnswer = []
                                    wiggleEffect = false
                                    pointAnimation = false
                                    nextQuestionScale = false
                                    playMusic()
                                    game.nextQuestion()
                                } label: {
                                    Text("Next Question")
                                        .padding(8)
                                        .padding(.horizontal)
                                        .background(.regularMaterial)
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius:4))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        
                                }
                                .transition(.asymmetric(insertion: .offset(y:geo.size.height * 4).combined(with: .opacity), removal: .opacity.animation(.easeInOut(duration: 0.1))))
                                .scaleEffect(nextQuestionScale ? 1.2 : 1.1)
                                .onAppear{
                                    withAnimation(.easeOut(duration: 1).repeatForever()){
                                        nextQuestionScale = true
                                    }
                                }
                            }
                        }
                        .animation(.easeOut(duration: 1).delay(1.5), value: showCelebrationScreen)
                        
                        if showCelebrationScreen{
                            Spacer()
                            Spacer()
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.black.opacity(0.9))
        }
        .ignoresSafeArea()
        .foregroundStyle(.regularMaterial)
        .onAppear{
            showGameScreen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                playMusic()
            }
        }
    }
    
    private func playMusic() {
        
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        
        let i = Int.random(in: 0...3)
        do{
            if let sound = Bundle.main.path(forResource: "\(songs[i])", ofType: "mp3"){
                musicPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
                musicPlayer.volume = 0.4
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            }
        } catch {
            try? AVAudioSession.sharedInstance().setActive(false)
        }
    }
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.3
        sfxPlayer.play()
    }
    
    private func playWrongSound() {
        do{
            if let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3"){
                
                sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
                sfxPlayer.volume = 0.3
                sfxPlayer.play()
            }
        } catch {
            
        }
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.3
        sfxPlayer.play()
    }
    
    private func playWrongFeedback(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

#Preview {
    GameScreenView()
        .environmentObject(GameViewModel())
}
