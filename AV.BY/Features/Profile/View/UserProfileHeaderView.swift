//
//  UserProfileHeaderView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct UserProfileHeaderView: View {
        @ObservedObject var authManager: AuthManager
        
        var body: some View {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(authManager.currentUser?.email ?? "Пользователь")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        HStack {
                            NavigationLink(destination: SettingView()) {
                                Text("Настройки профиля")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Button(action: {}) {
                    Image(.garageButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding([.leading, .trailing])
                //.padding([.bottom], 4)
                
                NavigationLink(destination: CatalogView()) {
                    HStack {
                        Image(systemName: "list.clipboard")
                            .padding(.leading)
                        
                        Text("Мои отчеты по VIN")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.blueText)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
    }
