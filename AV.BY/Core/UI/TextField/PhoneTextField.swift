//
//  PhoneTextField.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 27.10.25.
//

import SwiftUI

struct PhoneTextField: View {
    @Binding var phone: String
    var error: String?
    
    private let countryCode = "+375"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Телефон")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                Text(countryCode)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                
                TextField("", text: $phone)
                    .font(.system(size: 16))
                    .keyboardType(.numberPad)
                    .onChange(of: phone) { newValue in
                        phone = formatPhoneNumber(newValue)
                    }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .frame(height: 44)
        }
        .frame(height: 62)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(error != nil ? Color.red : Color.clear, lineWidth: 1)
        )
        .overlay(
            errorOverlay,
            alignment: .bottom
        )
        .animation(.easeInOut(duration: 0.2), value: phone.isEmpty)
    }
    
    private func formatPhoneNumber(_ phone: String) -> String {
        let cleanPhone = phone.filter { $0.isNumber }
        
        // Limit to 9 digits
        let limitedPhone = String(cleanPhone.prefix(9))
        
        // Format: XX XXX-XX-XX
        var result = ""
        let pattern = "XX XXX-XX-XX"
        
        var index = limitedPhone.startIndex
        for ch in pattern where index < limitedPhone.endIndex {
            if ch == "X" {
                result.append(limitedPhone[index])
                index = limitedPhone.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
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
