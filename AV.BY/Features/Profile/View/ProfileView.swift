//
//  ProfileView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var authManager = AuthManager()
    @State private var isShowingAuth = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Прочее")
                    .font(.headline)
                    .padding()
                ScrollView {
                    VStack(alignment: .leading) {
                        if authManager.isLoggedIn {
                            UserProfileHeaderView(authManager: authManager)
                        } else {
                            LoginPromptView(isShowingAuth: $isShowingAuth)
                        }
                        
                        Text("Сервисы")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 40)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(0..<7, id: \.self) { index in
                                ServiceContainer(index: index)
                            }
                        }
                        .padding(.bottom)
                        
                        Text("Прочее")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 40)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { index in
                                OtherContainer(index: index)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .background(Color.grayBackground)
        }
    }
}
    
#Preview {
    ProfileView()
}
