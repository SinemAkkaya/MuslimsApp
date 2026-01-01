import SwiftUI
import CoreLocation
import Adhan // Kabe açısını hesaplamak için şart!

struct QiblaView: View {
    
    // 1. Pusula yöneticimizi çağırıyoruz (Telefonun yönünü dinlemek için)
    @StateObject var compassManager = CompassManager()
    
    // 2. Konum yöneticimizi çağırıyoruz (Nerede olduğumuzu bilmek için)
    // Not: Normalde bunu HomeView'dan da alabilirdik ama şimdilik basit olsun diye yeni açtık.
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            // Başlık
            Text("Kıble Pusulası")
                .font(.title)
                .bold()
                .padding(.top, 50)
            
            if let userLocation = locationManager.userLocation {
                // Konum varsa hesaplamaları yap
                
                // A. Kabe'nin açısını hesapla (Adhan kütüphanesi sağ olsun)
                let qiblaAngle = getQiblaDirection(at: userLocation.coordinate)
                
                // B. Pusulanın dönmesi gereken açıyı bul
                // (Kabe Açısı - Telefonun Baktığı Yön)
                let rotation = qiblaAngle - compassManager.heading
                
                Spacer()
                
                ZStack {
                    // 1. Pusula Kadranı (Sabit durur veya süs olarak döner)
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    // 2. Kabe İkonu (Kabe'nin olduğu yönü gösterir)
                    // Bu ikon sürekli Kabe'yi gösterecek şekilde dönecek
                    VStack {
                        Image(systemName: "location.north.circle.fill") // Ok işareti
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.indigo) // Kabe yönü rengi
                        
                        Text("Kabe")
                            .font(.caption)
                            .bold()
                            .padding(.top, 5)
                    }
                    .rotationEffect(.degrees(rotation)) // ✨ İŞTE SİHİR BURADA!
                    .animation(.easeInOut, value: rotation) // Yumuşak dönsün
                }
                
                Spacer()
                
                // Bilgi Kartı
                VStack(spacing: 10) {
                    Text("Şehir: \(locationManager.city)")
                        .font(.headline)
                    
                    Text("Kıble Açısı: \(Int(qiblaAngle))°")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 50)
                
            } else {
                // Konum yoksa uyarı göster
                VStack {
                    Spacer()
                    ProgressView()
                    Text("Konum bekleniyor...")
                        .padding(.top)
                    Spacer()
                }
            }
        }
    }
    
    // Yardımcı Fonksiyon: Adhan kütüphanesini kullanarak Kabe açısını bulur
    func getQiblaDirection(at coordinate: CLLocationCoordinate2D) -> Double {
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let qibla = Qibla(coordinates: coordinates)
        return qibla.direction // Bize derece cinsinden yönü verir (Örn: 165.4)
    }
}

#Preview {
    QiblaView()
}
