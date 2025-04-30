//
//  ViewExtension.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 30/04/2025.
//
import SwiftUI

extension View {
    func fullScreenCover<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.sheet(isPresented: isPresented) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .edgesIgnoringSafeArea(.all)
        }
    }
}
