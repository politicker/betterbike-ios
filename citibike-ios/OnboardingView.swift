//
//  OnboardingView.swift
//  default
//
//  Created by Harrison Borges on 9/17/22.
//

import SwiftUI

struct OnboardingPage: View {
	let title: String
	let subTitle: String

	var showDismissButton: Bool = false
	var showLocationButton: Bool = false

	let viewModel: ViewModel
	@Binding var shouldShowOnboarding: Bool

	var body: some View {
		VStack {
			Text(title)
				.font(.largeTitle)
				.fontWeight(.black)
				.padding(.horizontal)
				.padding(.bottom, 4)
			Text(subTitle)
				.font(.body)
				.padding(.horizontal)
				.padding(.bottom)

			if showLocationButton {
				Button("Share Location") {
					viewModel.requestLocationPermission()
				}
				.padding()
			}

			if showDismissButton {
				Button("Get Started") {
					shouldShowOnboarding.toggle()
				}
					.foregroundColor(Color.white)
					.padding()
					.background(
						RoundedRectangle(
							cornerRadius: 10,
							style: .continuous
						)
						.fill(Color.primaryGreen)
					)
					.cornerRadius(6)
			}
		}
	}
}

struct OnboardingView: View {
	@Binding var shouldShowOnboarding: Bool
	let viewModel: ViewModel

	var body: some View {
		TabView {
			OnboardingPage(
				title: "Share Your Location",
				subTitle: "BetterBike uses your location to find the closest stations with electric bikes. We never store this information.",
				showLocationButton: true,
				viewModel: viewModel,
				shouldShowOnboarding: $shouldShowOnboarding)

			OnboardingPage(
				title: "Get Walking Directions",
				subTitle: "In an unfamiliar area? Tap on a row to get walking directions to the station from your current location",
				showDismissButton: true,
				viewModel: viewModel,
				shouldShowOnboarding: $shouldShowOnboarding)
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.onAppear {
//			UIPageControl.appearance().currentPageIndicatorTintColor = .red
//			UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
		}
	}
}
