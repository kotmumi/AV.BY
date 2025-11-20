//
//  HomeView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = 0
    @State private var isShowingFilter = false
    @State private var isShowingBrand = false
    
    let categories = ["Авто с пробегом", "Новые авто", "Запчасти", "Грузовики"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Image(.AV)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.grayLogo)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 20)
                        .padding(.top)
                        .padding(.bottom, 12)
                    
                    HStack {
                        NavigationLink(destination: CatalogView()) {
                            VStack(alignment: .leading) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Text("\(viewModel.formattedCarsCount()) объявлений\n о продаже авто\n с пробегом")
                                        .font(.system(size: 22, weight: .heavy))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(12)
                        }
                        Spacer()
                        Image(.car)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 100)
                    }
                    .padding(.bottom, 12)
                    
                    HStack {
                        Button(action: {
                            isShowingBrand = true
                        }) {
                            if viewModel.filterViewModel.selectedBrands.isEmpty {
                                Text("Марка, модель, поколение")
                                    .font(.system(size: 16, weight: .regular))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                                    .padding([.top,.bottom],20)
                                    .padding([.leading],8)
                                Spacer()
                                Divider()
                                    .background(Color.gray)
                                    .padding([.top,.bottom],8)
                            } else {
                                Text("\($viewModel.filterViewModel.selectedBrands.first!)")
                                    .font(.system(size: 16, weight: .regular))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                                    .padding([.top,.bottom],20)
                                    .padding([.leading],8)
                                Spacer()
                                Divider()
                                    .background(Color.gray)
                                    .padding([.top,.bottom],8)
                            }
                            
                           
                        }
                        .sheet(isPresented: $isShowingBrand) {
                            BrandView(viewModel: viewModel.filterViewModel)
                        }
                        
                        Button(action: {
                            isShowingFilter = true
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .padding(.trailing,20)
                                .padding(.leading, 16)
                        }
                        .sheet(isPresented: $isShowingFilter) {
                            FilterView(viewModel: viewModel.filterViewModel)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding([.leading, .trailing, .top],8)
                }
                
                PrimaryButton(
                    title: "Показать \(viewModel.formattedCarsCount()) объявлений",
                    destination: CatalogView()
                )
                .background(Color.greenButton)
                .cornerRadius(12)
                .padding([.leading, .trailing, .top], 8)
                .padding([.bottom], 24)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(0..<12, id: \.self) { index in
                            CardContainer(index: index)
                        }
                    }
                    .padding([.leading, .trailing], 12)
                }
                .padding(.bottom, 12)
                
                VStack {
                    Button(action: {}) {
                        Image(.garageButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding([.leading, .trailing, .top], 12)
                    .padding([.bottom], 4)
                    
                    Button(action: {}) {
                        Image(.checkVin)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding([.leading, .trailing], 12)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {}) {
                            Image(.serviceSearch)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140)
                                .padding(4)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Button(action: {}) {
                            Image(.valuationCar)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140)
                                .padding(4)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Button(action: {}) {
                            Image(.credit)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140)
                                .padding(4)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Button(action: {}) {
                            Image(.electroCarSearch)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140)
                                .padding(4)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Button(action: {}) {
                            Image(.play)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140)
                                .padding(4)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.grayBackground)
            .navigationBarHidden(true)
            .refreshable {
                 viewModel.refreshData()
            }
        }
    }
}



// MARK: - Preview
#Preview {
    HomeView()
}


