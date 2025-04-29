////
////  HandBalanceView.swift
////  Keylapp
////
////  Created by admin on 29/04/2025.
////
//// HandBalanceView.swift
//import SwiftUI
//
//struct HandBalanceView: View {
//    let lhPercent: Double
//    let rhPercent: Double
//    
//    var body: some View {
//        GeometryReader { geometry in
//            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(width: geometry.size.width * CGFloat(lhPercent / 100))
//                
//                Rectangle()
//                    .fill(Color.red)
//                    .frame(width: geometry.size.width * CGFloat(rhPercent / 100))
//            }
//            .cornerRadius(8)
//            .overlay(
//                HStack {
//                    Text("LH: \(lhPercent, specifier: "%.1f")%")
//                        .foregroundColor(.white)
//                        .padding(.leading, 8)
//                    Spacer()
//                    Text("RH: \(rhPercent, specifier: "%.1f")%")
//                        .foregroundColor(.white)
//                        .padding(.trailing, 8)
//                }
//            )
//        }
//    }
//}
//
//struct KeyboardVisualizationView: View {
//    let keys: [[String]]
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            ForEach(keys.indices, id: \.self) { rowIndex in
//                HStack(spacing: 4) {
//                    ForEach(keys[rowIndex].indices, id: \.self) { keyIndex in
//                        Text(keys[rowIndex][keyIndex])
//                            .font(.system(size: 14, weight: .bold))
//                            .frame(width: 24, height: 24)
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(4)
//                    }
//                }
//            }
//        }
//    }
//}
