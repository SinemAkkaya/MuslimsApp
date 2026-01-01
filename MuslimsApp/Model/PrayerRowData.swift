import Foundation

// Listede her bir namaz satırını temsil eden model
struct PrayerRowData: Identifiable {
    let id = UUID()        // Listede karışıklık olmasın diye her satıra kimlik veriyoruz
    let name: String       // Vakit adı (İmsak, Öğle vs.)
    let time: String       // Saat (06:33)
    let icon: String       // İkon ismi (sun.max.fill)
    let isNext: Bool       // Sırada bu vakit mi var? (Renklendirmek için)
}
