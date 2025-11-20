//
//  ChatViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var selectedTab = 0
    @Published var isAuth = false
    
    
}

