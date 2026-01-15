// lib/features/sales_confirmation/pages/SalesConfirmationPage.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/core/widgets/custom_app_bar.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/sales_management/data/sales_management_service.dart';
import 'package:eng_erp/features/sales_management/widgets/sales_filter_panel.dart';
import 'package:eng_erp/features/sales_management/widgets/sales_reservation_table.dart';
import 'package:eng_erp/features/sales_management/widgets/sales_detail_table.dart';
import 'package:eng_erp/features/sales_management/widgets/sales_action_buttons.dart';
import 'package:eng_erp/features/sales_management/widgets/product_selection_dialog.dart';
import 'package:eng_erp/features/sales_management/widgets/cancel_reservation_dialog.dart';
import 'package:eng_erp/features/sales_management/widgets/dimension_update_dialog.dart';
import 'package:eng_erp/features/sales_management/services/sales_report_service.dart';
import 'package:eng_erp/features/sales_management/pages/sales_report_preview_page.dart';

/// 📊 Satış Yönetimi Sayfası
class SalesConfirmationPage extends StatefulWidget {
  const SalesConfirmationPage({super.key});

  @override
  State<SalesConfirmationPage> createState() => _SalesConfirmationPageState();
}

class _SalesConfirmationPageState extends State<SalesConfirmationPage> {
  // Service
  final SalesManagementService _service = SalesManagementService();

  // Kullanıcı bilgisi
  String _currentUser = '';

  // Listeler
  List<ReservationModel> _reservations = [];
  List<StockModel> _products = [];
  List<StockModel> _availableProducts = [];
  List<String> _firmaOnerileri = [];

  // Seçimler
  ReservationModel? _selectedReservation;
  StockModel? _selectedProduct;

  // Filtre Controller'ları
  final TextEditingController _rezervasyonNoController = TextEditingController();
  final TextEditingController _rezervasyonKoduController = TextEditingController();
  final TextEditingController _aliciFirmaController = TextEditingController();
  final TextEditingController _rezervasyonSorumlusuController = TextEditingController();
  final TextEditingController _satisSorumlusuController = TextEditingController();
  final TextEditingController _epcController = TextEditingController();

  // Filtre Durumları
  DateTime? _selectedDate;
  String _tarihPeriyodu = 'Günlük';
  String _durum = 'Hepsi';

  // UI Durumları
  bool _isLoading = false;
  bool _isDetailLoading = false;
  bool _isFilterExpanded = true;
  bool _isActionLoading = false;

  // Debounce timer
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initPage();
    
    // Filtre değişikliklerini dinle (debounce ile)
    _rezervasyonNoController.addListener(_onFilterChanged);
    _rezervasyonKoduController.addListener(_onFilterChanged);
    _aliciFirmaController.addListener(_onFilterChanged);
    _rezervasyonSorumlusuController.addListener(_onFilterChanged);
    _satisSorumlusuController.addListener(_onFilterChanged);
    _epcController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _debounceTimer?.cancel();
    
    // Listener'ları kaldır
    _rezervasyonNoController.removeListener(_onFilterChanged);
    _rezervasyonKoduController.removeListener(_onFilterChanged);
    _aliciFirmaController.removeListener(_onFilterChanged);
    _rezervasyonSorumlusuController.removeListener(_onFilterChanged);
    _satisSorumlusuController.removeListener(_onFilterChanged);
    _epcController.removeListener(_onFilterChanged);
    
