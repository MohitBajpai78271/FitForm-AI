//
//  SignInView.swift
//  FitForm AI
//
//  Created by Mac on 25/12/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct SignInView: View {
    
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(Color.gray.gradient)
                .ignoresSafeArea()
            VStack(spacing: 100){
                Image(systemName: "figure.mind.and.body.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipped()
                    .padding(.top,-50)
                VStack{
                    Button(action: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                           let rootViewController = window.rootViewController {
                           authManager.signInWithGoogle(presentingViewController: rootViewController)
                        }
                    }){
                        Text("SignIn with Google")
                            .padding()
                            .font(.system(size: 25,weight: .medium,design: .default))
                            .foregroundColor(Color.primary)
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .foregroundColor(.primary)
                                    .frame(width: 300)
                            }
                    }
                    
                    Button{
                        
                    }label: {
                        Text("SignIn with Apple")
                            .padding()
                            .font(.system(size: 23,weight: .medium,design: .default))
                            .foregroundColor(Color.primary)
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .foregroundColor(.primary)
                                    .frame(width: 300)
                            }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
