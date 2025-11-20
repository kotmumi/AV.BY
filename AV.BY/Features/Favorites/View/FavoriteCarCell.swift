//
//  FavoriteCarCell.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 19.11.25.
//

import SwiftUI

struct FavoriteCarCell: View {
    let car: Car
    @ObservedObject var viewModel: FavoritesViewModel
    @State private var isFavorite = false
    @State private var checkingFavorite = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("\(car.brand) \(car.model)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        
                        if checkingFavorite {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Button(action: {
                                viewModel.toggleFavorite(carId: car.id)
                                //isFavorite.toggle()
                            }) {
                                Image(systemName: "heart.fill" )
                                    .foregroundColor(.red )
                            }
                        }
                    }
                    Text("$\(car.price, specifier: "%.0f")")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            
            if let firstImageURL = car.imageURLs.first,
               let url = URL(string: firstImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(8)
                            .overlay(
                                ProgressView()
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(8)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Заглушка если нет изображений
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "car")
                            .foregroundColor(.gray)
                            .font(.system(size: 40))
                    )
            }
            
            HStack {
                Text("\(car.year) год")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Показываем количество изображений если их больше 1
                if car.imageURLs.count > 1 {
                    Text("\(car.imageURLs.count) фото")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Text(car.description)
                .font(.caption)
                .foregroundColor(.black)
                .lineLimit(2)
                .truncationMode(.tail)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
