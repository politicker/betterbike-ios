//
//  OnboardingView.swift
//  default
//
//  Created by Harrison Borges on 9/17/22.
//

import SwiftUI
import Combine

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
				.font(.title)
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
				.foregroundColor(Color.primary)
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
	@ObservedObject var viewModel: ViewModel

	var body: some View {
		TabView(selection: $viewModel.onboardingTab) {
			OnboardingPage(
				title: "Share Your Location",
				subTitle: "BetterBike uses your location to find the closest stations with electric bikes. We never store this information.",
				showLocationButton: true,
				viewModel: viewModel,
				shouldShowOnboarding: $shouldShowOnboarding)
			.tag(0)
			.allowsHitTesting(false)

			OnboardingPage(
				title: "Get Walking Directions",
				subTitle: "In an unfamiliar area? Tap on a row to get walking directions to the station from your current location",
				showDismissButton: true,
				viewModel: viewModel,
				shouldShowOnboarding: $shouldShowOnboarding)
			.tag(1)
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.onAppear {
			UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.foreground)
			UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.foreground).withAlphaComponent(0.2)
		}
	}
}
