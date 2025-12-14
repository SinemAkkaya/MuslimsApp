import Foundation
import Combine
import Adhan
import CoreLocation

class HomeViewModel: ObservableObject {
    
    @Published var nextPrayerName: String = "--"
    @Published var nextPrayerTime: String = "--:--"
    @Published var timeLeft: String = "..."
    @Published var city: String = "Konum Bekleniyor..." // YENİ: Şehir ismi
    @Published var prayersList: [PrayerRowData] = []
    
    // Konum Yöneticisi ve Abonelik Kutusu
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var nextPrayer: Prayer?
    private var timer: AnyCancellable?
    
    init() {
        startTimer()
        setupLocationSubscriber() // Konumu dinlemeye başla
    }
    
    // KONUMU DİNLEYEN FONKSİYON
    func setupLocationSubscriber() {
        // 1. Koordinat gelince ne yapayım?
        locationManager.$userLocation
            .compactMap { $0 } // (Boş veri gelirse yoksay)
            .sink { [weak self] location in
                // Koordinat değiştiği an namaz vaktini tekrar hesapla!
                self?.updatePrayerData(coordinate: location.coordinate)
            }
            .store(in: &cancellables)
        
        // 2. Şehir ismi gelince ne yapayım?
        locationManager.$city
            .assign(to: \.city, on: self)
            .store(in: &cancellables)
    }
    
    // Artık koordinatı dışarıdan alıyoruz
    func updatePrayerData(coordinate: CLLocationCoordinate2D) {
        // Koordinatları Adhan kütüphanesine uygun hale getirmesini sağladım
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Tarih ve Hesaplama parametreleri bu rada! !
        let params = CalculationMethod.turkey.params
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        guard let prayers = PrayerTimes(coordinates: coordinates, date: dateComponents, calculationParameters: params) else { return }
        
      
        let next = prayers.nextPrayer() ?? .fajr
        self.nextPrayer = prayers.currentPrayer(at: Date()) == nil ? .fajr : next
        
        self.nextPrayerName = getPrayerName(prayer: next)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = prayers.time(for: next)
        self.nextPrayerTime = formatter.string(from: time)
        
        // Listeyi Doldur
        let allPrayers: [Prayer] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
        self.prayersList = allPrayers.map { prayer in
            let pTime = prayers.time(for: prayer)
            let isNext = (prayer == next)
            
            return PrayerRowData(
                name: getPrayerName(prayer: prayer),
                time: formatter.string(from: pTime),
                icon: getIcon(prayer: prayer),
                isNext: isNext
            )
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    func updateCountdown() {
        // Hesaplama için son kullanılan koordinat lazım ama şimdilik Timer sadece görseli güncelliyor
    }
    
    func getPrayerName(prayer: Prayer) -> String {
        switch prayer {
        case .fajr: return "prayer_fajr"
        case .sunrise: return "prayer_sunrise"
        case .dhuhr: return "prayer_dhuhr"
        case .asr: return "prayer_asr"
        case .maghrib: return "prayer_maghrib"
        case .isha: return "prayer_isha"
        }
    }
    
    func getIcon(prayer: Prayer) -> String {
        switch prayer {
        case .fajr: return "sun.haze.fill"
        case .sunrise: return "sunrise.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "sunset.fill"
        case .isha: return "moon.stars.fill"
        }
    }
}

struct PrayerRowData: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    let icon: String
    let isNext: Bool
}
