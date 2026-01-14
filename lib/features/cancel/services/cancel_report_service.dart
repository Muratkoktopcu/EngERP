// lib/features/cancel/services/cancel_report_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';
import 'package:intl/intl.dart';

/// İptal Raporu Oluşturma Servisi
class CancelReportService {
  // Tarih formatları
  final _dateFormat = DateFormat('dd.MM.yyyy');
  final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  /// İptal kayıtları ve ürün detaylarını içeren PDF raporu oluştur
  Future<Uint8List> generatePdf({
    required List<RezIptalModel> iptalList,
    required Map<String, List<RezIptalDetayModel>> detailsMap,
    required String period,
    required String periodDescription,
    String? filterDescription,
  }) async {
    final pdf = pw.Document();

    // Google Fonts üzerinden Türkçe karakter destekli font yükle
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    final titleStyle = pw.TextStyle(font: boldFont, fontSize: 18);
    final subtitleStyle = pw.TextStyle(font: boldFont, fontSize: 14);
    final headerStyle = pw.TextStyle(font: boldFont, fontSize: 10);
    final labelStyle = pw.TextStyle(font: boldFont, fontSize: 9);
    final valueStyle = pw.TextStyle(font: font, fontSize: 9);
    final cellStyle = pw.TextStyle(font: font, fontSize: 8);
    final cellHeaderStyle = pw.TextStyle(font: boldFont, fontSize: 8);

    // Her iptal kaydı için içerik oluştur
    List<pw.Widget> contentWidgets = [];

    for (int i = 0; i < iptalList.length; i++) {
      final iptal = iptalList[i];
      final details = detailsMap[iptal.rezervasyonNo] ?? [];

      // İptal başlığı
      contentWidgets.add(
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.red50,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'Rezervasyon ${iptal.rezervasyonNo} - ${iptal.aliciFirma ?? "-"}',
            style: subtitleStyle,
          ),
        ),
      );
      contentWidgets.add(pw.SizedBox(height: 8));

      // İptal bilgileri (Key-Value formatında)
      contentWidgets.add(_buildIptalInfo(iptal, labelStyle, valueStyle));
      contentWidgets.add(pw.SizedBox(height: 12));

      // Ürünler bölümü
      if (details.isNotEmpty) {
        contentWidgets.add(
          pw.Text('Ürünler (${details.length} adet):', style: labelStyle),
        );
        contentWidgets.add(pw.SizedBox(height: 4));
        contentWidgets.add(_buildProductsTable(details, cellHeaderStyle, cellStyle));
      } else {
        contentWidgets.add(
          pw.Text('Bu iptal kaydında ürün detayı bulunmamaktadır.', style: valueStyle),
        );
      }

