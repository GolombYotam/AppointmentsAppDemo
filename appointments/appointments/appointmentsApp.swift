//
//  appointmentsApp.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import SwiftUI
import SwiftData

class RootViewModel: ObservableObject {
    @Published var currentView: RootView = .login

    enum RootView {
        case login
        case otp(loginViewModel : LoginViewModel)
        case main(mainViewModel: MainViewModel)
        case specialtySelection(crowdType: String, firstName: String, mainViewModel: MainViewModel)
        case dateAndTimeSelection(patientId: String,dateAndTimeViewModel: DateAndTimeSelectionViewModel, mainViewModel: MainViewModel)
        case confirmation(patientId: String, confirmationViewModel: ConfirmationViewModel, dateAndTimeViewModel: DateAndTimeSelectionViewModel, mainViewModel: MainViewModel)
    }
}

struct RootViewSwitcher: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        switch rootViewModel.currentView {
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .otp(let loginViewModel):
            OTPView(viewModel: loginViewModel)
        case .main(let mainViewModel):
            MainView(viewModel: mainViewModel)
        case .specialtySelection(let crowdType, let firstName, let mainViewModel):
            NavigationView {
                SpecialtySelectionView(crowdType: crowdType, firstName: firstName, mainViewModel: mainViewModel)
                    .navigationBarTitle("Choose Specialty", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        rootViewModel.currentView = .main(mainViewModel: mainViewModel)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    })
            }
        case .dateAndTimeSelection(let patientId, let dateAndTimeViewModel, let mainViewModel):
            NavigationView {
                DateAndTimeSelectionView(viewModel: dateAndTimeViewModel, mainViewModel: mainViewModel, patientId: patientId)
                    .navigationBarTitle("Choose Date and Time", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        rootViewModel.currentView = .specialtySelection(crowdType: dateAndTimeViewModel.crowdType, firstName: dateAndTimeViewModel.firstName, mainViewModel: mainViewModel)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    })
            }
        case .confirmation(let patientId, let confirmationViewModel, let dateAndTimeViewModel, let mainViewModel):
            NavigationView {
                ConfirmationView(viewModel: confirmationViewModel, mainViewModel: mainViewModel)
                    .navigationBarTitle("Confirmation", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        rootViewModel.currentView = .dateAndTimeSelection(patientId: patientId, dateAndTimeViewModel: dateAndTimeViewModel, mainViewModel: mainViewModel)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    })
            }
        }
    }
}

@main
struct appointmentsApp: App {
    
    @StateObject private var rootViewModel = RootViewModel()

    var body: some Scene {
        WindowGroup {
            RootViewSwitcher().environmentObject(rootViewModel)
        }
    }
}

