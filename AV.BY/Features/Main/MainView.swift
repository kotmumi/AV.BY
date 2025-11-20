//
//  MainView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 23.10.25.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        VStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                            .renderingMode(.template)
                        Text("Поиск")
                    }
                    .tag(0)
                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart")
                            .renderingMode(.template)
                        Text("Избранное")
                    }
                    .tag(1)
                
                CreateAdView()
                    .tabItem {
                        Image(systemName: "plus.app.fill")
                            .renderingMode(.template)
                        Text("Объявления")
                    }
                    .tag(2)
                
                ChatView()
                    .tabItem {
                        Image(systemName: "ellipsis.message.fill")
                            .renderingMode(.template)
                        Text("Сообщения")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "square.split.2x2.fill")
                            .renderingMode(.template)
                        Text("Профиль")
                    }
                    .tag(4)
            }
            .accentColor(.blue)
        }
    }
}
                
#Preview {
    MainView()
}
