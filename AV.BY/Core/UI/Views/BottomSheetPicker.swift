//
//  BottomSheetPicker.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 10.11.25.
//

import SwiftUI

struct BottomSheetPicker<T: Hashable & CustomStringConvertible>: View {
    @Binding var selectedValue: T
    let values: [T]
    @Binding var isPresented: Bool
    let title: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(values, id: \.self) { value in
                    Button(action: {
                        selectedValue = value
                        isPresented = false
                    }) {
                        HStack {
                            Text(value.description)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedValue == value {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        isPresented = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
