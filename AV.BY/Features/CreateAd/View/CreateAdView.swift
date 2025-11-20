//
//  CreateAdView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct CreateAdView: View {
    
    @StateObject private var viewModel = CreateAdViewModel()
    @State private var showingAuth = false
    @State private var showingCreateForm = false
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("Мои объявления")
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                        
                        if viewModel.isAuth {
                            Button(action: {
                                showingCreateForm = true
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.white)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                if viewModel.isAuth {
                    if viewModel.isLoading {
                        ProgressView("Загрузка...")
                            .padding()
                    } else if let error = viewModel.error {
                        VStack {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Повторить") {
                                viewModel.loadUserAds()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else if viewModel.userAds.isEmpty {
                        VStack(spacing: 20) {
                            Image(.parking)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250)
                            
                            Text("У вас пока нет объявлений")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("Создайте первое объявление, чтобы начать продавать")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .padding(.top, 50)
                    } else {
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.userAds) { car in
                                    UserAdCell(car: car)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(.parking)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                        
                        Text("Войдите в кабинет или зарегистрируйтесь, чтобы пользоваться закладками и делиться ими с друзьями")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            VStack {
                Spacer()
                
                if viewModel.isAuth {
                    Button(action: {
                        showingCreateForm = true
                    }) {
                        Text("Подать объявление")
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                } else {
                    Button(action: {
                        showingAuth = true
                    }) {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
        .background(.grayBackground)
        .sheet(isPresented: $showingAuth) {
            AuthView()
        }
        .sheet(isPresented: $showingCreateForm) {
            CategoryView()
        }
        .onAppear {
            viewModel.checkAuthStatus()
        }
        .refreshable {
            await viewModel.refreshAds()
        }
    }
}



#Preview {
    CreateAdView()
}
