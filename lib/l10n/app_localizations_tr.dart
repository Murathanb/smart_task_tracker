// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'TaskFlow';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'Email adresi';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifre Tekrar';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get or => 'veya';

  @override
  String get tasks => 'Görevler';

  @override
  String get newTask => 'Yeni Görev';

  @override
  String get taskTitle => 'Başlık';

  @override
  String get taskDescription => 'Açıklama (opsiyonel)';

  @override
  String get taskDueDate => 'Bitiş tarihi (opsiyonel)';

  @override
  String get taskPriority => 'Öncelik';

  @override
  String get add => 'Ekle';

  @override
  String get addTask => 'Görev Ekle';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get deleteTaskConfirm => 'Görevi Sil';

  @override
  String get deleteTaskMessage => 'Bu görevi silmek istiyor musun?';

  @override
  String get noTasks => 'Henüz görev yok 🎯';

  @override
  String get noTasksSubtitle => 'İlk görevini eklemek için + butonuna bas';

  @override
  String get statusTodo => 'Yapılacak';

  @override
  String get statusInProgress => 'Devam Ediyor';

  @override
  String get statusDone => 'Tamamlandı';

  @override
  String get updateStatus => 'Durum Güncelle';

  @override
  String get priorityLow => 'Düşük';

  @override
  String get priorityMedium => 'Orta';

  @override
  String get priorityHigh => 'Yüksek';

  @override
  String get settings => 'Ayarlar';

  @override
  String get account => 'Hesap';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutConfirm => 'Hesabından çıkmak istediğine emin misin?';

  @override
  String get signOutTitle => 'Çıkış Yap';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem varsayılanı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get appearance => 'Görünüm';

  @override
  String get language => 'Dil';

  @override
  String get languageEn => 'İngilizce';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationsDesc => 'Görev bitiş saatlerinde hatırlatıcı al';

  @override
  String get due => 'Bitiş';

  @override
  String get overdue => 'Gecikmiş';

  @override
  String get today => 'Bugün';

  @override
  String get tomorrow => 'Yarın';

  @override
  String get noDueDate => 'Tarih yok';

  @override
  String get taskDone => 'Görev tamamlandı!';

  @override
  String get greeting => 'Tekrar Hoş Geldin 👋';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get passwordsNoMatch => 'Şifreler eşleşmiyor';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalı';

  @override
  String get taskReminders => 'Görev hatırlatıcıları';

  @override
  String get taskRemindersDesc =>
      'Bitiş zamanı yaklaşan görevler için bildirim al';

  @override
  String get version => 'Smart Task Tracker v1.0.0';

  @override
  String get filter => 'Filtrele';

  @override
  String get filterClear => 'Temizle';

  @override
  String get filterApply => 'Uygula';

  @override
  String get filterStatus => 'Durum';

  @override
  String get filterPriority => 'Öncelik';

  @override
  String get editTask => 'Görevi Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get searchHint => 'Görev ara...';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get completionRate => 'Tamamlanma Oranı';

  @override
  String tasksCount(int done, int total) {
    return '$done / $total görev';
  }

  @override
  String get completed => 'tamamlandı';

  @override
  String get noTasksYet => 'Henüz görev yok';

  @override
  String get statTodo => 'Yapılacak';

  @override
  String get statInProgress => 'Devam Eden';

  @override
  String get statDone => 'Tamamlanan';

  @override
  String get statOverdue => 'Gecikmiş';

  @override
  String get statusDistribution => 'Durum Dağılımı';

  @override
  String get priorityDistribution => 'Öncelik Dağılımı';

  @override
  String get priorityLowShort => 'Düşük';

  @override
  String get priorityMediumShort => 'Orta';

  @override
  String get priorityHighShort => 'Yüksek';
}
