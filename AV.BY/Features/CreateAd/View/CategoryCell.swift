//
//  CategoryCell.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct CategoryCell: View {
    
    let category: Category
    
    var body: some View {
        NavigationLink(destination: AdCarView()) {
            HStack {
                Image(category.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading) {
                    Text(category.title)
                        .foregroundStyle(.primary)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 4)
                    if let description = category.description {
                        Text(description)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 14))
                    }
                }
                .padding(.vertical, 12)
                Spacer()
            }
        }
        .labelsHidden()
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}
