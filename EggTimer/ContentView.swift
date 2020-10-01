//
//  ContentView.swift
//  EggTimer
//
//  Created by Joel Hoekstra on 01/10/2020.
//

import SwiftUI
import AVFoundation

enum EggBoilPreferences: String {
    case soft = "Soft"
    case medium = "Medium"
    case hard = "Hard"
}

struct ContentView: View {
    @State var boiledPreference: EggBoilPreferences = EggBoilPreferences.medium
    
    @State var timerStarted: Bool = false
    
    @State var player: AVAudioPlayer?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    static let minute: Double = 1.0//60.0
    
    @State var eggTimes: [EggBoilPreferences: Double] = [
        .soft: 3.5 * ContentView.minute, // 3.5 * 60 = 210 seconds
        .medium: 5.0 * ContentView.minute, // 5 * 60 = 300 seconds
        .hard: 7.0 * ContentView.minute // 7 * 60 = 420 seconds
    ]
    
    @State var totalTime: Double = 0.0
    @State var secondsPassed: Double = 0.0
    
    @State var titleText: String = "How do you like your eggs?"
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { print("Player not working.."); return }
            
            player.play()
        } catch let error {
            print("This is bad error handling. Enjoy the error! Read localized description here: \n", error.localizedDescription)
        }
    }
    
    func startBoiling(eggBoilPreference: EggBoilPreferences) {
        boiledPreference = eggBoilPreference
        totalTime = eggTimes[eggBoilPreference]!
        secondsPassed = 0.0
        timerStarted = true
        titleText = "Boiling it the \(self.boiledPreference.rawValue) way!"
    }
    
    func reset() {
        timerStarted = false
        titleText = "How do you like your eggs?"
        secondsPassed = 0.0
        totalTime = Double.greatestFiniteMagnitude
        boiledPreference = EggBoilPreferences.medium
    }
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width: 300, height: 60)
            Spacer()
            
            if !timerStarted {
                HStack {
                    Button(action: {
                        startBoiling(eggBoilPreference: EggBoilPreferences.soft)
                    }) {
                        Text("Soft")
                    }
                    .buttonStyle(BlueButtonStyle())
                    
                    
                    Button(action: {
                        startBoiling(eggBoilPreference: EggBoilPreferences.medium)
                    }) {
                        Text("Medium")
                    }
                    .buttonStyle(BlueButtonStyle())
                    
                    Button(action: {
                        startBoiling(eggBoilPreference: EggBoilPreferences.hard)
                    }) {
                        Text("Hard")
                    }
                    .buttonStyle(BlueButtonStyle())
                }
            } else {
                ProgressView("Cooking...", value: secondsPassed, total: totalTime)
                    .accentColor(.green)
                    .onReceive(timer) { _ in
                        if totalTime > secondsPassed {
                            secondsPassed = secondsPassed + 1
                            if secondsPassed > totalTime { secondsPassed = totalTime }
                        } else {
                            playSound()
                            titleText = "Done. You have a \(boiledPreference.rawValue) boiled egg!"
                            timerStarted = false
                        }
                     }
                    .padding()
                
                Spacer()
                
                Button(action: {
                    reset()
                }) {
                    Text("Cancel")
                }.buttonStyle(RedButtonStyle())
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
