//
//  LoginView.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import SwiftUI

// Login View
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @EnvironmentObject var rootViewModel: RootViewModel
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack {
            
            Text("Please insert ID and BirthDate")
                .font(.headline)
                .padding()
            
            TextField("ID", text: $viewModel.id)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
                .onChange(of: viewModel.id) { newValue in
                    if newValue.count > 9 {
                        viewModel.id = String(newValue.prefix(9))
                    }
                }
            
            TextField("Birth Date", text: $viewModel.birthDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onTapGesture {
                    // Show date picker
                    viewModel.isDatePickerVisible.toggle()
                }
                .popover(isPresented: $viewModel.isDatePickerVisible, arrowEdge: .bottom) {
                    ZStack {
                        Color.clear
                            .onTapGesture {
                                // Dismiss the popover
                                viewModel.isDatePickerVisible.toggle()
                            }
                        
                        VStack {
                            Text("Select Birth Date")
                                .font(.headline)
                                .padding(.top)
                            
                            DatePicker("Birth Date", selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                                .frame(height: 200)
                            
                            HStack {
                                Spacer()

                                Button("Done") {
                                    // Format selected date
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MM/yyyy"
                                    viewModel.birthDate = formatter.string(from: viewModel.selectedDate)
                                    viewModel.isDatePickerVisible.toggle()
                                }
                                .padding()
                                Button("Cancel") {
                                    viewModel.isDatePickerVisible.toggle()
                                }
                                .padding()
                                Spacer()
                                }
                            

                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                    }
                }
            
            Button(action: {
                // Perform login validation
                if viewModel.login() {
                    // If login successful, navigate to MainView
                    rootViewModel.currentView = .otp(loginViewModel: viewModel)
                } else {
                    // If login failed, show alert
                    viewModel.showingAlert = true
                }
            }) {
                Text("Login")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Login Failed"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}


