//
//  ContentView.swift
//  Shared
//
//  Created by Dennis Birch on 3/23/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .onAppear{
                DemoAnalytics.addAnalyticsItem("Display main view")
            }
    }
}

struct FirstButtonGroup: View {
    var body: some View {
        VStack {
            PlaySoundButton(title: "Ring Bell")
            PlaySoundButton(title: "Horn Blaring")
            PlaySoundButton(title: "Foghorn Warning")
            PlaySoundButton(title: "Car Revving")
            PlaySoundButton(title: "Dog Barking")
            PlaySoundButton(title: "Fire Siren")
            PlaySoundButton(title: "Oven Timer")
        }
    }
}

struct SecondButtonGroup: View {
    var body: some View {
        VStack {
            PlaySoundButton(title: "Car Door Slam")
            PlaySoundButton(title: "Heavy Breathing")
            PlaySoundButton(title: "Soft Sigh")
            PlaySoundButton(title: "Thunderclap")
            PlaySoundButton(title: "Ocean Wave Crashing")
            CountActionButton(title: "Count Something")
            CountActionButton(title: "Count Something Else")
        }
    }
}

struct PlaySoundButton: View {
    let title: String
    var body: some View {
        Button(title) {
            playSound(title)
        }
        .padding()
    }
    
    private func playSound(_ title: String) {
        DemoAnalytics.addAnalyticsItem("Play sound: \(title)", params: ["Demo details" : randomString()])
        // do whatever else this button should do
    }
    
    private func randomString() -> String {
        let wordArray = "The quick brown fox jumped over the cow".split(separator: " ")
        let count = wordArray.count
        let index = arc4random_uniform(UInt32(count))
        return String(wordArray[Int(index)])
    }
}

struct CountActionButton: View {
    let title: String
    var body: some View {
        Button(title) {
            addCount(title)
        }
        .padding()
    }
    
    private func addCount(_ title: String) {
        DemoAnalytics.countItem(title)
        // do whatever else this button should do
    }
}

#if os(iOS)
struct MainView: View {
    var body: some View {
        ScrollView {
            VStack {
                FirstButtonGroup()
                SecondButtonGroup()
            }
        }
    }
}
#elseif os(macOS)
struct MainView: View {
    var body: some View {
        HStack {
            FirstButtonGroup()
            SecondButtonGroup()
        }
    }
}
#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
