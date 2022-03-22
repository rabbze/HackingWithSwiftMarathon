//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ilia Krasnobaev on 05.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var showingFinal = false
    @State private var count = 0
    @State private var currentFlag = 0
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var opacityValue = 1.0
    
    var body: some View {
        ZStack {
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 210, endRadius: 290)
            
            //LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer].uppercased())
                            //.foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        AnimatedButtonView(num: number, flagTapped: flagTapped(_:), countries: countries, opacityValue: opacityValue)
                    }
                    
                    /*
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                            /*
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                             */
                        }
                    }
                    */
                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(currentScore)")
                    //.foregroundColor(.white)
                    //.font(.title.bold())
                    .makeBlueTitle()
                Spacer()
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea()
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong" {
                Text("This is \(countries[currentFlag].uppercased()) flag.\nYour score is \(currentScore)")
            } else {
                Text("Your score is \(currentScore)")
            }
        }
        .alert("Congratulations!", isPresented: $showingFinal) {
            Button("Reset the game", action: reset)
        } message: {
            Text("This game is finished. Your score is \(currentScore).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong"
        }
        
        currentFlag = number
        count += 1
        opacityValue = 0.25
        
        switch count {
        case 8...:
            showingScore = false
            showingFinal = true
        default:
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityValue = 1.0
    }
    
    func reset() {
        currentScore = 0
        count = 0
        askQuestion()
    }
    
}


struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func makeBlueTitle() -> some View {
        modifier(BlueTitle())
    }
}

struct AnimatedButtonView: View {
    @State private var rotationDegree = 0.0
    @State private var tapped = false
    let num: Int
    let flagTapped: (Int) -> Void
    let countries: Array<String>
    let opacityValue: Double
    
    
    var body: some View {
        Button {
            withAnimation {
                rotationDegree += 360
                tapped = true
            }
            flagTapped(num)
        } label: {
            FlagImage(image: countries[num])
        }
        .opacity(tapped ? opacityValue : 1.0)
        .rotation3DEffect(.degrees(rotationDegree), axis: (x: 0, y: 1, z: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
