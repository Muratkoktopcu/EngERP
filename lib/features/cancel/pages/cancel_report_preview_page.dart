// lib/features/cancel/pages/cancel_report_preview_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';
import 'package:eng_erp/features/cancel/services/cancel_report_service.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

/// 📊 İptal Raporu Önizleme Sayfası
class CancelReportPreviewPage extends StatefulWidget {
  final List<RezIptalModel> iptalList;
  final Map<String, List<RezIptalDetayModel>> detailsMap;
  final String period;
  final String periodDescription;
  final String? filterDescription;

  const CancelReportPreviewPage({
    super.key,
    required this.iptalList,
    required this.detailsMap,
    required this.period,
    required this.periodDescription,
    this.filterDescription,
  });

  @override
  State<CancelReportPreviewPage> createState() => _CancelReportPreviewPageState();
}

class _CancelReportPreviewPageState extends State<CancelReportPreviewPage>
    with SingleTickerProviderStateMixin {
  final CancelReportService _reportService = CancelReportService();
  final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  Uint8List? _pdfBytes;
  Uint8List? _excelBytes;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _generateReports();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _generateReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // PDF ve Excel'i paralel oluştur
      final results = await Future.wait([
        _reportService.generatePdf(
          iptalList: widget.iptalList,
          detailsMap: widget.detailsMap,
          period: widget.period,
          periodDescription: widget.periodDescription,
          filterDescription: widget.filterDescription,
        ),
        _reportService.generateExcel(
          iptalList: widget.iptalList,
          detailsMap: widget.detailsMap,
          period: widget.period,
          periodDescription: widget.periodDescription,
        ),
      ]);

      setState(() {
        _pdfBytes = results[0];
        _excelBytes = results[1];
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _printPdf() async {
    if (_pdfBytes == null) return;
    await Printing.layoutPdf(onLayout: (_) => _pdfBytes!);
  }

  Future<void> _savePdf() async {
    if (_pdfBytes == null) return;
    setState(() => _isSaving = true);
    try {
      final fileName = 'iptal_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
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

  Future<void> _saveExcel() async {
    if (_excelBytes == null) return;
    setState(() => _isSaving = true);
    try {
      final fileName = 'iptal_raporu_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = await _reportService.saveExcelToFile(_excelBytes!, fileName);
      if (mounted) {
        _showSuccess('Excel kaydedildi: ${file.path}');
      }
    } catch (e) {
      if (mounted) _showError('Excel kaydetme hatası: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfBytes == null) return;
    setState(() => _isSaving = true);
    try {
      final fileName = 'iptal_raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await _reportService.savePdfToFile(_pdfBytes!, fileName);
      await _reportService.shareFile(file);
    } catch (e) {
      if (mounted) _showError('Paylaşım hatası: $e');
    } finally {
      setState(() => _isSaving = false);
    }
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
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.picture_as_pdf, size: 24),
          SizedBox(width: 12),
          Text(
            'İptal Raporu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        if (!_isLoading && _pdfBytes != null) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _generateReports,
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
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
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
                  '${widget.iptalList.length} kayıt işleniyor',
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Özet Bilgiler Kartı
          _buildSummaryCard(),
          
          // PDF Önizleme
          Expanded(
            child: _buildPdfPreview(),
          ),
          
          // Aksiyon Butonları
          _buildActionButtons(),
        ],
      ),
    );
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
              onPressed: _generateReports,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
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
    // Toplam ürün sayısını hesapla
    int totalProducts = 0;
    widget.detailsMap.forEach((_, details) {
      totalProducts += details.length;
    });

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withOpacity(0.9),
            AppColors.error.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'İPTAL RAPORU',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.period,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // İstatistikler
          Row(
            children: [
              _buildStatItem(
                Icons.description_outlined,
                '${widget.iptalList.length}',
                'İptal Kaydı',
              ),
              const SizedBox(width: 12),
              _buildStatItem(
                Icons.inventory_2_outlined,
                '$totalProducts',
                'Ürün',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  Icons.date_range,
                  widget.periodDescription,
                  'Tarih Aralığı',
                  isWide: true,
                ),
              ),
            ],
          ),
          
          // Filtreler
          if (widget.filterDescription != null && widget.filterDescription!.isNotEmpty) ...[
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
                      widget.filterDescription!,
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
          
          // Oluşturma zamanı
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                'Oluşturulma: ${_dateTimeFormat.format(DateTime.now())}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
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
          // Önizleme başlığı
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
          // PDF Viewer
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

  Widget _buildActionButtons() {
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
                    : [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSaving ? [] : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
