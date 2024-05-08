//
//  Constants.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-28.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
    static let previewQuestion = try! JSONDecoder().decode([QuestionModel].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}

struct InfoBackground: View{
    var body: some View {
        Image(.parchment)
            .resizable()
            .ignoresSafeArea()
            .background(.black.opacity(0.9))
    }
}

extension Button {
    func goBackButton() -> some View {
        self
            .font(.title2)
            .foregroundStyle(.black)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

extension FileManager {
    var documentDirectory: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}
