//
//  CountDownView.swift
//  FitForm AI
//
//  Created by Mac on 26/12/24.
//

import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var runTracker: runTracker
    @State var timer: Timer?
    @State var countDown: Int = 3
    
    var body: some View {
        Text("\(countDown)")
            .font(.system(size: 256))
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(.yellow)
            .onAppear{
                setupCountdown()
            }
    }
    
    func setupCountdown(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if countDown<=1{
                timer?.invalidate()
                timer = nil
            }else{
                countDown -= 1
            }
        }
    }
}

#Preview {
    CountDownView()
}
