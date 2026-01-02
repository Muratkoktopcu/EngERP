import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/widgets/stock_filter_panel.dart';
import 'package:eng_erp/features/stock/services/stock_report_service.dart';
import 'package:printing/printing.dart';

/// Stok raporu önizleme sayfası
/// PDF önizleme ve export seçenekleri sunar
class StockReportPreviewPage extends StatefulWidget {
  final List<StockModel> stocks;
  final StockFilterData? filters;

  const StockReportPreviewPage({
    super.key,
    required this.stocks,
    this.filters,
  });

  @override
  State<StockReportPreviewPage> createState() => _StockReportPreviewPageState();
}

class _StockReportPreviewPageState extends State<StockReportPreviewPage> {
  final StockReportService _reportService = StockReportService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Raporu Önizleme'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Excel export butonu
          IconButton(
            onPressed: _isLoading ? null : _exportToExcel,
            icon: const Icon(Icons.table_chart),
            tooltip: 'Excel Olarak Kaydet',
          ),
          // PDF paylaş butonu
          IconButton(
            onPressed: _isLoading ? null : _sharePdf,
            icon: const Icon(Icons.share),
            tooltip: 'PDF Paylaş',
          ),
        ],
      ),
      body: Column(
        children: [
          // Rapor özet bilgisi
          _buildReportSummary(),
          
          // Yükleme veya hata durumu
          if (_isLoading)
            const LinearProgressIndicator(),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _errorMessage = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          
          // PDF Önizleme
          Expanded(
            child: PdfPreview(
              build: (format) => _reportService.generatePdf(
                widget.stocks,
                widget.filters,
              ),
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              pdfFileName: 'stok_raporu.pdf',
              loadingWidget: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Rapor hazırlanıyor...'),
                  ],
                ),
              ),
              onError: (context, error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Rapor oluşturulurken hata oluştu',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Rapor özet bilgisi widget'ı
  Widget _buildReportSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Icon(Icons.inventory_2, color: Colors.blue.shade700, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stok Raporu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toplam ${widget.stocks.length} ürün listeleniyor',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                if (widget.filters != null && _hasActiveFilters())
                  Text(
                    'Filtreler uygulandı',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              _buildActionButton(
                icon: Icons.picture_as_pdf,
                label: 'PDF Kaydet',
                color: Colors.red.shade600,
                onPressed: _savePdf,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.table_chart,
                label: 'Excel Kaydet',
                color: Colors.green.shade600,
                onPressed: _exportToExcel,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  bool _hasActiveFilters() {
    if (widget.filters == null) return false;
    final f = widget.filters!;
    return f.epc.isNotEmpty ||
        f.barkod.isNotEmpty ||
        f.bandilNo.isNotEmpty ||
        f.uretimTarihi.isNotEmpty ||
        f.plakaNo.isNotEmpty ||
        (f.urunTipi != null && f.urunTipi != 'Hepsi') ||
        (f.urunTuru != null && f.urunTuru != 'Hepsi') ||
        (f.yuzeyIslemi != null && f.yuzeyIslemi != 'Hepsi') ||
        (f.filtreDurum != null && f.filtreDurum != 'Hepsi');
  }

  /// PDF'i dosya olarak kaydet
  Future<void> _savePdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pdfBytes = await _reportService.generatePdf(
        widget.stocks,
        widget.filters,
      );
      
      final fileName = 'stok_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await _reportService.savePdfToFile(pdfBytes, fileName);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF kaydedildi: ${file.path}'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Paylaş',
              textColor: Colors.white,
              onPressed: () => _reportService.shareFile(file),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'PDF kaydedilirken hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// PDF'i paylaş
  Future<void> _sharePdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pdfBytes = await _reportService.generatePdf(
        widget.stocks,
        widget.filters,
      );
      
      final fileName = 'stok_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await _reportService.savePdfToFile(pdfBytes, fileName);
      await _reportService.shareFile(file);
    } catch (e) {
      setState(() => _errorMessage = 'PDF paylaşılırken hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Excel'e export et
  Future<void> _exportToExcel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final excelBytes = await _reportService.generateExcel(
        widget.stocks,
        widget.filters,
      );
      
      final fileName = 'stok_raporu_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = await _reportService.saveExcelToFile(excelBytes, fileName);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Excel kaydedildi: ${file.path}'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Paylaş',
              textColor: Colors.white,
              onPressed: () => _reportService.shareFile(file),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Excel oluşturulurken hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
