//
//  AdCarViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 10.11.25.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class AdCarViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedBrand: String = ""
    @Published var selectedModel: String = ""
    @Published var selectedYear: String = ""
    @Published var vin: String = ""
    @Published var mileageValue: String = ""
    @Published var mileageUnit: String = "км"
    @Published var selectedState: String = StateAuto.none.rawValue
    @Published var color: String = ""
    @Published var description: String = ""
    @Published var currency: String = "USD"
    @Published var price: String = ""
    @Published var swapType: String = "Не интересует"
    @Published var isConfirm: Bool = false
    
    // MARK: - Image Properties
    @Published var selectedImages: [UIImage] = []
    @Published var imageURLs: [String] = []
    @Published var isUploadingImages: Bool = false
    @Published var isPublishing: Bool = false
    
    // MARK: - UI States
    @Published var error: String?
    @Published var success: Bool = false
    
    private let carService = CarService.shared
    private let authManager = AuthManager()
    private let imageUploadService = ImageUploadService()
    
    // MARK: - Validation
    var isFormValid: Bool {
        !selectedBrand.isEmpty &&
        !selectedModel.isEmpty &&
        !selectedYear.isEmpty && 
        !price.isEmpty &&
        isConfirm
       // !selectedImages.isEmpty
    }
    
    var formattedPrice: Double? {
        guard let priceValue = Double(price) else { return nil }
        return priceValue
    }
    
    var formattedYear: Int? {
        return Int(selectedYear)
    }
    
    // MARK: - Image Methods
    func addImages(_ images: [UIImage]) {
        selectedImages.append(contentsOf: images)
    }
    
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    // MARK: - Upload Methods
    func uploadImages() async throws -> [String] {
        isUploadingImages = true
        defer { isUploadingImages = false }
        
        var uploadedURLs: [String] = []
        
        for image in selectedImages {
            do {
                let url = try await imageUploadService.uploadImage(image)
                uploadedURLs.append(url)
            } catch {
                throw AdCarError.imageUploadFailed
            }
        }
        
        return uploadedURLs
    }
    
    func publishAd() async throws {
        guard isFormValid else {
            throw AdCarError.invalidForm
        }
        
        guard let userId = authManager.currentUser?.uid else {
            throw AdCarError.unauthorized
        }
        
        guard let priceValue = formattedPrice,
              let yearValue = formattedYear else {
            throw AdCarError.invalidData
        }
        
        isPublishing = true
        error = nil
        
        do {
            // 1. Загружаем изображения
            let imageURLs = try await uploadImages()
            
            // 2. Создаем данные автомобиля
            let carData = CarCreateData(
                brand: selectedBrand,
                model: selectedModel,
                year: yearValue,
                price: priceValue,
                description: description,
                imageURLs: imageURLs
            )
            
            // 3. Публикуем объявление
            let _ = try await carService.addNewCar(carData, ownerId: userId)
            
            // 4. Успех
            await MainActor.run {
                success = true
                resetForm()
            }
            
        } catch {
            self.error = error.localizedDescription
            throw error
        }
        
        isPublishing = false
    }
    
    func resetForm() {
        selectedBrand = ""
        selectedModel = ""
        selectedYear = ""
        vin = ""
        mileageValue = ""
        mileageUnit = "км"
        selectedState = StateAuto.none.rawValue
        color = ""
        description = ""
        currency = "USD"
        price = ""
        swapType = "Не интересует"
        isConfirm = false
        selectedImages.removeAll()
        imageURLs.removeAll()
    }
}

// MARK: - Errors


// MARK: - Image Upload Service
class ImageUploadService {
    func uploadImage(_ image: UIImage) async throws -> String {
        // Здесь должна быть реализация загрузки изображений
        // Например, в Firebase Storage или другой сервис
        
        // Временная заглушка - возвращаем fake URL
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда задержки
        
        return "https://example.com/car_\(UUID().uuidString).jpg"
    }
}

