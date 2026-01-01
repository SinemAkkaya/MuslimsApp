import Foundation
import Combine
import Adhan
import CoreLocation

class HomeViewModel: ObservableObject {
    
    @Published var nextPrayerName: String = "--"
    @Published var nextPrayerTime: String = "--:--"
    @Published var timeLeft: String = "Hesaplanıyor..."
    @Published var city: String = "Konum Bekleniyor..."
    @Published var prayersList: [PrayerRowData] = []
    
    // Konum ve Zamanlayıcı Araçları
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    // Hesaplama için tarih hafızası
    private var nextPrayerDate: Date?
    
    init() {
        startTimer()
        setupLocationSubscriber()
    }
    
    func setupLocationSubscriber() {
        locationManager.$userLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.updatePrayerData(coordinate: location.coordinate)
            }
            .store(in: &cancellables)
        
        locationManager.$city
            .assign(to: \.city, on: self)
            .store(in: &cancellables)
    }
    
    
    func updatePrayerData(coordinate: CLLocationCoordinate2D) {
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let params = CalculationMethod.turkey.params
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        guard let prayers = PrayerTimes(coordinates: coordinates, date: dateComponents, calculationParameters: params) else { return }
        
        // Bir sonraki vakti bul
        let next = prayers.nextPrayer() ?? .fajr
        let current = prayers.currentPrayer(at: Date())
        
        // Yatsıdan sonra (current == isha) bir sonraki vakit sabah namazıdır (fajr)
        let nextPrayerType = (current == nil || current == .isha) ? .fajr : next
        
        // Hedef saati al
        var targetDate = prayers.time(for: nextPrayerType)
        
        // DÜZELTME:
        // Eğer hedef saat şu andan küçükse (yani geçmişteyse),
        // bu demektir ki o vakit YARININ vaktidir.
        // Örn: Şu an saat 22:00, İmsak 06:00. Kod bunu "Bu sabahın 06:00'sı" sanıyor.
        // Biz ona "Hayır, 1 gün ekle" diyoruz.
        if targetDate < Date() {
            targetDate = targetDate.addingTimeInterval(86400) // 24 Saat ekle (Saniye cinsinden)
        }
        
        self.nextPrayerDate = targetDate
        
        // İsim ve Saat Güncellemesi
        self.nextPrayerName = getPrayerName(prayer: nextPrayerType)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.nextPrayerTime = formatter.string(from: targetDate) // targetDate kullanıyoruz
        
        // Listeyi Doldur
        let allPrayers: [Prayer] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
        self.prayersList = allPrayers.map { prayer in
            let time = prayers.time(for: prayer)
            return PrayerRowData(
                name: getPrayerName(prayer: prayer),
                time: formatter.string(from: time),
                icon: getIcon(prayer: prayer),
                isNext: (prayer == nextPrayerType)
            )
        }
        
        // Geri sayımı hemen tetikle
        updateCountdown()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    func updateCountdown() {
        guard let targetDate = nextPrayerDate else { return }
        
        let diff = targetDate.timeIntervalSince(Date())
        
        if diff > 0 {
            let hours = Int(diff) / 3600
            let minutes = (Int(diff) % 3600) / 60
            let seconds = Int(diff) % 60
            self.timeLeft = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            // Eğer süre bittiyse (0 olduysa), hemen verileri yenile ki
            // "Vakit Girdi" yazmasın, sıradaki vakte geçsin.
            if let loc = locationManager.userLocation {
                updatePrayerData(coordinate: loc.coordinate)
            }
        }
    }
    
    func getPrayerName(prayer: Prayer) -> String {
        switch prayer {
        case .fajr: return "İmsak"
        case .sunrise: return "Güneş"
        case .dhuhr: return "Öğle"
        case .asr: return "İkindi"
        case .maghrib: return "Akşam"
        case .isha: return "Yatsı"
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
