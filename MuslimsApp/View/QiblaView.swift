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
