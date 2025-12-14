import Foundation

extension Date {
    // 1. Hicri Takvime Çeviren Fonksiyonum bu
    func toHijriString(language: String = "tr") -> String {
        // Suudi Arabistan (Umm al-Qura) takvimi en yaygın standart buymuş
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        let formatter = DateFormatter()
        formatter.calendar = hijriCalendar
        formatter.dateFormat = "dd MMMM yyyy"
        
        // Dili dışarıdan alacağım ki Preview'da test edebileyim
        formatter.locale = Locale(identifier: language)
        
        return formatter.string(from: self)
    }
}
