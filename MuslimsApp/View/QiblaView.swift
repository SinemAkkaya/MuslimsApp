import SwiftUI
import CoreLocation
import Adhan

struct QiblaView: View {
    @StateObject var compassManager = CompassManager()
    @StateObject var locationManager = LocationManager()
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
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
                    
                    //Hesaplamalarımız:
                    let qiblaAngle = getQiblaDirection(at: userLocation.coordinate)
                    let currentHeading = compassManager.heading
                    
                    //Dönüş açısı hesaplamaları (kabe-telefon yönü)
                    let rotation = qiblaAngle - currentHeading
                    
                    //hizalama kontrolü
                    let isAligned = abs(rotation) < 10
                    
                    ZStack {
                        
                        //Dış çember
                        Circle()
                            .stroke(isAligned ? Color.green : Color.gray.opacity(0.3)
                                    , lineWidth: 10)
                            .frame(width: 300, height: 300)
                            .shadow(color: isAligned ? .green : .clear, radius: 20)
                        
                        
                        //pusula tabanı
                        Image(systemName: "safari.fill")
                            .resizable()
                            .foregroundColor(.white.opacity(0.2))
                            .frame(width: 280, height: 280)
                        
                        // dönen ok
                        VStack{
                            Image(systemName: "location.north.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                            //hizalanana kadar sarı, doğru hizaya gelince yeşil olsun
                                .foregroundColor(isAligned ? .green : .yellow)
                                .shadow(color: isAligned ? .green : .yellow, radius: 10)
                            Spacer().frame(height: 200)
                        }
                        .rotationEffect(.degrees(rotation))
                        .animation(.easeInOut(duration: 0.2), value: rotation)
                        // ----- Titreşim -----
                        .onChange(of: isAligned) { newValue in
                            if newValue == true {
                                feedbackGenerator.impactOccurred()
                                print("Kabe Bulundu 🕋")
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text(locationManager.city)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(isAligned ? "Kabe Karşınızda! 🕋" : "Kabe Açısı: \(Int(qiblaAngle))°")
                            .font(.headline)
                            .foregroundColor(isAligned ? .green : .gray)
                    }
                    .padding(.bottom, 50)
                    
                } else {
                    ProgressView().tint(.white)
                }
            }
        }
    }
    
    // Mat Fonksiyonu
        func getQiblaDirection(at coordinate: CLLocationCoordinate2D) -> Double {
            let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let qibla = Qibla(coordinates: coordinates)
            return qibla.direction
        }
    }

    #Preview {
        QiblaView()
    }
