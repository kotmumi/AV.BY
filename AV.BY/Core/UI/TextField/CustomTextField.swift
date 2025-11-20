//
//  CustomTextField.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 27.10.25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var error: String?
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                VStack(alignment: .leading, spacing: 0) {
                    if !text.isEmpty {
                        Text(title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    HStack {
                        if isSecure && !isPasswordVisible {
                            SecureField(placeholder, text: $text)
                                .font(.system(size: 16))
                                .textContentType(textContentType)
                        } else {
                            TextField(placeholder, text: $text)
                                .font(.system(size: 16))
                                .keyboardType(keyboardType)
                                .textContentType(textContentType)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        if isSecure {
                            Button(action: {
                                withAnimation {
                                    isPasswordVisible.toggle()
                                }
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    //.padding(.bottom)//text.isEmpty ? 12 : 4)
                    Spacer()
                }
            }
            .frame(height: 62)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(error != nil ? Color.red : Color.clear, lineWidth: 1)
                )
                .overlay(
                    errorOverlay,
                    alignment: .bottom
                )
                .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
                .animation(.easeInOut(duration: 0.2), value: error)
    }
    
    private var errorOverlay: some View {
        Group {
            if let error = error {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
                    .background(Color.white)
                    .offset(y: 10)
            }
        }
    }
}
