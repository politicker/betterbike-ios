//
//  ContentView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct UpdatedAtView: View {
	var lastUpdated: String
	var body: some View {
		Text("Updated \(lastUpdated)")
			.font(.subheadline)
			.foregroundColor(.gray)
			.frame(maxWidth: .infinity, alignment: .center)
	}
}

struct ContentView: View {
	@AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
	@State var splashOpacity: Double = 1
	@StateObject var viewModel = ViewModel.shared

	var body: some View {
		ZStack {
				AppView(viewModel: viewModel)
					.fullScreenCover(isPresented: $shouldShowOnboarding, content: {
						OnboardingView(shouldShowOnboarding: $shouldShowOnboarding, viewModel: viewModel)
					})
				SplashScreen()
					.opacity(viewModel.stations.isEmpty ? 1 : 0)
					.animation(.easeOut(duration: 0.3), value: viewModel.stations.isEmpty)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

