# RPD Investigations — Orijinal tasarım + üyelik

Bu sürüm yüklediğiniz orijinal `İndex.html` arayüzünü korur ve Supabase Auth + ortak veri kayıtları ekler.

## Kurulum
1. Supabase SQL Editor'da `schema.sql` dosyasını **tamamını** çalıştırın. Önceki SQL kurulumunda tablolar oluşmuş olsa bile bu sürümün `data` sütunu ve politikaları için bu dosyayı çalıştırın.
2. `index.html` dosyasını GitHub deposunun köküne yükleyin; Vercel'de GitHub deposunu import ederek statik site olarak yayınlayın. `schema.sql` dosyasını web sitesinde yayınlamak zorunda değilsiniz.
3. Site açıldığında e-posta ve şifreyle **Kayıt Ol** düğmesine basın. Supabase Authentication > Users bölümünde kullanıcıyı bulun, UUID değerini kopyalayın.
4. SQL Editor'da `update public.profiles set approved=true,role='admin' where id='BURAYA-UUID';` komutunu kendi UUID'nizle çalıştırın. Çıkış yapıp yeniden giriş yapın.
5. **Üye Onayları** sayfasından diğer hesapları onaylayın. Viewer salt okunur, Detective kayıt düzenler, Admin üye yönetir.

## Supabase bağlantısı
İlk bağlantı, sizin verdiğiniz Supabase URL ve **publishable** anahtarına önceden ayarlanmıştır. Başka proje için giriş ekranında **Bağlantı Ayarları** kullanılabilir. **Secret/service_role** anahtarını hiçbir zaman bu HTML'e yazmayın.

## Önemli notlar
- Orijinal yerel tarayıcı kayıtları otomatik taşınmaz. Önceki sitedeki kayıtları ayrıca taşımak gerekir.
- Kişisel dedektif/birim ayarları tarayıcıda saklanır. Soruşturma, kişiler, deliller, ifadeler, zaman çizelgesi ve raporlar Supabase'te ortaktır.
- Bu sürümde görsel/dosya yükleme yerine mevcut `fileRef` bağlantı alanı korunmuştur.
- Supabase Auth'ta e-posta onayı etkinse kayıt sonrası e-posta doğrulaması gerekir.
- Uygulama FiveM rol yapma içindir; gerçek kişilerin hassas bilgilerini girmeyin.