      // İptal kayıtları arası boşluk
      if (i < iptalList.length - 1) {
        contentWidgets.add(pw.SizedBox(height: 20));
        contentWidgets.add(pw.Divider(thickness: 1, color: PdfColors.grey400));
        contentWidgets.add(pw.SizedBox(height: 20));
      }
    }

    // Sayfaları oluştur
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        header: (context) => _buildHeader(
          context,
          titleStyle,
          valueStyle,
          period,
          periodDescription,
          filterDescription,
          iptalList.length,
        ),
        footer: (context) => _buildFooter(context, valueStyle),
        build: (context) => contentWidgets,
      ),
    );

    return pdf.save();
  }

  /// Sayfa başlığı
  pw.Widget _buildHeader(
    pw.Context context,
    pw.TextStyle titleStyle,
    pw.TextStyle valueStyle,
    String period,
    String periodDescription,
    String? filterDescription,
    int recordCount,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('İPTAL RAPORU', style: titleStyle),
            pw.Text(
              'Oluşturma: ${_dateTimeFormat.format(DateTime.now())}',
              style: valueStyle,
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.Text('Kayıt Sayısı: ', style: pw.TextStyle(font: titleStyle.font, fontSize: 10)),
            pw.Text('$recordCount adet', style: valueStyle),
            pw.SizedBox(width: 20),
            pw.Text('Periyot: ', style: pw.TextStyle(font: titleStyle.font, fontSize: 10)),
            pw.Text(period, style: valueStyle),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          children: [
            pw.Text('Tarih Aralığı: ', style: pw.TextStyle(font: titleStyle.font, fontSize: 10)),
            pw.Text(periodDescription, style: valueStyle),
          ],
        ),
        if (filterDescription != null && filterDescription.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text('Filtreler: $filterDescription', style: valueStyle),
        ],
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 2, color: PdfColors.red),
        pw.SizedBox(height: 12),
      ],
    );
  }

  /// Sayfa altbilgisi
  pw.Widget _buildFooter(pw.Context context, pw.TextStyle style) {
    final isFirstPage = context.pageNumber == 1;
    return pw.Column(
      children: [
        pw.Divider(thickness: 1, color: PdfColors.grey400),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              isFirstPage ? '' : '(devam)',
              style: style,
            ),
            pw.Text(
              'Sayfa ${context.pageNumber} / ${context.pagesCount}',
              style: style,
            ),
          ],
        ),
      ],
    );
  }

  /// İptal bilgi bölümü
  pw.Widget _buildIptalInfo(
    RezIptalModel iptal,
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          // Satır 1
          pw.Row(
            children: [
              _buildInfoCell('Rezervasyon Kodu', iptal.rezervasyonKodu ?? '-', labelStyle, valueStyle),
              _buildInfoCell('Satış Sorumlusu', iptal.satisSorumlusu ?? '-', labelStyle, valueStyle),
              _buildInfoCell('Durum', iptal.durum ?? 'İptal', labelStyle, valueStyle),
            ],
          ),
          pw.SizedBox(height: 6),
          // Satır 2
          pw.Row(
            children: [
              _buildInfoCell(
                'İşlem Tarihi',
                iptal.islemTarihi != null ? _dateTimeFormat.format(iptal.islemTarihi!) : '-',
                labelStyle,
                valueStyle,
              ),
              _buildInfoCell(
                'İptal Tarihi',
                iptal.iptalTarihi != null ? _dateTimeFormat.format(iptal.iptalTarihi!) : '-',
                labelStyle,
                valueStyle,
              ),
              _buildInfoCell('İptal Eden', iptal.iptalEdenPersonel ?? '-', labelStyle, valueStyle),
            ],
          ),
          pw.SizedBox(height: 6),
          // Satır 3 - İptal Sebebi
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('İptal Sebebi', style: labelStyle),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.red50,
                        borderRadius: pw.BorderRadius.circular(2),
                      ),
                      child: pw.Text(
                        iptal.iptalSebebi ?? 'Belirtilmemiş',
                        style: valueStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoCell(String label, String value, pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: labelStyle),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

  /// Ürünler tablosu
  pw.Widget _buildProductsTable(
    List<RezIptalDetayModel> details,
    pw.TextStyle headerStyle,
    pw.TextStyle cellStyle,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // EPC
        1: const pw.FlexColumnWidth(1.5), // Barkod
        2: const pw.FlexColumnWidth(1), // Bandıl
        3: const pw.FlexColumnWidth(1), // Plaka
        4: const pw.FlexColumnWidth(1), // Tip
        5: const pw.FlexColumnWidth(1), // Tür
        6: const pw.FlexColumnWidth(1), // Yüzey
        7: const pw.FlexColumnWidth(0.8), // Seleksiyon
        8: const pw.FlexColumnWidth(0.7), // Kalınlık
      },
      children: [
        // Başlık satırı
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableHeader('EPC', headerStyle),
            _tableHeader('Barkod No', headerStyle),
            _tableHeader('Bandıl No', headerStyle),
            _tableHeader('Plaka No', headerStyle),
            _tableHeader('Ürün Tipi', headerStyle),
            _tableHeader('Ürün Türü', headerStyle),
            _tableHeader('Yüzey İşlemi', headerStyle),
            _tableHeader('Seleksiyon', headerStyle),
            _tableHeader('Kalınlık', headerStyle),
          ],
        ),
        // Ürün satırları
        ...details.map((detail) => pw.TableRow(
              children: [
                _tableCell(detail.epc, cellStyle),
                _tableCell(detail.barkodNo ?? '-', cellStyle),
                _tableCell(detail.bandilNo ?? '-', cellStyle),
                _tableCell(detail.plakaNo ?? '-', cellStyle),
                _tableCell(detail.urunTipi ?? '-', cellStyle),
                _tableCell(detail.urunTuru ?? '-', cellStyle),
                _tableCell(detail.yuzeyIslemi ?? '-', cellStyle),
                _tableCell(detail.seleksiyon ?? '-', cellStyle),
                _tableCell(detail.kalinlik?.toStringAsFixed(1) ?? '-', cellStyle),
              ],
            )),
      ],
    );
  }

  pw.Widget _tableHeader(String text, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _tableCell(String text, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(text, style: style),
    );
  }

  /// Excel raporu oluştur
  Future<Uint8List> generateExcel({
    required List<RezIptalModel> iptalList,
    required Map<String, List<RezIptalDetayModel>> detailsMap,
    required String period,
    required String periodDescription,
  }) async {
    final excel = Excel.createExcel();
    
    // İptal Kayıtları Sheet
    final iptalSheet = excel['İptal Kayıtları'];
    _setupIptalSheet(iptalSheet, iptalList, period, periodDescription);
    
    // Ürün Detayları Sheet
    final detailSheet = excel['Ürün Detayları'];
    _setupDetailSheet(detailSheet, detailsMap);

    // Varsayılan sayfa sil
    excel.delete('Sheet1');

    return Uint8List.fromList(excel.encode()!);
  }

  void _setupIptalSheet(Sheet sheet, List<RezIptalModel> iptalList, String period, String periodDescription) {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.red100,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Meta bilgiler
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('İPTAL RAPORU');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue('Periyot: $period');
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Tarih Aralığı: $periodDescription');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Oluşturma: ${_dateTimeFormat.format(DateTime.now())}');

    // Başlık satırı
    final headers = [
      'Rezervasyon No', 'Rezervasyon Kodu', 'Alıcı Firma', 'Satış Sorumlusu',
      'Durum', 'İşlem Tarihi', 'İptal Tarihi', 'İptal Eden', 'İptal Sebebi'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 5));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Veri satırları
    for (int rowIndex = 0; rowIndex < iptalList.length; rowIndex++) {
      final iptal = iptalList[rowIndex];
      final excelRow = rowIndex + 6;

      final values = [
        iptal.rezervasyonNo,
        iptal.rezervasyonKodu ?? '',
        iptal.aliciFirma ?? '',
        iptal.satisSorumlusu ?? '',
        iptal.durum ?? '',
        iptal.islemTarihi != null ? _dateTimeFormat.format(iptal.islemTarihi!) : '',
        iptal.iptalTarihi != null ? _dateTimeFormat.format(iptal.iptalTarihi!) : '',
        iptal.iptalEdenPersonel ?? '',
        iptal.iptalSebebi ?? '',
      ];

      for (int colIndex = 0; colIndex < values.length; colIndex++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: excelRow))
            .value = TextCellValue(values[colIndex]);
      }
    }
  }

  void _setupDetailSheet(Sheet sheet, Map<String, List<RezIptalDetayModel>> detailsMap) {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.orange100,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Başlık satırı
    final headers = [
      'Rezervasyon No', 'EPC', 'Barkod No', 'Bandıl No', 'Plaka No', 'Ürün Tipi', 'Ürün Türü',
      'Yüzey İşlemi', 'Seleksiyon', 'Kalınlık', 'Stok En', 'Stok Boy', 'Stok Alan', 'Stok Tonaj',
      'Satış En', 'Satış Boy', 'Satış Alan', 'Satış Tonaj', 'Durum'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Veri satırları
    int rowIndex = 1;
    detailsMap.forEach((rezervasyonNo, details) {
      for (final detail in details) {
        final values = [
          rezervasyonNo,
          detail.epc,
          detail.barkodNo ?? '',
          detail.bandilNo ?? '',
          detail.plakaNo ?? '',
          detail.urunTipi ?? '',
          detail.urunTuru ?? '',
          detail.yuzeyIslemi ?? '',
          detail.seleksiyon ?? '',
          detail.kalinlik?.toStringAsFixed(2) ?? '',
          detail.stokEn?.toStringAsFixed(2) ?? '',
          detail.stokBoy?.toStringAsFixed(2) ?? '',
          detail.stokAlan?.toStringAsFixed(2) ?? '',
          detail.stokTonaj?.toStringAsFixed(2) ?? '',
          detail.satisEn?.toStringAsFixed(2) ?? '',
          detail.satisBoy?.toStringAsFixed(2) ?? '',
          detail.satisAlan?.toStringAsFixed(2) ?? '',
          detail.satisTonaj?.toStringAsFixed(2) ?? '',
          detail.durum ?? '',
        ];

        for (int colIndex = 0; colIndex < values.length; colIndex++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex))
              .value = TextCellValue(values[colIndex]);
        }
        rowIndex++;
      }
    });
  }

  /// PDF yazdırma önizlemesi göster
  Future<void> showPrintPreview(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }

  /// PDF dosyasını Downloads klasörüne kaydet
  Future<File> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    final directory = await _getDownloadsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  /// Excel dosyasını Downloads klasörüne kaydet
  Future<File> saveExcelToFile(Uint8List excelBytes, String fileName) async {
    final directory = await _getDownloadsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(excelBytes);
    return file;
  }

  /// Dosyayı paylaş
  Future<void> shareFile(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'İptal Raporu',
    );
  }

  /// Downloads klasörünü al
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      try {
        if (await downloadsDir.exists()) {
          final testFile = File('${downloadsDir.path}/.test_write_${DateTime.now().millisecondsSinceEpoch}');
          await testFile.writeAsString('test');
          await testFile.delete();
          return downloadsDir;
        }
      } catch (e) {
        // Downloads'a yazamıyoruz, alternatif dene
      }

      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        return extDir;
      }
    }

    return await getApplicationDocumentsDirectory();
  }

  /// Tarih periyodu açıklamasını oluştur
  String buildPeriodDescription(DateTime? date, String period) {
    if (date == null) return 'Tüm tarihler';

    DateTime startDate;
    DateTime endDate;

    switch (period) {
      case 'Günlük':
        startDate = DateTime(date.year, date.month, date.day);
        endDate = startDate;
        break;
      case 'Haftalık':
        final weekday = date.weekday;
        startDate = DateTime(date.year, date.month, date.day - weekday + 1);
        endDate = startDate.add(const Duration(days: 6));
        break;
      case 'Aylık':
        startDate = DateTime(date.year, date.month, 1);
        endDate = DateTime(date.year, date.month + 1, 0);
        break;
      case 'Yıllık':
        startDate = DateTime(date.year, 1, 1);
        endDate = DateTime(date.year, 12, 31);
        break;
      default:
        return 'Tüm tarihler';
    }

    return '${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}';
  }

  /// Filtre açıklaması oluştur
  String? buildFilterDescription({
    String? rezervasyonNo,
    String? rezervasyonKodu,
    String? aliciFirma,
    String? satisSorumlusu,
    DateTime? rezervasyonTarihi,
    DateTime? iptalTarihi,
    String? epc,
    String? tarihPeriyodu,
  }) {
    final parts = <String>[];

    if (rezervasyonNo != null && rezervasyonNo.isNotEmpty) {
      parts.add('Rez. No: $rezervasyonNo');
    }
    if (rezervasyonKodu != null && rezervasyonKodu.isNotEmpty) {
      parts.add('Rez. Kodu: $rezervasyonKodu');
    }
    if (aliciFirma != null && aliciFirma.isNotEmpty) {
      parts.add('Firma: $aliciFirma');
    }
    if (satisSorumlusu != null && satisSorumlusu.isNotEmpty) {
      parts.add('Satış Sor.: $satisSorumlusu');
    }
    if (rezervasyonTarihi != null) {
      parts.add('Rez. Tarihi: ${_dateFormat.format(rezervasyonTarihi)}');
    }
    if (iptalTarihi != null) {
      parts.add('İptal Tarihi: ${_dateFormat.format(iptalTarihi)}');
    }
    if (epc != null && epc.isNotEmpty) {
      parts.add('EPC: $epc');
    }
    if (tarihPeriyodu != null) {
      parts.add('Periyot: $tarihPeriyodu');
    }

    return parts.isEmpty ? null : parts.join(' | ');
  }
}
