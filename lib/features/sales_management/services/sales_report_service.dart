// lib/features/sales_management/services/sales_report_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:intl/intl.dart';

/// Satış Yönetimi Rapor Servisi
class SalesReportService {
  // Tarih formatları
  final _dateFormat = DateFormat('dd.MM.yyyy');
  final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  /// Rezervasyon ve ürün verilerini içeren PDF raporu oluştur
  Future<Uint8List> generatePdf({
    required List<ReservationModel> reservations,
    required Map<String, List<StockModel>> productsMap,
    required String period,
    required String periodDescription,
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

    // Her rezervasyon için içerik oluştur
    List<pw.Widget> contentWidgets = [];

    for (int i = 0; i < reservations.length; i++) {
      final reservation = reservations[i];
      final products = productsMap[reservation.rezervasyonNo] ?? [];

      // Rezervasyon başlığı
      contentWidgets.add(
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'Rezervasyon ${reservation.rezervasyonNo} - ${reservation.aliciFirma}',
            style: subtitleStyle,
          ),
        ),
      );
      contentWidgets.add(pw.SizedBox(height: 8));

      // Rezervasyon bilgileri (Key-Value formatında)
      contentWidgets.add(_buildReservationInfo(reservation, labelStyle, valueStyle));
      contentWidgets.add(pw.SizedBox(height: 12));

      // Ürünler tablosu
      if (products.isNotEmpty) {
        contentWidgets.add(
          pw.Text('Ürünler (${products.length} adet):', style: labelStyle),
        );
        contentWidgets.add(pw.SizedBox(height: 4));
        contentWidgets.add(_buildProductsTable(products, cellHeaderStyle, cellStyle));
      } else {
        contentWidgets.add(
          pw.Text('Bu rezervasyonda ürün bulunmamaktadır.', style: valueStyle),
        );
      }

      // Rezervasyonlar arası boşluk
      if (i < reservations.length - 1) {
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
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('SATIŞ YÖNETİMİ RAPORU', style: titleStyle),
            pw.Text(
              'Oluşturma: ${_dateTimeFormat.format(DateTime.now())}',
              style: valueStyle,
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.Text('Periyot: ', style: pw.TextStyle(font: titleStyle.font, fontSize: 10)),
            pw.Text(period, style: valueStyle),
            pw.SizedBox(width: 20),
            pw.Text('Tarih Aralığı: ', style: pw.TextStyle(font: titleStyle.font, fontSize: 10)),
            pw.Text(periodDescription, style: valueStyle),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 2, color: PdfColors.blue),
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

  /// Rezervasyon bilgi bölümü
  pw.Widget _buildReservationInfo(
    ReservationModel reservation,
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
              _buildInfoCell('Rezervasyon Kodu', reservation.rezervasyonKodu ?? '-', labelStyle, valueStyle),
              _buildInfoCell('Rezervasyon Sorumlusu', reservation.rezervasyonSorumlusu ?? '-', labelStyle, valueStyle),
              _buildInfoCell('Satış Sorumlusu', reservation.satisSorumlusu ?? '-', labelStyle, valueStyle),
            ],
          ),
          pw.SizedBox(height: 6),
          // Satır 2
          pw.Row(
            children: [
              _buildInfoCell('Durum', reservation.durum ?? '-', labelStyle, valueStyle),
              _buildInfoCell(
                'İşlem Tarihi',
                reservation.islemTarihi != null ? _dateTimeFormat.format(reservation.islemTarihi!) : '-',
                labelStyle,
                valueStyle,
              ),
              _buildInfoCell(
                'Ürün Çıkış Tarihi',
                reservation.urunCikisTarihi != null ? _dateFormat.format(reservation.urunCikisTarihi!) : '-',
                labelStyle,
                valueStyle,
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          // Satır 3
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Sevkiyat Adresi', style: labelStyle),
                    pw.Text(reservation.sevkiyatAdresi ?? '-', style: valueStyle),
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
    List<StockModel> products,
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
        // Başlık satırı 1
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
        ...products.map((product) => pw.TableRow(
              children: [
                _tableCell(product.epc, cellStyle),
                _tableCell(product.barkodNo, cellStyle),
                _tableCell(product.bandilNo ?? '-', cellStyle),
                _tableCell(product.plakaNo ?? '-', cellStyle),
                _tableCell(product.urunTipi ?? '-', cellStyle),
                _tableCell(product.urunTuru ?? '-', cellStyle),
                _tableCell(product.yuzeyIslemi ?? '-', cellStyle),
                _tableCell(product.seleksiyon ?? '-', cellStyle),
                _tableCell(product.kalinlik?.toStringAsFixed(1) ?? '-', cellStyle),
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
    required List<ReservationModel> reservations,
    required Map<String, List<StockModel>> productsMap,
    required String period,
    required String periodDescription,
  }) async {
    final excel = Excel.createExcel();
    
    // Rezervasyonlar Sheet
    final rezSheet = excel['Rezervasyonlar'];
    _setupReservationsSheet(rezSheet, reservations, period, periodDescription);
    
    // Ürünler Sheet
    final productSheet = excel['Ürünler'];
    _setupProductsSheet(productSheet, productsMap);

    // Varsayılan sayfa sil
    excel.delete('Sheet1');

    return Uint8List.fromList(excel.encode()!);
  }

  void _setupReservationsSheet(Sheet sheet, List<ReservationModel> reservations, String period, String periodDescription) {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.blue100,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Meta bilgiler
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('SATIŞ YÖNETİMİ RAPORU');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue('Periyot: $period');
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Tarih Aralığı: $periodDescription');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Oluşturma: ${_dateTimeFormat.format(DateTime.now())}');

    // Başlık satırı
    final headers = [
      'Rezervasyon No', 'Rezervasyon Kodu', 'Alıcı Firma', 'Rezervasyon Sorumlusu',
      'Satış Sorumlusu', 'Durum', 'İşlem Tarihi', 'Ürün Çıkış Tarihi', 'Sevkiyat Adresi', 'Kaydeden'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 5));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Veri satırları
    for (int rowIndex = 0; rowIndex < reservations.length; rowIndex++) {
      final reservation = reservations[rowIndex];
      final excelRow = rowIndex + 6;

      final values = [
        reservation.rezervasyonNo,
        reservation.rezervasyonKodu ?? '',
        reservation.aliciFirma,
        reservation.rezervasyonSorumlusu ?? '',
        reservation.satisSorumlusu ?? '',
        reservation.durum ?? '',
        reservation.islemTarihi != null ? _dateTimeFormat.format(reservation.islemTarihi!) : '',
        reservation.urunCikisTarihi != null ? _dateFormat.format(reservation.urunCikisTarihi!) : '',
        reservation.sevkiyatAdresi ?? '',
        reservation.kaydedenPersonel ?? '',
      ];

      for (int colIndex = 0; colIndex < values.length; colIndex++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: excelRow))
            .value = TextCellValue(values[colIndex]);
      }
    }
  }

  void _setupProductsSheet(Sheet sheet, Map<String, List<StockModel>> productsMap) {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.green100,
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
    productsMap.forEach((rezervasyonNo, products) {
      for (final product in products) {
        final values = [
          rezervasyonNo,
          product.epc,
          product.barkodNo,
          product.bandilNo ?? '',
          product.plakaNo ?? '',
          product.urunTipi ?? '',
          product.urunTuru ?? '',
          product.yuzeyIslemi ?? '',
          product.seleksiyon ?? '',
          product.kalinlik?.toStringAsFixed(2) ?? '',
          product.stokEn?.toStringAsFixed(2) ?? '',
          product.stokBoy?.toStringAsFixed(2) ?? '',
          product.stokAlan?.toStringAsFixed(2) ?? '',
          product.stokTonaj?.toStringAsFixed(2) ?? '',
          product.satisEn?.toStringAsFixed(2) ?? '',
          product.satisBoy?.toStringAsFixed(2) ?? '',
          product.satisAlan?.toStringAsFixed(2) ?? '',
          product.satisTonaj?.toStringAsFixed(2) ?? '',
          product.durum ?? '',
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
      subject: 'Satış Yönetimi Raporu',
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
}
