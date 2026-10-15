# 🎯 Task & Habit Tracker

Günlük görevlerinizi yönetmenizi, alışkanlıklarınızı takip etmenizi ve kişisel verimliliğinizi artırmanızı sağlayan modern, göz yormayan ve yüksek performanslı bir Flutter mobil uygulaması.

---

## 🌟 Öne Çıkan Özellikler

- **Görev Yönetimi (Task Management):** Son tarih, açıklama ve öncelik seviyelerine (Düşük, Orta, Yüksek) göre görev oluşturma, tamamlama ve silme.
- **Alışkanlık Takibi (Habit Tracking):** Günlük alışkanlık döngüleri, seri (streak) takibi ve esnek zaman tabanlı hatırlatıcılar.
- **Akıllı Yerel Bildirimler:** Alışkanlık hatırlatıcıları için özelleştirilebilir yerel bildirim zamanlayıcısı (`flutter_local_notifications`).
- **Gelişmiş İstatistikler:** Görev ve alışkanlık tamamlama oranlarını görselleştiren dinamik grafikler.
- **Modern & Dinlendirici Tasarım (UI/UX):** Gözü yormayan Slate-Gri mat zemin (`#F1F5F9`), kavisli kart yapısı (`18px Radius`) ve dinamik Karanlık/Aydınlık tema desteği.

---

## 🛠 Kullanılan Teknolojiler ve Mimari Yapı

Uygulama, ölçeklenebilir ve sürdürülebilir **Clean Architecture (Feature-First MVVM)** prensiplerine uygun olarak geliştirilmiştir.

| Alan | Kullanılan Teknolojiler / Paketler | Açıklama |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.x / Dart 3.x | Çapraz platform mobil uygulama geliştirme framework'ü. |
| **State Management** | `flutter_riverpod` | Uygulama durum yönetimi için modern, reaktif ve test edilebilir Notifier mimarisi. |
| **Yerel Depolama** | `hive` & `hive_flutter` | Yüksek hızlı, anahtar-değer (Key-Value) tabanlı yerel NoSQL veritabanı. |
| **Bildirimler** | `flutter_local_notifications` | Cihaz seviyesinde zamanlanmış yerel hatırlatma bildirimleri. |
| **Tarih & Saat** | `intl` & `timezone` | Zaman dilimleri yönetimi ve Türkçe tarih formatlama. |
| **Tipografi & Stil** | `google_fonts` (Inter) | Modern ve okunabilir yazı tipi entegrasyonu. |

---

## 📁 Proje Klasör Yapısı

lib/
├── core/                   # Ortak sabitler, temalar ve genel bileşenler
│   ├── constants/          # AppColors vb. renk/boyut sabitleri
│   └── theme/              # AppTheme (Light & Dark tema yapılandırması)
├── data/                   # Veri katmanı (Models, Managers & Services)
│   ├── managers/           # TaskManager, HabitManager (Business Logic)
│   ├── models/             # TaskModel, HabitModel (Hive TypeAdapters)
│   └── services/           # LocalStorageService, NotificationService
├── presentation/           # Arayüz katmanı (Screens & Widgets)
│   ├── habit/              # Alışkanlıklar ekranı ve diyalogları
│   ├── home/               # Görevler ana ekranı ve kart bileşenleri
│   ├── main_wrapper/       # Navigasyon barı ve ekran geçişleri
│   ├── settings/           # Ayarlar ve tema tercihleri
│   └── stats/              # İstatistikler ve grafikler
└── providers/              # Riverpod uygulama sağlayıcıları (app_providers.dart)


---

## 🚀 Projeyi Yerelde Çalıştırma Rehberi

Projeyi klonlayan herhangi bir geliştirici aşağıdaki adımları izleyerek projeyi **sıfırdan ve sorunsuz şekilde** kendi bilgisayarında çalıştırabilir:

### Gereksinimler
- Flutter SDK (3.22.0 veya üzeri)
- Dart SDK
- Android Studio / VS Code (Flutter eklentisi ile)
- Bağlı bir Android/iOS emülatörü veya fiziksel cihaz

### Kurulum Adımları

1. **Repoyu Klonlayın:**
   ```bash
   git clone [https://github.com/KULLANICI_ADI/eterna_task_tracker.git](https://github.com/KULLANICI_ADI/eterna_task_tracker.git)
   cd eterna_task_tracker
Bağımlılıkları Yükleyin:

Bash
flutter pub get
Uygulamayı Çalıştırın:

Bash
flutter run
📱 Yerel Depolama Yapısı (Hive)
Uygulama, verilerin cihaz kapandığında bile kaybolmaması için Hive NoSQL veritabanını kullanır. Görevler ve alışkanlıklar JSON/TypeAdapter formatında cihaza güvenle kaydedilir.


---