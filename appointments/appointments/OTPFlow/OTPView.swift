//
//  OTPView.swift
//  appointments
//
//  Created by Yotam Golomb on 18/05/2024.
//

import SwiftUI
import Combine

struct OTPView: View {
    //MARK -> PROPERTIES
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @ObservedObject var viewModel: LoginViewModel
    @State private var otpDigits: [String] = Array(repeating: "", count: 4)
    
    @State private var isVerified: Bool? = nil
    private let correctOTP = "1234"
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    
    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    
    
    //MARK -> BODY
    var body: some View {
            VStack {
    
                Text("2-Step Verification")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                   
                Text("Enter 4 digit code received via SMS")
                    .font(.caption)
                    .fontWeight(.thin)
                    .padding(.top)
               
                HStack(spacing:15, content: {
                    
                    TextField("", text: $pinOne)
                        .modifier(OtpModifer(pin:$pinOne))
                        .onChange(of:pinOne){newVal in
                            if (newVal.count == 1) {
                                otpDigits[0] = newVal
                                pinFocusState = .pinTwo
                            }
                        }
                        .focused($pinFocusState, equals: .pinOne)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isVerified == nil ? Color.blue : (isVerified! ? Color.green : Color.red), lineWidth: 2)
                            )
                    
                    TextField("", text:  $pinTwo)
                        .modifier(OtpModifer(pin:$pinTwo))
                        .onChange(of:pinTwo){newVal in
                            if (newVal.count == 1) {
                                otpDigits[1] = newVal
                                pinFocusState = .pinThree
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinOne
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinTwo)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isVerified == nil ? Color.blue : (isVerified! ? Color.green : Color.red), lineWidth: 2)
                            )
                    
                    TextField("", text:$pinThree)
                        .modifier(OtpModifer(pin:$pinThree))
                        .onChange(of:pinThree){newVal in
                            if (newVal.count == 1) {
                                otpDigits[2] = newVal
                                pinFocusState = .pinFour
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinTwo
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinThree)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isVerified == nil ? Color.blue : (isVerified! ? Color.green : Color.red), lineWidth: 2)
                            )
                    
                    TextField("", text:$pinFour)
                        .modifier(OtpModifer(pin:$pinFour))
                        .onChange(of:pinFour){newVal in
                            if (newVal.count == 0) {
                                pinFocusState = .pinThree
                            } else {
                                if (newVal.count == 1) {
                                    otpDigits[3] = newVal
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinFour)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isVerified == nil ? Color.blue : (isVerified! ? Color.green : Color.red), lineWidth: 2)
                            )
                        
                })
                .padding(.vertical)
            
                
                Button(action: {
                    let otpCode = otpDigits.joined()
                    isVerified = otpCode == correctOTP
                     if isVerified == true {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                             rootViewModel.currentView = .main(mainViewModel: MainViewModel(loginViewModel: viewModel))
                         }
                    
                     }
                    
                }, label: {
                    Spacer()
                    Text("Verify")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                })
                .padding(15)
                .background(Color.blue)
                .clipShape(Capsule())
                .padding()
            }
        
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(viewModel: LoginViewModel())
    }
}

struct OtpModifer: ViewModifier {
    
    @Binding var pin : String
    
    var textLimt = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    
    //MARK -> BODY
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 45, height: 45)
            .background(Color.white.cornerRadius(5))
    }
}
