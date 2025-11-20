//
//  SettingView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct SettingView: View {
    
    @State private var isOn = false
    private let authManager = AuthManager()
    
    var body: some View {
            List {
                Section {
                    Button(action: {}) {
                        Text("Пользователь")
                    }
                    
                    Button(action: {}) {
                        Text("Изменить пароль...")
                    }
                    
                    Button(action: {}) {
                        Text("Добавить почту...")
                    }
                    
                    Button(action: {}) {
                        Text("Добавить номер телефона...")
                    }
                }
                Section(header: Text("Уведомления")) {
                    Toggle("Рассылка о важных изменениях на AV.BY", isOn: $isOn)
                    Toggle("Подписка на изменения в объявлениях в закладках", isOn: $isOn)
                    Toggle("Уведомления о новых записях и комментариях в сообществе", isOn: $isOn)
                }
                Section {
                    Button(action: {}) {
                        Text("Удаление аккаунта...")
                    }
                } footer: {
                    Text("После удаления аккаунта все ваши данные будут недоступны для других пользователей")
                }
                
                Section {
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Выйти")
                                .padding(8)
                            Spacer()
                        }
                    }
                }
            }            
    }
}

#Preview {
    SettingView()
}
