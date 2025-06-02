import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'base_page.dart';
import '../widgets/custom_drawer.dart';
import '../constants/constants.dart';
import '../constants/texts.dart';

// Profil sayfası için StatefulWidget tanımlanıyor
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Profil sayfasının durumunu yöneten sınıf
class _ProfilePageState extends State<ProfilePage> {
  // Form doğrulama için global anahtar
  final _formKey = GlobalKey<FormState>();

  // Kullanıcı bilgileri için metin denetleyicileri
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  // İl/şehir verilerini tutan liste
  List<Map<String, dynamic>> _provinces = [];

  // Seçilen il/şehir ID'si
  int? _selectedProvinceId;

  // Yükleme durumunu takip eden değişken
  bool _isLoading = false;

  // Sayfa ilk yüklendiğinde çalışan fonksiyon
  @override
  void initState() {
    super.initState();

    // Giriş yapmış kullanıcıyı alır
    final user = FirebaseAuth.instance.currentUser;

    // Text denetleyicilerini başlatır
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _birthDateController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();

    // İl verilerini ve kullanıcı profilini yükler
    _fetchProvinces();
    _loadUserProfile();
  }

  // Supabase'den il/şehir verilerini çeker
  Future<void> _fetchProvinces() async {
    final supabase = Supabase.instance.client;
    final data = await supabase.from('provinces').select();

    // Veriyi listeye dönüştürerek durumu günceller
    setState(() {
      _provinces = List<Map<String, dynamic>>.from(data);
    });
  }

  // Kullanıcının mevcut profil verilerini yükler
  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    try {
      // Supabase'den kullanıcı verisini alır
      final data = await supabase
          .from('user')
          .select()
          .eq('firebase_uid', uid)
          .maybeSingle();

      // Veri varsa denetleyicilere atar
      if (data != null) {
        _locationController.text = data['location'] ?? '';
        _selectedProvinceId = data['province_id'];

        // Doğum tarihi varsa formatlayarak gösterir
        final birthdayString = data['birthday'];
        if (birthdayString != null && birthdayString.isNotEmpty) {
          final birthdayDate = DateTime.tryParse(birthdayString);
          if (birthdayDate != null) {
            _birthDateController.text =
            "${birthdayDate.day.toString().padLeft(2, '0')}/${birthdayDate.month.toString().padLeft(2, '0')}/${birthdayDate.year}";
          }
        } else {
          _birthDateController.text = '';
        }

        _bioController.text = data['bio'] ?? '';
      }
    } catch (e) {
      // Hata durumunda kullanıcıya hata mesajı gösterilir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil yüklenirken hata oluştu: $e'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Kullanıcı profilini kaydeden fonksiyon
  Future<void> _saveProfile() async {
    // Form geçerli değilse işlemi durdurur
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Doğum tarihi metnini parçalayarak DateTime objesi oluşturur
      final birthdayParts = _birthDateController.text.split('/');
      DateTime? birthday;
      if (birthdayParts.length == 3) {
        birthday = DateTime(
          int.parse(birthdayParts[2]),
          int.parse(birthdayParts[1]),
          int.parse(birthdayParts[0]),
        );
      }

      // Supabase'e kullanıcı bilgilerini güncelleme isteği gönderir
      await supabase.from('user').update({
        'full_name': _nameController.text,
        'location': _locationController.text,
        'province_id': _selectedProvinceId,
        'birthday': birthday?.toIso8601String(),
        'bio': _bioController.text,
      }).eq('firebase_uid', uid);

      // Firebase üzerinde kullanıcı adını da günceller
      await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text);

      // Başarılı kayıt sonrası kullanıcıya bildirim gösterilir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTexts.profileUpdateSuccess),
          backgroundColor: AppConstants.successColor,
        ),
      );
    } catch (e) {
      // Hata durumunda kullanıcıya uyarı gösterilir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil kaydedilirken hata oluştu: $e'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Takvim açılarak kullanıcıdan doğum tarihi seçmesini sağlar
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Takvim temasını uygulama renklerine göre özelleştirir
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColor,
              onPrimary: Colors.white,
              surface: AppConstants.secondaryColor,
              onSurface: AppConstants.textColor,
            ),
            dialogBackgroundColor: AppConstants.secondaryColor,
          ),
          child: child!,
        );
      },
    );

    // Tarih seçildiyse metin kutusunu günceller
    if (picked != null) {
      setState(() {
        _birthDateController.text =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Sayfa yok edilirken controller'ları serbest bırakır
  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme,
      child: BasePage(
        title: AppTexts.profile,
        drawer: DrawerMenu(onAddNote: null),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: AppConstants.avatarRadius,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              backgroundImage: user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : const AssetImage(AppConstants.defaultAvatarPath)
                                      as ImageProvider,
                              child: user?.photoURL == null
                                  ? Icon(
                                      Icons.person,
                                      size: AppConstants.extraLargeIconSize,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.largePadding),
                      Text(
                        AppTexts.personalInfo,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: AppTexts.fullName,
                          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                          prefixIcon: Icon(Icons.person, color: theme.colorScheme.primary),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppTexts.nameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(
                          labelText: AppTexts.birthDate,
                          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                          prefixIcon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      DropdownButtonFormField<int>(
                        value: _selectedProvinceId,
                        items: _provinces
                            .map((province) => DropdownMenuItem<int>(
                                  value: province['province_id'],
                                  child: Text(
                                    province['province_name'],
                                    style: TextStyle(color: theme.colorScheme.onSurface),
                                  ),
                                ))
                            .toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedProvinceId = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: AppTexts.birthLocation,
                          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                          prefixIcon: Icon(Icons.location_on, color: theme.colorScheme.primary),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        dropdownColor: theme.colorScheme.surface,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: AppTexts.location,
                          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                          prefixIcon: Icon(Icons.home, color: theme.colorScheme.primary),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        AppTexts.aboutYou,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      TextFormField(
                        controller: _bioController,
                        decoration: InputDecoration(
                          labelText: AppTexts.about,
                          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                          alignLabelWithHint: true,
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        maxLines: 4,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                      const SizedBox(height: AppConstants.largePadding),
                      SizedBox(
                        width: double.infinity,
                        height: AppConstants.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).brightness == Brightness.light 
                                ? AppConstants.primaryColor 
                                : theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  AppTexts.save,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}