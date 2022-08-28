//
//  Error.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import SwiftUI

struct ErrorLocationView: View {
    //	TODO: Pass in model to re-fetch station data
    //	@Binding var model: MainModel?
    
    var body: some View {
        VStack {
            Image(systemName: "location.slash")
                .font(.system(size: 90))
            Text("Location not enabled")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .padding(.bottom)
            Button("Settings") {
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ErrorLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorLocationView()
    }
}
