// lib/features/reservation/pages/ReservationPage.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/services/user_service.dart';
import 'package:eng_erp/core/widgets/custom_app_bar.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/data/stock_service.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';
import 'package:eng_erp/features/reservation/data/reservation_service.dart';
import 'package:eng_erp/features/reservation/widgets/reservation_form_card.dart';
import 'package:eng_erp/features/reservation/widgets/reservation_filter_panel.dart';
import 'package:eng_erp/features/reservation/widgets/reservation_stock_table.dart';
import 'package:eng_erp/features/reservation/widgets/reservation_cart_table.dart';
import 'package:eng_erp/features/reservation/widgets/reservation_action_buttons.dart';
import 'package:eng_erp/features/reservation/widgets/dimension_update_dialog.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  // ============================================================
  // SERVICES
  // ============================================================
  final StockService _stockService = StockService();
  final ReservationService _reservationService = ReservationService();

  // ============================================================
  // STOCK DATA & STATE
  // ============================================================
  List<StockModel> _stockList = [];
  bool _isLoading = false;
  String? _errorMessage;
  StockModel? _selectedStock;

  // ============================================================
  // CART DATA & STATE
  // ============================================================
  List<StockModel> _cartItems = [];
  StockModel? _selectedCartItem;
  Map<String, Map<String, double>> _dimensionUpdates = {};

  // ============================================================
  // FORM DATA
  // ============================================================
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _rezervasyonNoController = TextEditingController();
  final TextEditingController _rezervasyonKoduController = TextEditingController();
  List<CompanyModel> _companies = [];
  CompanyModel? _selectedCompany;
  String _rezervasyonSorumlusu = '';

  // ============================================================
  // FILTER DATA
  // ============================================================
  String _barkodFilter = '';

  // ============================================================
  // PROCESSING STATE
  // ============================================================
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    _rezervasyonNoController.dispose();
    _rezervasyonKoduController.dispose();
    super.dispose();
  }

  /// Sayfa başlangıç yüklemesi
  Future<void> _initPage() async {
    await Future.wait([
      _fetchStockData(),
      _fetchCompanies(),
    ]);
    _loadCurrentUser();
  }

  /// Aktif kullanıcıyı yükle (UserService üzerinden displayName alır)
  void _loadCurrentUser() {
    setState(() {
      _rezervasyonSorumlusu = UserService.instance.displayName;
    });
  }

  /// Stok verilerini çek
  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stocks = await _stockService.getFilteredStock(
        barkod: _barkodFilter.trim().isEmpty ? null : _barkodFilter,
        // Sadece "Stokta" durumundaki ürünleri göster
        durum: 'Stokta',
      );

      setState(() {
        _stockList = stocks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Firma listesini çek
  Future<void> _fetchCompanies() async {
    try {
      final companies = await _reservationService.getAllCompanies();
      setState(() {
        _companies = companies;
      });
    } catch (e) {
      debugPrint('Firma listesi yüklenemedi: $e');
    }
  }

  /// Ürünü sepete ekle
  void _addToCart() {
    if (_selectedStock == null) {
      _showWarning("Lütfen stok listesinden bir ürün seçin.");
      return;
    }

    // Validasyon
    final error = _reservationService.validateProductForReservation(
      _selectedStock!,
      _cartItems,
    );

    if (error != null) {
      _showWarning(error);
      return;
    }

    setState(() {
      _cartItems.add(_selectedStock!);
      _selectedStock = null;
    });

    _showSuccess("Ürün sepete eklendi.");
  }

  /// Ürünü sepetten çıkar
  void _removeFromCart() {
    if (_selectedCartItem == null) {
      _showWarning("Lütfen sepetten bir ürün seçin.");
      return;
    }

    setState(() {
      _cartItems.removeWhere((item) => item.epc == _selectedCartItem!.epc);
      _dimensionUpdates.remove(_selectedCartItem!.epc);
      _selectedCartItem = null;
    });

    _showSuccess("Ürün sepetten çıkarıldı.");
  }

  /// Boyutları güncelle dialog'u aç
  void _updateDimensions() {
    if (_selectedCartItem == null) {
      _showWarning("Lütfen sepetten bir ürün seçin.");
      return;
    }

    showDimensionUpdateDialog(
      context: context,
      stock: _selectedCartItem!,
      currentDimensions: _dimensionUpdates[_selectedCartItem!.epc],
      onSave: (dimensions) {
        setState(() {
          _dimensionUpdates[_selectedCartItem!.epc] = dimensions;
        });
        _showSuccess("Boyutlar güncellendi.");
      },
    );
  }

  /// Rezervasyon oluştur
  Future<void> _createReservation() async {
    // Form validasyonu
    final formError = _reservationService.validateReservationForm(
      rezervasyonNo: _rezervasyonNoController.text,
      rezervasyonKodu: _rezervasyonKoduController.text,
      aliciFirma: _selectedCompany?.firmaAdi,
      tarih: _selectedDate,
      cart: _cartItems,
    );

    if (formError != null) {
      _showError(formError);
      return;
    }

    setState(() => _isCreating = true);

    try {
      // Rezervasyon no benzersizlik kontrolü
      final isUnique = await _reservationService.isReservationNoUnique(
        _rezervasyonNoController.text,
      );

      if (!isUnique) {
        _showError("Bu rezervasyon numarası zaten kullanılmış.");
        setState(() => _isCreating = false);
        return;
      }

      // EPC çakışma kontrolü
      final epcError = await _reservationService.checkEpcConflicts(_cartItems);
      if (epcError != null) {
        _showError(epcError);
        setState(() => _isCreating = false);
        return;
      }

      // Rezervasyon oluştur
      await _reservationService.createReservation(
        rezervasyonNo: _rezervasyonNoController.text,
        rezervasyonKodu: _rezervasyonKoduController.text,
        aliciFirma: _selectedCompany!.firmaAdi,
        rezervasyonSorumlusu: _rezervasyonSorumlusu,
        islemTarihi: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
        ),
        cart: _cartItems,
        dimensionUpdates: _dimensionUpdates,
      );

      _showSuccess("Rezervasyon başarıyla oluşturuldu!");

      // Formu temizle
      _clearForm();

      // Stok listesini yenile
      await _fetchStockData();
    } catch (e) {
      _showError("Rezervasyon oluşturulurken hata: $e");
    } finally {
      setState(() => _isCreating = false);
    }
  }

  /// Formu temizle
  void _clearForm() {
    setState(() {
      _selectedDate = DateTime.now();
      _rezervasyonNoController.clear();
      _rezervasyonKoduController.clear();
      _selectedCompany = null;
      _cartItems.clear();
      _dimensionUpdates.clear();
      _selectedStock = null;
      _selectedCartItem = null;
    });
  }

  // ============================================================
  // UI BUILDING
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Boş alana tıklandığında focus'u kaldır
        FocusScope.of(context).unfocus();
      },
      child: Column(
      children: [
        // AppBar
        CustomAppBar(
          title: 'Rezervasyon',
          actions: [
            IconButton(
              onPressed: _fetchStockData,
              icon: const Icon(Icons.refresh),
              tooltip: "Yenile",
            ),
          ],
        ),

        // Sayfa içeriği
        Expanded(
          child: Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Form kartı
                            ReservationFormCard(
                              selectedDate: _selectedDate,
                              rezervasyonNoController: _rezervasyonNoController,
                              rezervasyonKoduController: _rezervasyonKoduController,
                              companies: _companies,
                              selectedCompany: _selectedCompany,
                              rezervasyonSorumlusu: _rezervasyonSorumlusu,
                              onDateChanged: (date) {
                                setState(() => _selectedDate = date);
                              },
                              onCompanyChanged: (company) {
                                setState(() => _selectedCompany = company);
                              },
                              onClear: _clearForm,
                            ),

                            const SizedBox(height: 8),

                            // Filtre paneli
                            ReservationFilterPanel(
                              initialBarkod: _barkodFilter,
                              onBarkodChanged: (value) {
                                setState(() => _barkodFilter = value);
                              },
                              onFilter: _fetchStockData,
                              onClearFilters: () {
                                setState(() => _barkodFilter = '');
                                _fetchStockData();
                              },
                            ),

                            const SizedBox(height: 12),

                            // Tablolar (Stok listesi ve Sepet) - Alt Alta
                            // Sabit yükseklik vererek overflow önlenir
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: ReservationStockTable(
                                stockList: _stockList,
                                isLoading: _isLoading,
                                errorMessage: _errorMessage,
                                selectedStock: _selectedStock,
                                onRetry: _fetchStockData,
                                onSelectionChanged: (stock) {
                                  setState(() => _selectedStock = stock);
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Rezervasyon sepeti
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: ReservationCartTable(
                                cartItems: _cartItems,
                                selectedCartItem: _selectedCartItem,
                                dimensionUpdates: _dimensionUpdates,
                                onSelectionChanged: (item) {
                                  setState(() => _selectedCartItem = item);
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Aksiyon butonları
                            ReservationActionButtons(
                              onAddToCart: _addToCart,
                              onRemoveFromCart: _removeFromCart,
                              onUpdateDimensions: _updateDimensions,
                              onCreateReservation: _createReservation,
                              isCreating: _isCreating,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  // ============================================================
  // SNACKBAR HELPERS
  // ============================================================

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