    _rezervasyonNoController.dispose();
    _rezervasyonKoduController.dispose();
    _aliciFirmaController.dispose();
    _rezervasyonSorumlusuController.dispose();
    _satisSorumlusuController.dispose();
    _epcController.dispose();
    super.dispose();
  }

  /// Filtre değişikliğinde tetiklenir (debounce ile)
  void _onFilterChanged() {
    // Önceki timer'ı iptal et
    _debounceTimer?.cancel();
    
    // Yeni timer başlat (300ms debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fetchReservations();
      }
    });
  }

  /// Sayfa başlangıç yüklemesi
  Future<void> _initPage() async {
    // Tarih başlangıçta seçili değil
    await _loadCurrentUser();
    await _fetchReservations();
  }

  /// Aktif kullanıcıyı yükle
  Future<void> _loadCurrentUser() async {
    try {
      final user = SupabaseClientManager().db.auth.currentUser;
      if (user != null) {
        setState(() {
          _currentUser = user.userMetadata?['displayName'] as String? ??
              user.email ??
              'Bilinmeyen';
        });
      }
    } catch (e) {
      debugPrint('Kullanıcı bilgisi alınamadı: $e');
    }
  }

  /// Rezervasyonları getir
  Future<void> _fetchReservations() async {
    setState(() => _isLoading = true);

    try {
      final reservations = await _service.getFilteredReservations(
        rezervasyonNo: _rezervasyonNoController.text.trim(),
        rezervasyonKodu: _rezervasyonKoduController.text.trim(),
        aliciFirma: _aliciFirmaController.text.trim(),
        rezervasyonSorumlusu: _rezervasyonSorumlusuController.text.trim(),
        satisSorumlusu: _satisSorumlusuController.text.trim(),
        durum: _durum,
        tarih: _selectedDate,
        tarihPeriyodu: _tarihPeriyodu,
        epc: _epcController.text.trim(),
      );

      setState(() {
        _reservations = reservations;
        _selectedReservation = null;
        _selectedProduct = null;
        _products = [];
      });
    } catch (e) {
      _showError('Rezervasyonlar yüklenirken hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Seçili rezervasyonun ürünlerini getir
  Future<void> _fetchReservationProducts(String rezervasyonNo) async {
    setState(() => _isDetailLoading = true);

    try {
      final products = await _service.getReservationProducts(rezervasyonNo);
      setState(() {
        _products = products;
        _selectedProduct = null;
      });
    } catch (e) {
      _showError('Ürünler yüklenirken hata: $e');
    } finally {
      setState(() => _isDetailLoading = false);
    }
  }

  /// Firma ara (autocomplete için)
  Future<void> _searchCompanies(String term) async {
    if (term.isEmpty) {
      setState(() => _firmaOnerileri = []);
      return;
    }

    try {
      final companies = await _service.searchCompanies(term);
      setState(() {
        _firmaOnerileri = companies.map((c) => c.firmaAdi).toList();
      });
    } catch (e) {
      debugPrint('Firma araması hatası: $e');
    }
  }

  /// Stokta olan ürünleri getir
  Future<void> _fetchAvailableProducts(String searchTerm) async {
    try {
      final products = await _service.getAvailableProducts(searchTerm: searchTerm);
      setState(() => _availableProducts = products);
    } catch (e) {
      debugPrint('Stok ürünleri yüklenirken hata: $e');
    }
  }

  /// Filtreleri temizle
  void _clearFilters() {
    setState(() {
      _rezervasyonNoController.clear();
      _rezervasyonKoduController.clear();
      _aliciFirmaController.clear();
      _rezervasyonSorumlusuController.clear();
      _satisSorumlusuController.clear();
      _epcController.clear();
      _selectedDate = null; // Tarih filtresini kaldır
      _tarihPeriyodu = 'Günlük';
      _durum = 'Hepsi';
    });
    _fetchReservations();
  }

  /// Tarih seçici
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      _fetchReservations();
    }
  }

  // ==================== AKSIYON HANDLER'LARI ====================

  /// Rezervasyonu onayla
  Future<void> _handleApprove() async {
    if (_selectedReservation == null) {
      _showWarning('Lütfen bir rezervasyon seçin.');
      return;
    }

    final validationError = _service.validateApproval(_selectedReservation!);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    setState(() => _isActionLoading = true);

    try {
      await _service.approveReservation(_selectedReservation!, _currentUser);
      _showSuccess('Rezervasyon onaylandı.');
      await _fetchReservations();
    } catch (e) {
      _showError('Onaylama hatası: $e');
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  /// Onayı geri al
  Future<void> _handleRevokeApproval() async {
    if (_selectedReservation == null) {
      _showWarning('Lütfen bir rezervasyon seçin.');
      return;
    }

    final validationError = _service.validateRevokeApproval(_selectedReservation!);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    setState(() => _isActionLoading = true);

    try {
      await _service.revokeApproval(_selectedReservation!);
      _showSuccess('Rezervasyon onayı geri alındı.');
      await _fetchReservations();
    } catch (e) {
      _showError('Onay geri alma hatası: $e');
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  /// Ürün ekle
  Future<void> _handleAddProduct() async {
    if (_selectedReservation == null) {
      _showWarning('Lütfen bir rezervasyon seçin.');
      return;
    }

    final validationError = _service.validateAddProduct(_selectedReservation);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    // Stok ürünlerini yükle
    await _fetchAvailableProducts('');

    if (!mounted) return;

    final selectedProduct = await showDialog<StockModel>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return ProductSelectionDialog(
            availableProducts: _availableProducts,
            onSearch: (term) async {
              await _fetchAvailableProducts(term);
              setDialogState(() {});
            },
          );
        },
      ),
    );

    if (selectedProduct != null) {
      setState(() => _isActionLoading = true);

      try {
        await _service.addProductToReservation(
          epc: selectedProduct.epc,
          reservation: _selectedReservation!,
        );
        _showSuccess('Ürün rezervasyona eklendi.');
        await _fetchReservationProducts(_selectedReservation!.rezervasyonNo);
      } catch (e) {
        _showError('Ürün ekleme hatası: $e');
      } finally {
        setState(() => _isActionLoading = false);
      }
    }
  }

  /// Ürün çıkar
  Future<void> _handleRemoveProduct() async {
    if (_selectedProduct == null) {
      _showWarning('Lütfen bir ürün seçin.');
      return;
    }

    final validationError = _service.validateRemoveProduct(_selectedProduct);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    // Son ürün mü kontrol et
    if (_products.length <= 1) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Son Ürün'),
          content: const Text(
            'Bu ürün rezervasyondaki son ürün. Çıkarılırsa rezervasyon da silinecek. Devam etmek istiyor musunuz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Devam Et'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() => _isActionLoading = true);

    try {
      final reservationDeleted = await _service.removeProductFromReservation(
        product: _selectedProduct!,
        rezervasyonNo: _selectedReservation!.rezervasyonNo,
      );

      if (reservationDeleted) {
        _showSuccess('Ürün çıkarıldı ve rezervasyon silindi.');
        await _fetchReservations();
      } else {
        _showSuccess('Ürün rezervasyondan çıkarıldı.');
        await _fetchReservationProducts(_selectedReservation!.rezervasyonNo);
      }
    } catch (e) {
      _showError('Ürün çıkarma hatası: $e');
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  /// Boyut güncelle
  Future<void> _handleUpdateDimensions() async {
    if (_selectedProduct == null) {
      _showWarning('Lütfen bir ürün seçin.');
      return;
    }

    final result = await DimensionUpdateDialog.show(
      context,
      product: _selectedProduct!,
    );

    if (result != null) {
      setState(() => _isActionLoading = true);

      try {
        await _service.updateProductDimensions(
          epc: _selectedProduct!.epc,
          satisEn: result['satisEn']!,
          satisBoy: result['satisBoy']!,
          satisAlan: result['satisAlan'],
          satisTonaj: result['satisTonaj'],
        );
        _showSuccess('Boyutlar güncellendi.');
        await _fetchReservationProducts(_selectedReservation!.rezervasyonNo);
      } catch (e) {
        _showError('Boyut güncelleme hatası: $e');
      } finally {
        setState(() => _isActionLoading = false);
      }
    }
  }

  /// Rezervasyonu iptal et
  Future<void> _handleCancel() async {
    if (_selectedReservation == null) {
      _showWarning('Lütfen bir rezervasyon seçin.');
      return;
    }

    final validationError = await _service.validateCancellation(_selectedReservation!);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    final reason = await CancelReservationDialog.show(
      context,
      rezervasyonNo: _selectedReservation!.rezervasyonNo,
      aliciFirma: _selectedReservation!.aliciFirma,
    );

    if (reason != null && reason.isNotEmpty) {
      setState(() => _isActionLoading = true);

      try {
        await _service.cancelReservation(
          reservation: _selectedReservation!,
          iptalSebebi: reason,
          iptalEdenPersonel: _currentUser,
        );
        _showSuccess('Rezervasyon iptal edildi ve arşivlendi.');
        await _fetchReservations();
      } catch (e) {
        _showError('İptal hatası: $e');
      } finally {
        setState(() => _isActionLoading = false);
      }
    }
  }

  /// Packing List
  Future<void> _handlePackingList() async {
    if (_selectedReservation == null) {
      _showWarning('Lütfen bir rezervasyon seçin.');
      return;
    }

    final validationError = _service.validatePackingList(_selectedReservation);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    // TODO: Packing List görüntüleme sayfasına yönlendir
    _showInfo('Packing List özelliği yakında eklenecek.');
  }

  /// PDF Rapor
  Future<void> _handlePdfReport() async {
    final validationError = _service.validatePdfReport(_reservations);
    if (validationError != null) {
      _showWarning(validationError);
      return;
    }

    setState(() => _isActionLoading = true);

    try {
      // Her rezervasyon için ürünleri topla
      final Map<String, List<StockModel>> productsMap = {};
      
      for (final reservation in _reservations) {
        final products = await _service.getReservationProducts(reservation.rezervasyonNo);
        productsMap[reservation.rezervasyonNo] = products;
      }

      // Rapor servisini oluştur
      final reportService = SalesReportService();
      
      // Tarih periyodu açıklamasını oluştur
      final periodDescription = reportService.buildPeriodDescription(
        _selectedDate,
        _tarihPeriyodu,
      );

      setState(() => _isActionLoading = false);

      // Rapor önizleme sayfasına yönlendir
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SalesReportPreviewPage(
              reservations: _reservations,
              productsMap: productsMap,
              period: _tarihPeriyodu,
              periodDescription: periodDescription,
            ),
          ),
        );
      }

    } catch (e) {
      setState(() => _isActionLoading = false);
      _showError('PDF hazırlama hatası: $e');
    }
  }

  // ==================== UI BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar
        _buildAppBar(),
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
                            SalesFilterPanel(
                              isExpanded: _isFilterExpanded,
                              rezervasyonNoController: _rezervasyonNoController,
                              rezervasyonKoduController: _rezervasyonKoduController,
                              aliciFirmaController: _aliciFirmaController,
                              rezervasyonSorumlusuController: _rezervasyonSorumlusuController,
                              satisSorumlusuController: _satisSorumlusuController,
                              epcController: _epcController,
                              selectedDate: _selectedDate,
                              tarihPeriyodu: _tarihPeriyodu,
                              durum: _durum,
                              firmaOnerileri: _firmaOnerileri,
                              onDateTap: _selectDate,
                              onPeriyotChanged: (value) {
                                setState(() => _tarihPeriyodu = value!);
                                _fetchReservations();
                              },
                              onDurumChanged: (value) {
                                setState(() => _durum = value!);
                                _fetchReservations();
                              },
                              onClear: _clearFilters,
                              onFilter: _fetchReservations,
                              onFirmaSearch: _searchCompanies,
                            ),

                            // Rezervasyon Listesi
                            Expanded(
                              flex: 1,
                              child: SalesReservationTable(
                                reservations: _reservations,
                                selectedRezervasyonNo: _selectedReservation?.rezervasyonNo,
                                onRowTap: (reservation) {
                                  // Toggle: Aynı satıra tıklanırsa seçimi kaldır
                                  if (_selectedReservation?.rezervasyonNo == reservation.rezervasyonNo) {
                                    setState(() {
                                      _selectedReservation = null;
                                      _selectedProduct = null;
                                      _products = [];
                                    });
                                  } else {
                                    setState(() {
                                      _selectedReservation = reservation;
                                      _selectedProduct = null;
                                    });
                                    _fetchReservationProducts(reservation.rezervasyonNo);
                                  }
                                },
                                isLoading: _isLoading,
                                onRefresh: _fetchReservations,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // Ürün Detayları
                            Expanded(
                              flex: 1,
                              child: SalesDetailTable(
                                products: _products,
                                selectedEpc: _selectedProduct?.epc,
                                onRowTap: (product) {
                                  // Toggle: Aynı satıra tıklanırsa seçimi kaldır
                                  if (_selectedProduct?.epc == product.epc) {
                                    setState(() => _selectedProduct = null);
                                  } else {
                                    setState(() => _selectedProduct = product);
                                  }
                                },
                                isLoading: _isDetailLoading,
                                rezervasyonNo: _selectedReservation?.rezervasyonNo,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            // Aksiyon Butonları
                            SalesActionButtons(
                              onApprove: _handleApprove,
                              onRevokeApproval: _handleRevokeApproval,
                              onAddProduct: _handleAddProduct,
                              onRemoveProduct: _handleRemoveProduct,
                              onUpdateDimensions: _handleUpdateDimensions,
                              onCancel: _handleCancel,
                              onPackingList: _handlePackingList,
                              onPdfReport: _handlePdfReport,
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

  Widget _buildAppBar() {
    return CustomAppBar(
      title: 'Satış Yönetimi',
      actions: [
        // Yenile
        IconButton(
          onPressed: _fetchReservations,
          icon: const Icon(Icons.refresh),
          tooltip: "Yenile",
        ),
        // Filtre toggle
        IconButton(
          icon: Icon(
            _isFilterExpanded ? Icons.filter_alt_off : Icons.filter_alt,
          ),
          onPressed: () {
            setState(() => _isFilterExpanded = !_isFilterExpanded);
          },
          tooltip: _isFilterExpanded ? 'Filtreleri Gizle' : 'Filtreleri Göster',
        ),
      ],
    );
  }

  // ==================== MESAJ GÖSTERİCİLER ====================

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(color: AppColors.textPrimary))),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
