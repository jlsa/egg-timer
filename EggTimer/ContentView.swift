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
    
    @State var currentProgress: Double = 0.0
    
    let eggTimes: [EggBoilPreferences: Double] = [
        .soft: 3.5, // 3.5 * 60 = 210 seconds
        .medium: 5, // 5 * 60 = 300 seconds
        .hard: 7 // 7 * 60 = 420 seconds
    ]
    
    var totalTime: Double = 0
    var secondsPassed: Double = 0
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { print("Player not working.."); return }
            if !player.isPlaying {
                player.play()
            }
        } catch let error {
            print("This is bad error handling. Enjoy the error! Read localized description here: \n", error.localizedDescription)
        }
    }
    
    func stopPlayingSound() {
        guard let player = player else { print("Player not working.."); return }
        if player.isPlaying {
            player.stop()
        }
    }
    
    var body: some View {
        VStack {
            Text("How do you like your eggs?")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width: 300, height: 60)
            Spacer()
            
            HStack {
                Button(action: {
                    print("Soft boiled please")
                    self.boiledPreference = EggBoilPreferences.soft
                }) {
                    Text("Soft")
                }
                .buttonStyle(BlueButtonStyle())
                
                
                Button(action: {
                    print("Medium boiled please")
                    self.boiledPreference = EggBoilPreferences.medium
                }) {
                    Text("Medium")
                }
                .buttonStyle(BlueButtonStyle())
                
                Button(action: {
                    print("Hard boiled please")
                    self.boiledPreference = EggBoilPreferences.hard
                }) {
                    Text("Hard")
                }
                .buttonStyle(BlueButtonStyle())
            }
            Spacer()
            
            Text("Current preference:  \(self.boiledPreference.rawValue)")
            
            Spacer()
            
            if self.timerStarted {
                ProgressView("Cooking...", value: currentProgress, total: 100)
                    .accentColor(.green)
                    .onReceive(timer) { _ in
                        if currentProgress == 100 {
                            self.playSound()
                        }
                        if currentProgress < 100 {
                            currentProgress += 60.0 / 100 * 1
                            print(currentProgress)
                        }
                    
                     }
                    .padding()
                
                Button(action: {
                    print("Stop timer")
                    self.timerStarted.toggle()
                    self.stopPlayingSound()
                }) {
                    Text("Stop Timer")
                }
                .buttonStyle(RedButtonStyle())
            } else {
                Button(action: {
                    print("Starting timer")
                    self.timerStarted.toggle()
                    self.currentProgress = 0
                }) {
                    Text("Start Timer")
                }
                .buttonStyle(GreenButtonStyle())
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
