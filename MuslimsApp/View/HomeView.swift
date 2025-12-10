import SwiftUI
import Adhan

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. ARKA PLAN
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 2. ÜST BİLGİ ALANI (Tarih ve Şehir)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("İstanbul, TR")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            // TARİH ALANI (Miladi + Hicri)
                            HStack {
                                // Miladi (Telefondan otomatik)
                                Text(Date(), format: .dateTime.day().month().year())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("|")
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                // Hicri (Bizim Extension'dan)
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
                    
                    // 3. VAKİT KARTI (İşte burası kaybolmuştu!)
                    PrayerCardView()
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

// --- ALT BİLEŞENLER (Kart Tasarımı) ---

struct PrayerCardView: View {
    var body: some View {
        ZStack {
            // Kartın Arka Planı
            LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Kartın Üzerindeki Desen
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
            
            // Kartın İçindeki Yazılar
            VStack(spacing: 10) {
                Text("next_prayer_title")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("İkindi")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "timer")
                    Text("01:24:50")
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
        // Dili buradan değiştirip test edebilirsin: "tr", "en", "ar"
        .environment(\.locale, .init(identifier: "tr"))
}
