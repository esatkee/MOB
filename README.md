# Diary+

Diary+, kullanıcıların günlüklerini kolayca oluşturup düzenleyebileceği, modern arayüze sahip bir Flutter uygulamasıdır. Firebase Authentication ile güvenli giriş, Supabase ile veri saklama ve güçlü tema yönetimiyle kullanıcı dostu bir deneyim sunar.

## Proje için örnek hesap bilgileri
- **Kullanıcı adı:** Efe  Kulahli
- **E-posta:** efekulahli@gmail.com
-  **Şifre:** 123456
## Projenin Amacı

Bu projenin temel amacı, kullanıcıların dijital günlüklerini güvenli ve erişilebilir bir şekilde saklayabileceği, modern ve kullanıcı dostu bir platform sunmaktır. Karanlık/açık tema, bildirimler ve profil yönetimi gibi özelliklerle kişiselleştirilebilir bir deneyim hedeflenmiştir.

## Teknik Detaylar

- **Flutter:** Uygulamanın temel geliştirme platformu.
- **Firebase:** Kullanıcı kimlik doğrulama (Authentication).
- **Supabase:** Günlük, kullanıcı ve profil verilerinin saklanması.
- **Provider:** Durum yönetimi için.
- **HTTP:** API istekleri ve veri alışverişi.

## Öne Çıkan Özellikler

- **Kullanıcı Girişi:** Firebase Authentication ile güvenli giriş.
- **Günlük Yönetimi:** Günlük oluşturma, düzenleme, silme.
- **Profil Yönetimi:** Kullanıcı bilgilerini güncelleme, profil fotoğrafı, doğum tarihi, şehir seçimi.
- **Tema Yönetimi:** Karanlık , açık ve diğer renkler arasında mod geçişi.
- **Bildirimler:** Uygulama içi bildirim ve ses/vibrasyon ayarları.
- **Responsive Tasarım:** Tüm cihazlarda uyumlu arayüz.
- **Supabase ile veri saklama:** Günlükler ve kullanıcı profilleri Supabase üzerinde tutulur.

## Kullanılan Teknolojiler

- Flutter
- Firebase (Authentication)
- Supabase (Veri tabanı)
- Provider (State Management)
- HTTP (API İstekleri)

