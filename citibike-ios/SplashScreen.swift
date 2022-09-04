//
//  SlashScreen.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import SwiftUI

struct SplashScreen: View {
	var body: some View {
		VStack {
			Image(systemName: "bolt")
				.foregroundColor(Color.brandGreen)
				.font(.system(size: 90))
			Text("Better Bike")
				.font(.system(size: 42))
				.fontWeight(.black)
		}
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
		.background(.white)
		.edgesIgnoringSafeArea(.all)
	}
}


struct SplashScreen_Previews: PreviewProvider {
	static var previews: some View {
		SplashScreen()
	}
}
