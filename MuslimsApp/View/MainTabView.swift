import SwiftUI

struct MainTabView: View {
    // Seçili sekmeyi hafızada tutmak için State
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. Ana Sayfa Sekmesi
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("tab_home") // Localizable anahtar
                }
                .tag(0)
            
            // 2. Kur'an Sekmesi
            QuranView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("tab_quran")
                }
                .tag(1)
            
            // 3. Kıble Sekmesi
            QiblaView()
                .tabItem {
                    Image(systemName: "safari.fill") // Pusula ikonu
                    Text("tab_qibla")
                }
                .tag(2)
            
            // 4. Ayarlar Sekmesi
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("tab_settings")
                }
                .tag(3)
        }
        // Tab Bar'ın rengini belirginleştirelim
        .tint(.indigo)
    }
}

#Preview {
    // Hem Türkçe hem Arapça önizleme koydum, alt alta görebilirsin
    VStack {
        MainTabView()
            .environment(\.locale, .init(identifier: "tr"))
        
        MainTabView()
            .environment(\.locale, .init(identifier: "ar"))
    }
}
