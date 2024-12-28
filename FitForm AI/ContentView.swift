//
//  ContentView.swift
//  FitForm AI
//
//  Created by Mac on 25/12/24.
//

import SwiftUI
import MapKit

class runTracker: NSObject,ObservableObject{
    @Published var region = MKCoordinateRegion(center: .init(latitude: 28.679079, longitude: 77.069710), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var isRunning = false
    
    var locationManager : CLLocationManager?
    var startLocation : CLLocation?
    var endLocation : CLLocation?
    
    override init() {
        super.init()
        
        Task{
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
}

struct AreaMap: View{
    @Binding var region : MKCoordinateRegion
    var body : some View{
        let binding = Binding(
            get : {self.region},
            set : { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
      )
        return Map(coordinateRegion: binding,showsUserLocation: true)
//            .ignoresSafeArea()
    }
}

extension runTracker: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        Task{
            await MainActor.run {
                region.center = location.coordinate
            }
        }
        if startLocation == nil{
            startLocation = location
            endLocation = location
            return
        }
        endLocation = location
    }
}

struct ContentView: View {
    @ObservedObject var authManager = AuthManager.shared
    @StateObject var runTrack = runTracker()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                ZStack(alignment: .bottom){
                    AreaMap(region: $runTrack.region)
                    Button{
                        
                    }label: {
                        Text("Start")
                            .bold()
                            .font(.title)
                            .foregroundColor(.black)
                            .padding(36)
                            .background(.yellow)
                            .clipShape(.circle)
                    }
                    .padding(.bottom,40)
                }
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .navigationTitle("Run")
        }
    }
}

    
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
//            if let photoURL = authManager.profilePhotoURL {
//                AsyncImage(url: photoURL) { image in
//                    image.resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                } placeholder: {
//                    ProgressView()
//                }
//            } else {
//                Image(systemName: "person.crop.circle")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//            }
//
//            Text("Welcome, \(authManager.userName)")
//                .font(.title)
//            Text("Email: \(authManager.email)")
//            Text("UID: \(authManager.uid)")
//
//            // Sign Out Button
//            Button(action: {
//                authManager.signOut()
//            }) {
//                Text("Sign Out")
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
