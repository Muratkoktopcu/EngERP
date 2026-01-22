// lib/features/stock/pages/stock_report_preview_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/widgets/stock_filter_panel.dart';
import 'package:eng_erp/features/stock/services/stock_report_service.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

/// 📊 Stok Raporu Önizleme Sayfası
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

class _StockReportPreviewPageState extends State<StockReportPreviewPage>
    with SingleTickerProviderStateMixin {
  final StockReportService _reportService = StockReportService();
  final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  Uint8List? _pdfBytes;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _generateReport();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _generateReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pdfBytes = await _reportService.generatePdf(
        widget.stocks,
        widget.filters,
      );

      setState(() {
        _pdfBytes = pdfBytes;
        _isLoading = false;
      });
      _animationController?.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _savePdf() async {
    if (_pdfBytes == null) return;
    setState(() => _isSaving = true);
    try {
      final fileName = 'stok_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await _reportService.savePdfToFile(_pdfBytes!, fileName);
      if (mounted) {
        _showSuccess('PDF kaydedildi: ${file.path}');
      }
    } catch (e) {
      if (mounted) _showError('PDF kaydetme hatası: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfBytes == null) return;
    setState(() => _isSaving = true);
    try {
      final fileName = 'stok_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await _reportService.savePdfToFile(_pdfBytes!, fileName);
      await _reportService.shareFile(file);
    } catch (e) {
      if (mounted) _showError('Paylaşım hatası: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _printPdf() async {
    if (_pdfBytes == null) return;
    await Printing.layoutPdf(onLayout: (_) => _pdfBytes!);
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
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

  String _buildFilterDescription() {
    if (widget.filters == null) return '';
    final f = widget.filters!;
    final parts = <String>[];

    if (f.epc.isNotEmpty) parts.add('EPC: ${f.epc}');
    if (f.barkod.isNotEmpty) parts.add('Barkod: ${f.barkod}');
    if (f.bandilNo.isNotEmpty) parts.add('Bandıl: ${f.bandilNo}');
    if (f.plakaNo.isNotEmpty) parts.add('Plaka: ${f.plakaNo}');
    if (f.urunTipi != null && f.urunTipi != 'Hepsi') parts.add('Ürün Tipi: ${f.urunTipi}');
    if (f.urunTuru != null && f.urunTuru != 'Hepsi') parts.add('Ürün Türü: ${f.urunTuru}');
    if (f.yuzeyIslemi != null && f.yuzeyIslemi != 'Hepsi') parts.add('Yüzey: ${f.yuzeyIslemi}');
    if (f.filtreDurum != null && f.filtreDurum != 'Hepsi') parts.add('Durum: ${f.filtreDurum}');
    if (f.uretimTarihi.isNotEmpty) parts.add('Üretim: ${f.uretimTarihi}');

    return parts.join(' | ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.inventory_2, size: 24),
          SizedBox(width: 12),
          Text(
            'Stok Raporu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        if (!_isLoading && _pdfBytes != null) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _generateReport,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Paylaş',
            onPressed: _isSaving ? null : _sharePdf,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Rapor Oluşturuluyor...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.stocks.length} ürün işleniyor',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return _buildErrorState();
    }

    final content = Column(
      children: [
        _buildSummaryCard(),
        Expanded(child: _buildPdfPreview()),
        _buildActionButton(),
      ],
    );

    if (_fadeAnimation != null) {
      return FadeTransition(
        opacity: _fadeAnimation!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rapor oluşturulamadı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final filterDesc = _buildFilterDescription();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.9),
            AppColors.success.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'STOK RAPORU',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              if (_hasActiveFilters())
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Filtreli',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                Icons.inventory,
                '${widget.stocks.length}',
                'Ürün',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  Icons.access_time,
                  _dateTimeFormat.format(DateTime.now()),
                  'Oluşturma Zamanı',
                  isWide: true,
                ),
              ),
            ],
          ),
          if (filterDesc.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_outlined, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      filterDesc,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, {bool isWide = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPreview() {
    if (_pdfBytes == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.grey200,
              border: Border(
                bottom: BorderSide(color: AppColors.grey200),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.preview, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                const Text(
                  'PDF Önizleme',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _printPdf,
                  icon: const Icon(Icons.fullscreen, size: 18),
                  label: const Text('Tam Ekran'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => _pdfBytes!,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              maxPageWidth: 700,
              pdfPreviewPageDecoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isSaving ? null : _savePdf,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isSaving 
                    ? [AppColors.grey300, AppColors.grey300]
                    : [AppColors.success, AppColors.success.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSaving ? [] : [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSaving) ...[
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Kaydediliyor...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'PDF İndir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
