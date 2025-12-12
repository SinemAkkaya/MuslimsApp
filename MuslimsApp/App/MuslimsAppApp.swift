import SwiftUI
import Adhan // bu adhan kütüphanesi önemli birisi bu vakitleri hesaplayıp bu kütüphanede toplamış bu yüzden projeme kattım

@main
struct MuslimsAppApp: App {
    
    // Uygulama ilk açıldığında çalışacak kod bloğu
    init() {
        print("🚀 UYGULAMA BAŞLATILIYOR...")
        
        if let prayers = PrayerManager.shared.getPrayerTimes() {
            print("----- NAMAZ VAKİTLERİ (İSTANBUL) -----")
            print("Sabah: \(prayers.fajr)")
            print("Güneş: \(prayers.sunrise)")
            print("Öğle: \(prayers.dhuhr)")
            print("İkindi: \(prayers.asr)")
            print("Akşam: \(prayers.maghrib)")
            print("Yatsı: \(prayers.isha)")
            print("--------------------------------------")
        } else {
            print("⚠️ Namaz vakitleri hesaplanamadı!")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
