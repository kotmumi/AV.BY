//
//  AuthView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 24.10.25.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
   @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Spacer()
                    Image(.AV)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .padding(.trailing, 24)
                }

                VStack(alignment: .leading, spacing: 8) {
                    AdvancedCustomSegmentedPicker(
                        options: ["Вход", "Регистрация"],
                        selectedIndex: $viewModel.selectedTab
                    )
                }
                .padding(.top, 12)
                
                Picker("", selection: $viewModel.selectedTabAuth) {
                    Text("По телефону").tag(0)
                    Text(viewModel.isLoginMode ? "Почте или логину" : "Почте").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 24)
                
                VStack(spacing: 16) {
                    if !viewModel.isLoginMode {
                        CustomTextField(
                            title: "Имя",
                            placeholder: "Имя",
                            text: $viewModel.name,
                            error: viewModel.nameError
                        )
                    }
                    
                    if viewModel.isPhoneAuth {
                        PhoneTextField(
                            phone: $viewModel.phone,
                            error: viewModel.phoneError
                        )
                    } else {
                        CustomTextField(
                            title: "Электронная почта или логин",
                            placeholder:  "Электронная почта или логин",
                            text: $viewModel.email,
                            error: viewModel.emailError
                        )
                    }
                    
                    CustomTextField(
                        title: "Пароль",
                        placeholder: "Пароль",
                        text: $viewModel.password,
                        isSecure: true,
                        error: viewModel.passwordError
                    )
                }
                .padding(.horizontal)
                .padding(.top, 32)
                
                Button(action: handleAuthAction) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text(viewModel.isLoginMode ? "Войти" : "Зарегистрироваться")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .background(viewModel.isFormValid ? Color.blue : Color.gray)
                .cornerRadius(10)
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
                .padding()
                .padding(.top, 24)
                
                if viewModel.isLoginMode {
                    HStack {
                        Button("Восстановить пароль") {
                            Task { await handlePasswordRecovery() }
                        }
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(Color.grayBackground)
            .navigationBarHidden(true)
            .alert("Ошибка", isPresented: $showAlert) {
                Button("Ок", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}

private extension AuthView {
    
    func handleAuthAction() {
        viewModel.validateForm()
        
        Task {
            let result: Result<Bool, Error>
            if viewModel.isLoginMode {
                result = await viewModel.login()
            } else {
                result = await viewModel.register()
            }
            await handleAuthResult(result)
            if case .success(true) = result {
                await MainActor.run {
                                dismiss()
                }
            }
            
        }
    }
    
    func handlePasswordRecovery() async {
        let result = await viewModel.resetPassword()
        await handleAuthResult(result)
    }
    
    @MainActor
    func handleAuthResult(_ result: Result<Bool, Error>) async {
        switch result {
        case .success:
            dismiss()
        case .failure(let error):
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}

#Preview {
    AuthView()
}
