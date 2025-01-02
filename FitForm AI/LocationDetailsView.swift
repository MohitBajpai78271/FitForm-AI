//
//  LocationDetailsView.swift
//  Trishakti-New
//
//  Created by Mac on 31/12/24.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection : MKMapItem?
    @State private var lookAroundScene : MKLookAroundScene?
    @Binding var show : Bool
    @Binding var getDirection : Bool
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                Spacer()
                Button{
                    show.toggle()
                    mapSelection = nil
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24,height: 24)
                        .foregroundStyle(.gray, Color(.systemGray))
                    
                }
            }
            if let scene = lookAroundScene{
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else{
                ContentUnavailableView("No previe Available",systemImage: "eye.slash")
            }
            HStack(spacing: 24) {
                Button{
                    if let mapSelection{
                        mapSelection.openInMaps()
                    }
                }label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170,height: 50)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button{
                    getDirection = true
                    show = false
                }label: {
                    Text("Get Direction")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170,height: 50)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear{
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
        }
        .padding()
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil),show: .constant(false),getDirection: .constant(false))
}
extension LocationDetailsView{
    func fetchLookAroundPreview(){
        if let mapSelection{
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
    
}
