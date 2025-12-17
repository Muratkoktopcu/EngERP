import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_service.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/widgets/product_update_dialog.dart';
import 'package:eng_erp/features/stock/widgets/delete_confirmation_dialog.dart';
import 'package:eng_erp/features/stock/widgets/stock_filter_panel.dart';
import 'package:eng_erp/features/stock/widgets/stock_data_table.dart';
import 'package:eng_erp/features/stock/widgets/stock_action_buttons.dart';

class StokYonetimiPage extends StatefulWidget {
  const StokYonetimiPage({super.key});

  @override
  State<StokYonetimiPage> createState() => _StokYonetimiPageState();
}

class _StokYonetimiPageState extends State<StokYonetimiPage> {
  // ============================================================
  // DATA & STATE MANAGEMENT
  // ============================================================
  final StockService _stockService = StockService();
  List<StockModel> _stockList = [];
  bool _isLoading = false;
  String? _errorMessage;
  StockModel? _selectedStock;

  // Filtre verileri
  StockFilterData _filterData = const StockFilterData();

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  /// Verileri Supabase'den çek (filtrelerle)
  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Üretim tarihi aralığını hesapla
      DateTime? uretimTarihiBaslangic;
      DateTime? uretimTarihiBitis;

      if (_filterData.uretimTarihi.isNotEmpty) {
        final parts = _filterData.uretimTarihi.split('.');
        if (parts.length == 3) {
          uretimTarihiBaslangic = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );

          switch (_filterData.tarihPeriyodu) {
            case "Günlük":
              uretimTarihiBitis = uretimTarihiBaslangic.add(const Duration(days: 1));
              break;
            case "Haftalık":
              uretimTarihiBitis = uretimTarihiBaslangic.add(const Duration(days: 7));
              break;
            case "Aylık":
              uretimTarihiBitis = DateTime(
                uretimTarihiBaslangic.year,
                uretimTarihiBaslangic.month + 1,
                uretimTarihiBaslangic.day,
              );
              break;
            case "Yıllık":
              uretimTarihiBitis = DateTime(
                uretimTarihiBaslangic.year + 1,
                uretimTarihiBaslangic.month,
                uretimTarihiBaslangic.day,
              );
              break;
          }
        }
      }

      final stocks = await _stockService.getFilteredStock(
        epc: _filterData.epc.trim().isEmpty ? null : _filterData.epc,
        barkod: _filterData.barkod.trim().isEmpty ? null : _filterData.barkod,
        bandilNo: _filterData.bandilNo.trim().isEmpty ? null : _filterData.bandilNo,
        plakaNo: _filterData.plakaNo.trim().isEmpty ? null : _filterData.plakaNo,
        urunTipi: _filterData.urunTipi == null || _filterData.urunTipi == 'Hepsi' ? null : _filterData.urunTipi,
        urunTuru: _filterData.urunTuru == null || _filterData.urunTuru == 'Hepsi' ? null : _filterData.urunTuru,
        yuzeyIslemi: _filterData.yuzeyIslemi == null || _filterData.yuzeyIslemi == 'Hepsi' ? null : _filterData.yuzeyIslemi,
        durum: _filterData.filtreDurum == null || _filterData.filtreDurum == 'Hepsi' ? null : _filterData.filtreDurum,
        uretimTarihiBaslangic: uretimTarihiBaslangic,
        uretimTarihiBitis: uretimTarihiBitis,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Stok Yönetimi"),
          backgroundColor: Colors.white70,
          centerTitle: false,
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Filtre Paneli
                  StockFilterPanel(
                    initialData: _filterData,
                    onFilterChanged: _fetchStockData,
                    onClearFilters: () {
                      setState(() {
                        _filterData = const StockFilterData();
                      });
                      _fetchStockData();
                    },
                    onDataChanged: (data) {
                      _filterData = data;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Veri Tablosu
                  Expanded(
                    child: StockDataTable(
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
                  const SizedBox(height: 10),

                  // Aksiyon Butonları
                  StockActionButtons(
                    onStokRaporu: () {},
                    onUrunGuncelle: _handleUpdateProduct,
                    onSil: _handleDeleteProduct,
                    onRezervasyonBilgisi: () {},
                    onYenile: () {
                      setState(() => _selectedStock = null);
                      _fetchStockData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Ürün güncelleme dialog'ını aç
  void _handleUpdateProduct() {
    if (_selectedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen güncellemek istediğiniz ürünü seçin'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProductUpdateDialog(
        stock: _selectedStock!,
        onUpdateSuccess: () {
          setState(() => _selectedStock = null);
          _fetchStockData();
        },
      ),
    );
  }

  /// Seçili ürünü sil
  Future<void> _handleDeleteProduct() async {
    if (_selectedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen silmek istediğiniz ürünü seçin'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      stock: _selectedStock!,
    );

    if (confirmed != true) return;

    try {
      await _stockService.deleteStock(_selectedStock!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ürün başarıyla silindi'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() => _selectedStock = null);
        _fetchStockData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Silme hatası: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
