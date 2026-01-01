import SwiftUI

struct MainTabView: View {
    // Seçili sekmeyi takip etmek için
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. Ana Sayfa (MainTabView DEĞİL, HomeView olacak!)
            HomeView() // ✅ DOĞRUSU BU!
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
                .tag(0)
            
            // 2. Kıble Sayfası
            QiblaView() // ✅ Yorum satırından çıkardık
                .tabItem {
                    Label("Kıble", systemImage: "safari.fill")
                }
                .tag(1)
            
            // 3. Ayarlar
            Text("Ayarlar Sayfası")
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        // Menü rengini belirgin yapalım
        .accentColor(.indigo)
    }
}

#Preview {
    MainTabView()
}
