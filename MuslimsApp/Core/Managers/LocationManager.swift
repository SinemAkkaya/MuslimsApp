import Foundation
import CoreLocation
import Combine

// NSObject: CoreLocation ile konuşabilmem için gerekiyor
// ObservableObject: Konum değişince ekranı uyarabilmek için gerekiyor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Konum yöneticisi (Apple'ın servisi bu)
    private let manager = CLLocationManager()
    
    // Yayınlayacağımız veriler (View bunları dinleyecek)
    @Published var userLocation: CLLocation? // Enlem-Boylam
    @Published var city: String = "Konum aranıyor..." // Şehir ismi
    
    override init() {
        super.init()
        manager.delegate = self // "Olanları bana bildir" diyorum
        manager.desiredAccuracy = kCLLocationAccuracyBest // En iyi hassasiyet bu
        
        // Uygulama açılınca hemen izin iste
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // MARK: - Core Location Delegate (Olaylar Buraya Düşer)
    
    // 1. Konum güncellendiğinde burası çalışır
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.userLocation = location
        // Konumu buldum, şimdi şehir ismini bulayım onun iiçin bu kısım gerekli buna da Reverse Geocoding denir
        reverseGeocode(location: location)
        
        // Pil ömrünü korumak için konumu bulduktan sonra durdurabiliriz bu iyi bir şey
        // (Namaz vakti için anlık takibe gerek yok, tek sefer yeterli)
        manager.stopUpdatingLocation()
    }
    
    // 2. İzin durumu değişirse burası çalışır (İzin verdi mi reddetti mi?)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Konum izni reddedildi.")
            self.city = "Konum İzni Yok"
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    // 3. Şehir İsmini Bulma (Reverse Geocoding)
    
    private func reverseGeocode(location: CLLocation) {
        //bu özellik gelecekte kalkabilirmiş bu yüzden devamlı güncellemem önemli
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let _ = error { return }
          
            guard let placemark = placemarks?.first else { return }
            
            // Şehir veya İlçe ismini al
            let cityName = placemark.administrativeArea ?? placemark.locality ?? "Bilinmiyor"
            let countryCode = placemark.isoCountryCode ?? "TR"
            
            // UI güncellemeleri ana thread'de yapılmalı
            DispatchQueue.main.async {
                self?.city = "\(cityName), \(countryCode)"
            }
        }
    }
}
