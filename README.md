# ArchiLens 📐

ArchiLens, gelişmiş artırılmış gerçeklik (AR) teknolojisini kullanarak milimetrik hassasiyette ölçüm yapmanızı sağlayan profesyonel bir iOS uygulamasıdır. LIDAR ve gelişmiş Raycasting algoritmaları ile donatılmış olan ArchiLens, kararlı ve güvenilir sonuçlar sunar.

## ✨ Yeni Nesil Özellikler

- **Gelişmiş Hassasiyet:** LIDAR mesh verisi ve gerçek zamanlı geometri analizi ile milimetrik doğruluk.
- **Dinamik Ölçüm:** İki veya daha fazla nokta arasında canlı mesafe takibi. İlk noktayı koyduğunuz an ölçüm başlar.
- **Hibrit Takip Sistemi:** 
  - 🟢 **Mesh/Geometry:** En yüksek hassasiyet (LIDAR destekli).
  - 🔵 **Plane Detection:** Algılanan yüzeyler üzerinde kararlı ölçüm.
  - 🟠 **Estimated Surface:** Düşük dokulu alanlarda akıllı tahminleme.
- **Adaptif Yumuşatma (Smoothing):** Ölçümlerdeki titremeyi engelleyen, hareket hızına duyarlı düşük geçirgenli filtre (Low-pass Filter).
- **Görsel Geri Bildirim:** Yüzey durumuna göre renk değiştiren akıllı imleç (Reticle) sistemi.
- **AR Coaching Overlay:** Kararlı bir deneyim için resmi Apple AR yönlendirmeleri.

## 🛠 Teknik Detaylar

- **Framework:** SwiftUI & RealityKit
- **Motor:** ARKit 6.0+
- **Matematik:** SIMD tabanlı yüksek hızlı vektör hesaplamaları
- **Minimum iOS:** 15.0+

## 🚀 Başlangıç

1. Projeyi Xcode ile açın.
2. Uygulamayı bir iPhone veya iPad üzerinde çalıştırın (Simülatör AR özelliklerini desteklemez).
3. Ekranda yüzeyleri tarayın (Coaching Overlay sizi yönlendirecektir).
4. İmleç yeşil veya mavi olduğunda **"+"** butonu ile ilk noktanızı koyun.
5. İmleci hareket ettirerek canlı mesafeyi görün ve istediğiniz noktada tekrar **"+"** butonuna basın.

---
*Geliştiren: Gorkem Ege*
