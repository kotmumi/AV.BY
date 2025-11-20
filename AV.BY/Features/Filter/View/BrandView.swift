//
//  BrandView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct BrandView: View {
    
    @ObservedObject var viewModel: FilterViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @FocusState private var isSearching: Bool
    @State private var selectedSegment = 0
    @State private var selectedLetter: String = "A"
    @State private var selectedBrands: Set<String> = []
    
    private let brandsByLetter: [String: [String]] = Brands.brandsByLetter//[
//        "A": ["Audi", "Acura", "Alfa Romeo"],
//        "B": ["BMW", "Bentley", "Buick"],
//        "C": ["Chevrolet", "Chrysler", "Citroen"],
//        "D": ["Dacia", "Daewoo", "Daihatsu", "Datsun", "Denza", "DFSK", "Dodge", "Dongfeng", "Dongfeng Honda", "DS"],
//        "E": ["Epai"]
//    ]
    
    private var filteredBrands: [String: [String]] {
        if searchText.isEmpty {
            return brandsByLetter
        } else {
            return brandsByLetter.mapValues {
                $0.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }.filter { !$0.value.isEmpty }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: Header
                HStack {
                    Text("Марка")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.blueText)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray5))
                            .cornerRadius(16)
                    }
                }
                .padding()
                
                // MARK: Segmented Picker
                Picker("", selection: $selectedSegment) {
                    Text("Выбрать").tag(0)
                    Text("Исключить").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundStyle(.blueText)
                .padding()
               
                // MARK: Search
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Поиск марки", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isSearching)
                    }
                    .padding(10)
                    .frame(height: 40)
                    .background(.grayBackground)
                    .cornerRadius(10)
                    
                    if isSearching {
                           Button("Отмена") {
                               withAnimation(.easeInOut) {
                                   searchText = ""
                                   isSearching = false
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                               }
                           }
                           .foregroundColor(.blue)
                           .padding(.leading, 8)
                           .transition(.move(edge: .trailing).combined(with: .opacity))
                       }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // MARK: Alphabet index
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(filteredBrands.keys.sorted(), id: \.self) { letter in
                            Button {
                                withAnimation(.easeInOut) {
                                    selectedLetter = letter
                                }
                            } label: {
                                Text(letter)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.blueText)
                                    .padding(8)
                                    .background(selectedLetter == letter ? Color.grayBackground : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                // MARK: List of brands
                ScrollViewReader { proxy in
                    List {
                        ForEach(filteredBrands.keys.sorted(), id: \.self) { letter in
                                ForEach(filteredBrands[letter] ?? [], id: \.self) { brand in
                                    HStack {
                                        Text(brand)
                                        Spacer()
                                        if selectedBrands.contains(brand) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if selectedBrands.contains(brand) {
                                            selectedBrands.remove(brand)
                                        } else {
                                            selectedBrands.insert(brand)
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .onChange(of: selectedLetter) { newValue in
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                }
                
                // MARK: Bottom Buttons
                HStack {
                    Button {
                        selectedBrands.removeAll()
                    } label: {
                        Text("Сбросить")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Применить")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                //.background(Color.white.shadow(radius: 1))
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    BrandView(viewModel: FilterViewModel())
}
