import Foundation
import Adhan // Az önce indirdiğimiz kütüphaneyi çağırıyoruz!
import CoreLocation // Konum işlemleri için

class PrayerManager {
    
    // Singleton Yapısı: Uygulamanın her yerinden tek bir noktadan ulaşmak için
    static let shared = PrayerManager()
    
    // Şimdilik test için İstanbul'un koordinatlarını elle giriyoruz
    // İleride burayı kullanıcının gerçek GPS verisiyle değiştireceğiz
    let testCoordinates = Coordinates(latitude: 41.0082, longitude: 28.9784)
    
    func getPrayerTimes() -> PrayerTimes? {
        // 1. Hesaplama Parametreleri (Türkiye Diyanet İşleri standardı)
        var params = CalculationMethod.turkey.params
        params.madhab = .shafi // Türkiye geneli (Hanefi için de standart budur, ikindi değişmez)
        
        // 2. Tarih Bileşenleri (Bugün)
        let cal = Calendar(identifier: .gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        
        // 3. Hesapla!
        if let prayers = PrayerTimes(coordinates: testCoordinates, date: date, calculationParameters: params) {
            return prayers
        }
        
        return nil
    }
}
