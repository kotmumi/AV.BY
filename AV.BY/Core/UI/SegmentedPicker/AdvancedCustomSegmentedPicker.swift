//
//  AdvancedCustomSegmentedPicker.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 27.10.25.
//

import SwiftUI

struct AdvancedCustomSegmentedPicker: View {
    let options: [String]
    @Binding var selectedIndex: Int
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<options.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        // Text
                        Text(options[index])
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(selectedIndex == index ? .blue : .gray)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .contentShape(Rectangle())
                        
                        // Indicator
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 2)
                            
                            if selectedIndex == index {
                                Capsule()
                                    .fill(Color.blue)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "indicator", in: animation)
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedIndex = index
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(0)
    }
}
