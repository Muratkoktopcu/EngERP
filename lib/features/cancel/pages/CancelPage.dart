// lib/features/cancel/pages/CancelPage.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/cancel/data/cancel_service.dart';
import 'package:eng_erp/features/cancel/widgets/cancel_filter_panel.dart';
import 'package:eng_erp/features/cancel/widgets/cancel_main_table.dart';
import 'package:eng_erp/features/cancel/widgets/cancel_detail_table.dart';
import 'package:eng_erp/features/cancel/widgets/cancel_action_buttons.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';
import 'package:eng_erp/features/cancel/services/cancel_report_service.dart';
import 'package:eng_erp/features/cancel/pages/cancel_report_preview_page.dart';

/// 📋 İptal Yönetimi Sayfası
/// İptal edilen satış rezervasyonlarını görüntüleme, filtreleme ve yönetme
class CancelPage extends StatefulWidget {
  const CancelPage({super.key});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  final CancelService _cancelService = CancelService();

  // Filtre Controllers
  final TextEditingController _rezervasyonNoController = TextEditingController();
  final TextEditingController _rezervasyonKoduController = TextEditingController();
  final TextEditingController _aliciFirmaController = TextEditingController();
  final TextEditingController _satisSorumlusuController = TextEditingController();
  final TextEditingController _epcController = TextEditingController();

  // Tarih değerleri
  DateTime? _rezervasyonTarihi;
  DateTime? _iptalTarihi;
  String _tarihPeriyodu = 'Günlük';

  // Firma listesi (dropdown için)
  List<String> _firmaListesi = [];
  String? _selectedFirma;

  // Veri listeleri
  List<RezIptalModel> _iptalList = [];
  List<RezIptalDetayModel> _detayList = [];

  // Seçili iptal kaydı
  RezIptalModel? _selectedIptal;

  // Yükleme durumları
  bool _isLoading = false;
  bool _isDetailLoading = false;
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
    _loadIptalRecords();
    
