//
//  HomeView.swift
//  MuslimsApp
//
//  Created by Sinem Akkaya on 11.12.2025.
//

import SwiftUI

struct QiblaView: View {
            var body: some View {
                ZStack {
                    Color.orange.opacity(0.1) // Ayırt etmek için hafif renk
                        .ignoresSafeArea()
                    
                    Text("Kıble Sayfası Buraya Gelecek")
                }
            }
        }
    
#Preview {
    QiblaView()
}
