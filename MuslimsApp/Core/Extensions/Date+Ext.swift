import Foundation

extension Date {
    // 1. Hicri Takvime Çeviren Fonksiyon
    func toHijriString(language: String = "tr") -> String {
        // Suudi Arabistan (Umm al-Qura) takvimi en yaygın standarttır
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        let formatter = DateFormatter()
        formatter.calendar = hijriCalendar
        formatter.dateFormat = "dd MMMM yyyy" // Örn: 14 Ramazan 1445
        
        // Dili dışarıdan alacağız ki Preview'da test edebilelim
        formatter.locale = Locale(identifier: language)
        
        return formatter.string(from: self)
    }
}
