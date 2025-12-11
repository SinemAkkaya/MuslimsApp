import SwiftUI
import Adhan

// Burası BEDEN kısmı. Görüntüyü çizer.
// DİKKAT: Başında 'struct' yazar.
struct HomeView: View {
    // Beyni (ViewModel) burada çağırıyoruz
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. ARKA PLAN
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 2. ÜST BİLGİ ALANI
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Ankara, TR")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text(Date(), format: .dateTime.day().month().year())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("|")
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text(Date().toHijriString(language: Locale.current.identifier))
                                    .font(.subheadline)
                                    .foregroundColor(.indigo)
                            }
                        }
                        Spacer()
                        Image(systemName: "bell.badge.fill")
                            .foregroundStyle(.indigo)
                    }
                    .padding(.horizontal)
                    
                    // 3. VAKİT KARTI (Veriyi ViewModel'den alacak)
                    PrayerCardView(viewModel: viewModel)
                    
                    
                    // 3. --- YENİ: VAKİT LİSTESİ ---
                    VStack(spacing: 0) {
                        ForEach(viewModel.prayersList) { prayer in
                            HStack {
                                // İkon ve İsim
                                Image(systemName: prayer.icon)
                                    .foregroundColor(prayer.isNext ? .indigo : .gray)
                                    .frame(width: 24)
                                
                                Text(LocalizedStringKey(prayer.name))
                                    .font(.system(size: 16, weight: prayer.isNext ? .bold : .regular))
                                    .foregroundColor(prayer.isNext ? .primary : .secondary)
                                
                                Spacer()
                                
                                // Saat
                                Text(prayer.time)
                                    .font(.system(size: 16, weight: prayer.isNext ? .bold : .regular))
                                    .foregroundColor(prayer.isNext ? .indigo : .secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        // Sıradaki vaktin arkasına hafif renk atalım
                                        prayer.isNext ? Color.indigo.opacity(0.1) : Color.clear
                                    )
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            
                            // Satır arasına çizgi (Sonuncu hariç)
                            if prayer.id != viewModel.prayersList.last?.id {
                                Divider().padding(.leading, 50)
                            }
                        }
                    }
                    .background(Color.white) // Kart gibi beyaz zemin
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    
                    
                    
                    
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

// KART TASARIMI
struct PrayerCardView: View {
    // Veriyi üstten alıyor
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            HStack {
                Spacer()
                Image(systemName: "moon.stars.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.1)
                    .offset(x: 20, y: 20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(spacing: 10) {
                Text("next_prayer_title")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
                // ARTIK CANLI VERİ!
                Text(LocalizedStringKey(viewModel.nextPrayerName))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "timer")
                    Text(viewModel.timeLeft) // <-- Artık saniye saniye akan süreyi gösterecek
                            .contentTransition(.numericText()) // Rakamlar değişirken güzel animasyon olsun
                }
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 5)
            }
            .padding()
        }
        .frame(height: 200)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environment(\.locale, .init(identifier: "tr"))
}
