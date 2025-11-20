//
//  UserAdCell.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct UserAdCell: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(car.brand) \(car.model)")
                        .font(.headline)
                    
                    Text("$\(car.price, specifier: "%.0f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(car.year) год")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("Активно")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }
            
            Text(car.description)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.secondary)
            
            HStack {
                Button("Редактировать") {
                }
                .font(.caption)
                .foregroundColor(.blue)
                
                Spacer()
                
                Button("Удалить") {
                }
                .font(.caption)
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
