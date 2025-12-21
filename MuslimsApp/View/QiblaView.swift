import SwiftUI

struct QiblaView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Sistemden Pusula ikonunu çekiyoruz
            Image(systemName: "safari.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .opacity(0.5)
            
            Text("Kıble Pusulası")
                .font(.title2)
                .bold()
            
            Text("Çok yakında burada...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Kendimize not bırakalım (TODO)
            // TODO: CoreLocation ve CoreMotion entegre edilecek.
        }
        .padding()
    }
}

#Preview {
    QiblaView()
}