    // Filtre değişikliklerini dinle
    _rezervasyonNoController.addListener(_onFilterChanged);
    _rezervasyonKoduController.addListener(_onFilterChanged);
    _satisSorumlusuController.addListener(_onFilterChanged);
    _epcController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _rezervasyonNoController.dispose();
    _rezervasyonKoduController.dispose();
    _satisSorumlusuController.dispose();
    _epcController.dispose();
    super.dispose();
  }

  /// Filtre değişikliğinde tetiklenir
  void _onFilterChanged() {
    // Debounce için küçük bir gecikme
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _loadIptalRecords();
      }
    });
  }

  /// Tüm firmaları yükle (dropdown için)
  Future<void> _loadCompanies() async {
    try {
      final companies = await _cancelService.getAllCompanies();
      setState(() {
        _firmaListesi = companies.map((c) => c.firmaAdi).toList();
      });
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  /// İptal kayıtlarını yükle
  Future<void> _loadIptalRecords() async {
    setState(() => _isLoading = true);

    try {
      final records = await _cancelService.getFilteredIptalRecords(
        rezervasyonNo: _rezervasyonNoController.text.trim(),
        rezervasyonKodu: _rezervasyonKoduController.text.trim(),
        aliciFirma: _selectedFirma,
        satisSorumlusu: _satisSorumlusuController.text.trim(),
        rezervasyonTarihi: _rezervasyonTarihi,
        iptalTarihi: _iptalTarihi,
        tarihPeriyodu: _tarihPeriyodu,
        epc: _epcController.text.trim(),
      );

      // Seçili kayıt artık listede yoksa seçimi ve detayları temizle
      final selectedStillExists = _selectedIptal != null &&
          records.any((r) => r.rezervasyonNo == _selectedIptal!.rezervasyonNo);

      setState(() {
        _iptalList = records;
        _isLoading = false;
        
        // Seçili kayıt artık listede değilse temizle
        if (!selectedStillExists) {
          _selectedIptal = null;
          _detayList = [];
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('İptal kayıtları yüklenirken hata: $e');
    }
  }

  /// Seçilen iptal kaydının detaylarını yükle
  Future<void> _loadDetails(String rezervasyonNo) async {
    setState(() => _isDetailLoading = true);

    try {
      final details = await _cancelService.getIptalDetails(rezervasyonNo);
      setState(() {
        _detayList = details;
        _isDetailLoading = false;
      });
    } catch (e) {
      setState(() => _isDetailLoading = false);
      _showErrorSnackBar('Detaylar yüklenirken hata: $e');
    }
  }

  /// Filtreleri temizle
  void _clearFilters() {
    setState(() {
      _rezervasyonNoController.clear();
      _rezervasyonKoduController.clear();
      _selectedFirma = null;
      _satisSorumlusuController.clear();
      _epcController.clear();
      _rezervasyonTarihi = null;
      _iptalTarihi = null;
      _tarihPeriyodu = 'Günlük';
      _selectedIptal = null;
      _detayList = [];
    });
    _loadIptalRecords();
  }

  /// Firma değişti (dropdown)
  void _onFirmaChanged(String? value) {
    setState(() => _selectedFirma = value);
    _loadIptalRecords();
  }

  /// Rezervasyon tarihi seç
  Future<void> _selectRezervasyonTarihi() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _rezervasyonTarihi ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _rezervasyonTarihi = date);
      _loadIptalRecords();
    }
  }

  /// İptal tarihi seç
  Future<void> _selectIptalTarihi() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _iptalTarihi ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _iptalTarihi = date);
      _loadIptalRecords();
    }
  }

  /// Tarih periyodu değişti
  void _onPeriyotChanged(String? value) {
    if (value != null) {
      setState(() => _tarihPeriyodu = value);
      _loadIptalRecords();
    }
  }

  /// İptal kaydı seçildi (toggle: aynı satıra tıklanırsa seçimi kaldır)
  void _onIptalSelected(RezIptalModel iptal) {
    // Aynı kayda tıklandıysa seçimi kaldır
    if (_selectedIptal?.rezervasyonNo == iptal.rezervasyonNo) {
      setState(() {
        _selectedIptal = null;
        _detayList = [];
      });
    } else {
      // Farklı kayda tıklandıysa seç ve detayları yükle
      setState(() => _selectedIptal = iptal);
      _loadDetails(iptal.rezervasyonNo);
    }
  }

  /// PDF Rapor Oluştur
  Future<void> _onPdfRapor() async {
    // Validasyon: İptal tarihi ve tarih periyodu gerekli
    if (_iptalTarihi == null) {
      _showInfoSnackBar('Lütfen iptal tarihi seçin.');
      return;
    }

    if (_iptalList.isEmpty) {
      _showInfoSnackBar('Rapor oluşturulacak iptal kaydı bulunamadı.');
      return;
    }

    setState(() => _isActionLoading = true);

    try {
      // Her iptal kaydı için ürün detaylarını topla
      final Map<String, List<RezIptalDetayModel>> detailsMap = {};
      
      for (final iptal in _iptalList) {
        final details = await _cancelService.getIptalDetails(iptal.rezervasyonNo);
        detailsMap[iptal.rezervasyonNo] = details;
      }

      // Rapor servisini oluştur
      final reportService = CancelReportService();
      
      // Tarih periyodu açıklamasını oluştur
      final periodDescription = reportService.buildPeriodDescription(
        _iptalTarihi,
        _tarihPeriyodu,
      );

      // Filtre açıklamasını oluştur
      final filterDescription = reportService.buildFilterDescription(
        rezervasyonNo: _rezervasyonNoController.text.trim(),
        rezervasyonKodu: _rezervasyonKoduController.text.trim(),
        aliciFirma: _selectedFirma,
        satisSorumlusu: _satisSorumlusuController.text.trim(),
        rezervasyonTarihi: _rezervasyonTarihi,
        iptalTarihi: _iptalTarihi,
        epc: _epcController.text.trim(),
        tarihPeriyodu: _tarihPeriyodu,
      );

      setState(() => _isActionLoading = false);

      // Rapor önizleme sayfasına yönlendir
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CancelReportPreviewPage(
              iptalList: _iptalList,
              detailsMap: detailsMap,
              period: _tarihPeriyodu,
              periodDescription: periodDescription,
              filterDescription: filterDescription,
            ),
          ),
        );
      }

    } catch (e) {
      setState(() => _isActionLoading = false);
      _showErrorSnackBar('PDF hazırlama hatası: $e');
    }
  }

  /// İptal Sebebi Göster
  void _onIptalSebebiGoster() {
    if (_selectedIptal == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.warning),
            ),
            const SizedBox(width: 12),
            const Text('İptal Sebebi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Rezervasyon No', _selectedIptal!.rezervasyonNo),
            const SizedBox(height: 8),
            _buildInfoRow('İptal Eden', _selectedIptal!.iptalEdenPersonel ?? '-'),
            const SizedBox(height: 8),
            _buildInfoRow('İptal Tarihi', _cancelService.formatDate(_selectedIptal!.iptalTarihi)),
            const SizedBox(height: 16),
            const Text(
              'Sebep:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Text(
                _selectedIptal!.iptalSebebi ?? 'Belirtilmemiş',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  /// Seçili iptal kaydını sil
  void _onSil() {
    if (_selectedIptal == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.warning, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Silme Onayı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selectedIptal!.rezervasyonNo} numaralı iptal kaydını silmek istediğinize emin misiniz?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu işlem geri alınamaz!',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteIptalKaydi();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// İptal kaydını sil
  Future<void> _deleteIptalKaydi() async {
    if (_selectedIptal == null) return;

    setState(() => _isActionLoading = true);

    try {
      await _cancelService.deleteIptalKaydi(_selectedIptal!.rezervasyonNo);
      setState(() {
        _selectedIptal = null;
        _detayList = [];
        _isActionLoading = false;
      });
      _loadIptalRecords();
      _showSuccessSnackBar('İptal kaydı başarıyla silindi');
    } catch (e) {
      setState(() => _isActionLoading = false);
      _showErrorSnackBar('Silme işlemi sırasında hata: $e');
    }
  }

  /// Hata mesajı göster
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Başarı mesajı göster
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Bilgi mesajı göster
  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // APPBAR
        PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: const Text(
              'İPTAL YÖNETİMİ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            centerTitle: false,
            elevation: 2,
          ),
        ),

        // BODY
        Expanded(
          child: Container(
            color: AppColors.backgroundLight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            // Filtre Paneli
                            CancelFilterPanel(
                              rezervasyonNoController: _rezervasyonNoController,
                              rezervasyonKoduController: _rezervasyonKoduController,
                              satisSorumlusuController: _satisSorumlusuController,
                              epcController: _epcController,
                              rezervasyonTarihi: _rezervasyonTarihi,
                              iptalTarihi: _iptalTarihi,
                              tarihPeriyodu: _tarihPeriyodu,
                              firmaListesi: _firmaListesi,
                              selectedFirma: _selectedFirma,
                              onRezervasyonTarihiTap: _selectRezervasyonTarihi,
                              onIptalTarihiTap: _selectIptalTarihi,
                              onPeriyotChanged: _onPeriyotChanged,
                              onFirmaChanged: _onFirmaChanged,
                              onClear: _clearFilters,
                            ),

                            // Ana Tablo (İptal Listesi)
                            Expanded(
                              flex: 1,
                              child: CancelMainTable(
                                iptalList: _iptalList,
                                selectedIptal: _selectedIptal,
                                onIptalSelected: _onIptalSelected,
                                isLoading: _isLoading,
                                onRefresh: _loadIptalRecords,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // Detay Tablosu
                            Expanded(
                              flex: 1,
                              child: CancelDetailTable(
                                detayList: _detayList,
                                isLoading: _isDetailLoading,
                                rezervasyonNo: _selectedIptal?.rezervasyonNo,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            // Aksiyon Butonları
                            CancelActionButtons(
                              hasSelectedIptal: _selectedIptal != null,
                              onPdfRapor: _onPdfRapor,
                              onIptalSebebiGoster: _onIptalSebebiGoster,
                              onSil: _onSil,
                              isLoading: _isActionLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
