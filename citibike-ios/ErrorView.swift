//
//  Error.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import SwiftUI

struct ErrorView: View {
    //	TODO: Pass in model to re-fetch station data
    //	@Binding var model: MainModel?
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 90))
            Text("Something went wrong")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .padding(.bottom)
            Button("Try Again") {
                print("fetch stations")
                // model.fetchStationData()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
