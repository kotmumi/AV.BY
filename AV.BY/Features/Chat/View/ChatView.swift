//
//  ChatView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject private var viewModel = ChatViewModel()
    @State private var isAuth = false
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("Сообщения")
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "archivebox.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding()
                }
                
                Image(.chat)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .padding()
                Text("Войдите или зврегистрируйтесь чтобы писать сообщения другим пользоваться ")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
                Spacer()
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
                }
            }
        }
        .background(.grayBackground)
    }
}

#Preview {
    ChatView()
}
