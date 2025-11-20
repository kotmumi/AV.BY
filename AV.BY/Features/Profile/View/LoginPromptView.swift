//
//  LoginPromptView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct LoginPromptView: View {
        @Binding var isShowingAuth: Bool
        
        var body: some View {
            Button(action: {
                isShowingAuth = true
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Войти")
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.blueText)
                            .padding([.top, .leading])
                            .padding(.bottom, 4)
                        
                        Text("Чтобы подавать объявления, писать сообщения, сохранять поиски и закладки")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .padding([.bottom, .horizontal])
                    }
                    Spacer()
                }
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .sheet(isPresented: $isShowingAuth) {
                AuthView()
            }
        }
    }
