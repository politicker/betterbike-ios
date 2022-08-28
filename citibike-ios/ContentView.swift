//
//  ContentView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @State var splashOpacity: Double = 1
    
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.locationFailed {
                ErrorLocationView()
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Text("Updated \(viewModel.lastUpdated)")
                            .font(.subheadline)
                        //				Spacer()
                        //				if let location = locationManager.location {
                        //					Text("Your location: \(location.latitude), \(location.longitude)")
                        //				}
                    }.padding()
                    List {
                        ForEach($viewModel.stations) { station in
                            StationView(station: station)
                        }.listStyle(InsetGroupedListStyle())
                    }.refreshable {
                        viewModel.fetchStations()
                    }
                }.onAppear {
                    locationManager.requestAuthorisation(always: false)
                    viewModel.fetchData()
                } //.ignoresSafeArea(.all, edges: .top)
                
                SplashScreen()
                    .opacity(viewModel.stations.isEmpty ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: viewModel.stations.isEmpty)
            }
        }
    }
    
    func getCurrentLocation() -> Void {
        locationManager.requestLocation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

