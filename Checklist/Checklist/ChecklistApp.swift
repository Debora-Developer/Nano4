//
//  ChecklistApp.swift
//  Checklist
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import Firebase

@main
struct ChecklistApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
