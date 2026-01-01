import Foundation
import CoreLocation
import Combine

// Bu sınıfın görevi: Telefonun uzaydaki yönünü (Heading) dinlemek.
class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    // @Published: Telefonun ucu nereye bakıyor? (0 ile 360 derece arası)
    // View bunu dinleyecek ve resmi ona göre döndürecek.
    @Published var heading: Double = 0
    
    override init() {
        super.init()
        manager.delegate = self
        
        // Pusula kalibrasyonu (8 çizme hareketi) gerekirse iOS kendi uyarısını göstersin mi?
        manager.headingFilter = 1 // 1 derece bile oynasa haber ver (Hassas olsun)
        manager.headingOrientation = .portrait // Telefonu dik tutuyoruz varsayalım
        
        // Pusula sensörünü başlat
        manager.startUpdatingHeading()
    }
    
    // MARK: - Delegate Metodu (Sensörden Veri Gelince Burası Çalışır)
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        // trueHeading: Coğrafi Kuzey (Haritadaki gerçek kuzey) - GPS gerekir
        // magneticHeading: Manyetik Kuzey (Pusulanın gösterdiği)
        
        // Eğer GPS çekiyorsa Gerçek Kuzey'i kullan, çekmiyorsa Manyetik'i kullan
        let rotation = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        // UI titremesin diye animasyonlu geçişi View tarafında yapacağız,
        // burada ham veriyi gönderiyoruz.
        self.heading = rotation
    }
}
