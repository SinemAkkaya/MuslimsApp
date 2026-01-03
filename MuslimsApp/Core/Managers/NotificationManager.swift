import Foundation
import UserNotifications//Bildirim kütüphanemiz
import Combine //bunu unuttuğum için iki saat nereyi yanlış yazdım diye uğraştım bunu demezsem xcode @Published ne demek bilmez :P

//Bildirimleri Yönetecek Sınıf
class NotificationManager: ObservableObject {
    // Singleton yani bu sınıftan sadece 1 tane var
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    @Published var isGranted: Bool = false //Kullanıcı izin verdi mi?
    
    init() {
        checkPermissionStatus()
        
    }
    
    //kullanıcıdan izin iste
        func requestAuthorization() {
            center.requestAuthorization(options: [.alert, .sound, .badge] ) { granted, error in
            if let error = error {
                print("Hata Oluştu: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.isGranted = granted
                if granted{
                    print("İzin Alındı")
                } else {
                    print("İzin Reddedildi")
                }
            }
        }
        
    }

func checkPermissionStatus() {
    center.getNotificationSettings { settings in
        DispatchQueue.main.async {
            self.isGranted = (settings.authorizationStatus == .authorized)
        }
    }
    }
}
