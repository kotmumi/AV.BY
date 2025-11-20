//
//  FavoritesView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var isAuth = false
    
    var body: some View {
            VStack(spacing: 0) {
                Text("Избранное")
                    .font(.headline)
                    .padding()
                
                AdvancedCustomSegmentedPicker(
                    options: ["Закладки", "Поиск"],
                    selectedIndex: $viewModel.selectedTab
                )
                ZStack {
                    ScrollView {
                        if viewModel.selectedTab == 0 {
                            HStack {
                                Spacer()
                                VStack {
                                    if !viewModel.isAuth || $viewModel.favoriteCars.isEmpty {
                                        Image(.parking)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 350)
                                            .padding()
                                    }
                                    if !viewModel.isAuth {
                                        Text("Войдите в кабинет или зарегистрируйтесь, что бы пользоваться закладками и делиться или с друзьями")
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.secondary)
                                            .padding(12)
                                    } else if $viewModel.favoriteCars.isEmpty {
                                        VStack {
                                            Text("У вас нет закладок")
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.secondary)
                                                .padding(12)
                                            
                                            Text("Добавляйте объявления в закладкими возвращайтесь в любой момент - они будут здесь")
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.secondary)
                                                .padding(12)
                                            Text("Когда у вас появятся закладки, вы сможите поделиться целым списком с друзьями")
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.secondary)
                                                .padding(12)
                                        }
                                    } else {
                                        LazyVStack(spacing: 12) {
                                            ForEach(viewModel.favoriteCars) { car in
                                                FavoriteCarCell(car: car, viewModel: viewModel)
                                            }
                                        }
                                        .padding()
                                    }
                                }
                                Spacer()
                            }
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Image(.massage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300)
                                        .padding()
                                    Text("Войдите в кабинет или зарегистрируйтесь, что бы пользоваться сохраненными поисками")
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.secondary)
                                        .padding(12)
                                }
                            }
                        }
                    }
                    
                    if !viewModel.isAuth  {
                        VStack {
                            Spacer()
                            Button(action: {
                                isAuth = true
                            }) {
                                Text("Войти...")
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .sheet(isPresented: $isAuth) {
                                AuthView()
                            }
                            .padding()
                            .padding(.horizontal, 4)
                            
                        }
                    } else {
                        if viewModel.favoriteCars.isEmpty {
                            
                        }
                    }
                }
                .onAppear {
                            viewModel.loadFavorites()
                        }
                .background(.grayBackground)
            }
    }
}

#Preview {
    FavoritesView()
}
