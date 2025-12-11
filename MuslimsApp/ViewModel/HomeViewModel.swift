import Foundation
import Combine
import Adhan

// Listede göstereceğimiz her bir satırın modeli
struct PrayerRowData: Identifiable {
    let id = UUID()
    let name: String // "prayer_fajr" gibi anahtar
    let time: String // "05:12"
    let icon: String // "sun.max.fill" gibi
    let isNext: Bool // Sıradaki vakit bu mu? (Renklendirmek için)
}

class HomeViewModel: ObservableObject {
    
    @Published var nextPrayerName: String = "--"
    @Published var nextPrayerTime: String = "--:--"
    @Published var timeLeft: String = "..."
    
    // YENİ: Listeyi tutacak olan değişken
    @Published var prayersList: [PrayerRowData] = []
    
    private var nextPrayer: Prayer?
    private var timer: AnyCancellable?
    
    init() {
        updatePrayerData()
        startTimer()
    }
    
    func updatePrayerData() {
        guard let prayers = PrayerManager.shared.getPrayerTimes() else { return }
        
        let next = prayers.nextPrayer() ?? .fajr
        self.nextPrayer = prayers.currentPrayer(at: Date()) == nil ? .fajr : next
        
        self.nextPrayerName = getPrayerName(prayer: next)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = prayers.time(for: next)
        self.nextPrayerTime = formatter.string(from: time)
        
        // --- YENİ: LİSTEYİ DOLDURMA KISMI ---
        // Tüm vakitleri sırayla dönüp listemize ekliyoruz
        let allPrayers: [Prayer] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
        
        self.prayersList = allPrayers.map { prayer in
            let pTime = prayers.time(for: prayer)
            let isNext = (prayer == next) // Bu vakit sıradaki mi?
            
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
        guard let prayerTime = PrayerManager.shared.getPrayerTimes()?.time(for: nextPrayer ?? .fajr) else { return }
        let now = Date()
        let diff = prayerTime.timeIntervalSince(now)
        
        if diff > 0 {
            let hours = Int(diff) / 3600
            let minutes = (Int(diff) % 3600) / 60
            let seconds = Int(diff) % 60
            self.timeLeft = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.timeLeft = "00:00:00"
            updatePrayerData()
        }
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
    
    // YENİ: Vakte göre ikon seçimi
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
