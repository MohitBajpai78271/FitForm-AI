//
//  RunClubTabView.swift
//  FitForm AI
//
//  Created by Mac on 26/12/24.
//

import SwiftUI

struct RunClubTabView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView (selection: $selectedTab){
            ContentView()
                .tag(0)
                .tabItem {
                    Image(systemName: "figure.run")
                    
                    Text("Run")
                }
        }
    }
}

#Preview {
    RunClubTabView()
}
