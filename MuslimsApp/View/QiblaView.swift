import SwiftUI
import CoreLocation
import Adhan

struct QiblaView: View {
    @StateObject var compassManager = CompassManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
           
            LinearGradient(colors: [Color.black.opacity(0.8), Color.indigo.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
               
                Text("Kıble Bulucu")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                if let userLocation = locationManager.userLocation {
                    let qiblaAngle = getQiblaDirection(at: userLocation.coordinate)
                   
                    let rotation = qiblaAngle - compassManager.heading
            
                    ZStack {
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                            .frame(width: 300, height: 300)
                        
                        // İç Çember (Kadran)
                        Image(systemName: "safari.fill") // Pusula ikonu
                            .resizable()
                            .foregroundColor(.white.opacity(0.2))
                            .frame(width: 280, height: 280)
                        
                        
                        VStack {
                            
                            Image(systemName: "location.north.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.yellow) // Altın sarısı ok
                                .shadow(color: .yellow, radius: 10) // Parlama efekti
                            
                            Spacer()
                                .frame(height: 200) // Oku merkezin dışına itmek için boşluk
                        }
                        .rotationEffect(.degrees(rotation)) // DÖNME HAREKETİ
                        .animation(.easeInOut(duration: 0.2), value: rotation)
                    }
                    
                    Spacer()
                    
             
                    VStack(spacing: 5) {
                        Text(locationManager.city)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Kabe Açısı: \(Int(qiblaAngle))°")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 50)
                    
                } else {
  
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    func getQiblaDirection(at coordinate: CLLocationCoordinate2D) -> Double {
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let qibla = Qibla(coordinates: coordinates)
        return qibla.direction
    }
}

#Preview {
    QiblaView()
}