## Geliştirici Notları
- Modülerlik için fonksiyonları ayırdık ve  google buton vb. tekrar kullandık
- Tekrar kullanılabilecek olan yazı boyutu renk vb gibi değişkenleri constants.dart ve texts.dart altında toplayarak pratiklik kazandık
- Shared preferences ile kullanıcı streak’ını lokal olarak tuttuk
- SqlLite veritabanı ile ayarları kaydettik
- Firebase ile e-posta, gmail, github ile hesap oluşturma ve giriş yapma seçeneklerini ekledik
- Supabase’e 3 adet tablo ile user diary ve province verilerini tuttuk ayrıca trigger ile sayısal olan gün verisini string olark pazartesi, salı gibi gün verilerine çevirdik
- Koddaki karmaşık satırların daha kolay anlaşılabilir olması için comment satırları ekledik
- Kodun okunabilirliğini arttırmak için 300 satırdan uzun kodlar parçalara ayrıldı
- Supabase’e eklenen  logo supabaseden çekilerek login ve register pagelerde kullanılmıştır

  
## Uygulama içi görüntüler
![image](https://github.com/user-attachments/assets/8862f786-3753-4185-b066-a7754a9677b9)


## Supabase örnek görüntüler
![image](https://github.com/user-attachments/assets/74e02393-a149-438d-91ac-b7dba7cd5092)


## Sayfaların Görevleri ve İçerikleri

### 1. Giriş Yap Ekranı (`login_page.dart`)
- Kullanıcı e-posta ve şifre ile giriş yapabilir.
- Google ile giriş desteği.
- Hatalı girişlerde kullanıcıya uyarı gösterilir.
- Modern ve kullanıcı dostu arayüz.
- Bu sayfa Esat Küçe tarafından yazılmıştır.
  
### 2. Kayıt Ol Ekranı (`register_page.dart`)
- Kullanıcı, e-posta ve şifre ile yeni hesap oluşturabilir.
- Google ile kayıt olma desteği.
- Şifre doğrulama özelliği.
- Başarılı kayıt sonrası ana sayfaya yönlendirme.
- Bu sayfa Esat Küçe  tarafından yazılmıştır.
  
### 3. Ana Sayfa (`home_page.dart`)
- Kullanıcının tüm günlükleri listelenir.
- Günlükler arasında arama ve filtreleme.
- Günlük detayına tıklayarak düzenleme veya silme.
- Yeni günlük eklemek için buton.
- Bu sayfa Muhammed Sait yıldırım  tarafından yazılmıştır.
### 4. Günlük Detay/Ekleme Ekranı (`diary_detail.dart`)
- Başlık ve içerik ile yeni günlük oluşturma.
- Mevcut günlükleri düzenleme veya silme.
- Kullanıcı dostu modal dialog ile not ekleme/düzenleme.
- Bu sayfa Esat Küçe  tarafından yazılmıştır.
### 5. Profil Ekranı (`profile_page.dart`)
- Kullanıcı adı, doğum tarihi, şehir ve biyografi bilgilerini güncelleme.
- Profil fotoğrafı ekleme/düzenleme.
- Supabase üzerinden şehir listesi çekme ve seçme.
- Bu sayfa Ritvan Angous  tarafından yazılmıştır.
### 6. Ayarlar Ekranı (`settings_page.dart`)
- Tema yönetimi (karanlık/açık mod, renk seçimi).
- Yazı tipi boyutu ayarı.
- Bildirim, ses ve titreşim ayarları.
- Uygulama hakkında bilgiler.
- Bu sayfa Ritvan Angous  tarafından yazılmıştır.
### Drawer Menü
- Ana sayfa, günlük ekle, profil, ayarlar ve çıkış seçenekleri.
- Kullanıcı bilgileri ve uygulama logosu.
- Bu sayfa ortak yazılmıştır
## Modülerlik ve Kod Yapısı

1. **Widgetlar**
   - `custom_drawer.dart`: Yan menü.
   - `custom_appbar.dart`: Uygulama üst barı.
   - `note_input.dart`, `note_dialog.dart`, `home_card.dart`: Not ve kart bileşenleri.

2. **Servisler**
   - `auth_helper.dart`: Kimlik doğrulama işlemleri.
   - `diary_helper.dart`, `home_helper.dart`: Günlük işlemleri.

3. **Sağlayıcılar (Providers)**
   - `settings_provider.dart`: Tema ve ayar yönetimi.

4. **Ekranlar (Screens)**
   - Her ekran (login, register, home, profile, settings, diary_detail) ayrı dosyada.

5. **Sabitler ve Metinler**
   - `constants/constants.dart`, `constants/texts.dart`: Uygulama genelinde kullanılan sabitler ve metinler.

## Tema Yönetimi

- Tema tercihleri `settings_provider.dart` ile yönetilir.
- Kullanıcı, ayarlar ekranından tema ve renk tercihini değiştirebilir.
- Seçilen tema uygulama genelinde tutarlı bir görünüm sağlar.

## Supabase'de Veri Saklama Örneği

**Günlük Kaydı:**
```json
{
  "content": "Bugün çok verimli geçti.",
  "firebase_uid": "kullanici_uid",
  "date": "2024-05-01",
  "day": "Wednesday"
}
```

**Kullanıcı Profili:**
```json
{
  "firebase_uid": "kullanici_uid",
  "full_name": "Ad Soyad",
  "location": "İstanbul",
  "province_id": 34,
  "birthday": "1990-01-01T00:00:00.000Z",
  "bio": "Kısa biyografi"
}
```

## Geliştirme Ortamı

- Flutter SDK
- Firebase CLI
- Supabase CLI
- Android Studio

## Katkıda Bulunanlar

- **Esat Küçe:** Diary detail,login page,register page ayrıca firebase geliştirmesi.
- **Ritvan Angous:** Profil page, settings page , veritabanini tasarımı supa ve sqlite.
- **Muhammed Sait Yıldırım:** home page, firebase , supabase ve çalışmaların raporlanması.
  
## İletişim

Proje bağlantısı: https://github.com/esatkee/MOB

