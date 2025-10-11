//
//  ContentView.swift
//  Nano4
//
//  Created by Débora Costa on 07/10/25.
//

import SwiftUI
import MijickCamera
import MijickTimer

struct ContentView: View {
    var body: some View {
        MCamera()
            .startSession()
    }
}

#Preview {
    ContentView()
}
