import SwiftUI

struct QuranView: View {
            var body: some View {
                ZStack {
                    Color.orange.opacity(0.1) // Ayırt etmek için hafif renk
                        .ignoresSafeArea()
                    
                    Text("Kuran Sayfası Buraya Gelecek")
                }
            }
        }
    
#Preview {
    QuranView()
}
