// lib/features/stock/services/stock_report_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/widgets/stock_filter_panel.dart';
import 'package:intl/intl.dart';

/// Stok raporu oluşturma servisi
class StockReportService {
  // Tarih formatları
  final _dateFormat = DateFormat('dd.MM.yyyy');
  final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  /// PDF raporu oluştur
  Future<Uint8List> generatePdf(
    List<StockModel> stocks,
    StockFilterData? filters,
  ) async {
    final pdf = pw.Document();

    // Google Fonts üzerinden Türkçe karakter destekli font yükle
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    final headerStyle = pw.TextStyle(font: boldFont, fontSize: 8);
    final cellStyle = pw.TextStyle(font: font, fontSize: 7);
    final titleStyle = pw.TextStyle(font: boldFont, fontSize: 16);
    final subtitleStyle = pw.TextStyle(font: font, fontSize: 10);

    // Filtre bilgisini oluştur
    final filterInfo = _buildFilterInfo(filters);

    // Sayfa başına ürün sayısı
    const itemsPerPage = 15;
    final pageCount = (stocks.length / itemsPerPage).ceil();

    for (int page = 0; page < pageCount; page++) {
      final startIndex = page * itemsPerPage;
      final endIndex = (startIndex + itemsPerPage) > stocks.length
          ? stocks.length
          : startIndex + itemsPerPage;
      final pageStocks = stocks.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Başlık
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('STOK RAPORU', style: titleStyle),
                    pw.Text(
                      'Sayfa ${page + 1} / $pageCount',
                      style: subtitleStyle,
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                
                // Meta bilgiler
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Toplam Kayıt: ${stocks.length} adet',
                      style: subtitleStyle,
                    ),
                    pw.Text(
                      'Oluşturma Tarihi: ${_dateTimeFormat.format(DateTime.now())}',
                      style: subtitleStyle,
                    ),
                  ],
                ),
                
                if (filterInfo.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text('Filtreler: $filterInfo', style: subtitleStyle),
                ],
                
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.SizedBox(height: 8),

                // Tablo
                pw.Expanded(
                  child: pw.ListView.builder(
                    itemCount: pageStocks.length,
                    itemBuilder: (context, index) {
                      final stock = pageStocks[index];
                      return _buildStockItem(stock, headerStyle, cellStyle);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  /// Her stok ürünü için 3 satırlık bilgi kartı
  pw.Widget _buildStockItem(
    StockModel stock,
    pw.TextStyle headerStyle,
    pw.TextStyle cellStyle,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Satır 1
          pw.Row(
            children: [
              _buildCell('ID: ${stock.id}', cellStyle, flex: 1),
              _buildCell('EPC: ${stock.epc}', cellStyle, flex: 2),
              _buildCell('Barkod: ${stock.barkodNo}', cellStyle, flex: 2),
              _buildCell('Bandıl: ${stock.bandilNo ?? '-'}', cellStyle, flex: 1),
              _buildCell('Plaka: ${stock.plakaNo ?? '-'}', cellStyle, flex: 1),
              _buildCell('Tip: ${stock.urunTipi ?? '-'}', cellStyle, flex: 1),
              _buildCell('Tür: ${stock.urunTuru ?? '-'}', cellStyle, flex: 1),
              _buildCell('Yüzey: ${stock.yuzeyIslemi ?? '-'}', cellStyle, flex: 1),
              _buildCell('Seleksiyon: ${stock.seleksiyon ?? '-'}', cellStyle, flex: 1),
            ],
          ),
          pw.SizedBox(height: 2),
          // Satır 2
          pw.Row(
            children: [
              _buildCell(
                'Üretim: ${stock.uretimTarihi != null ? _dateFormat.format(stock.uretimTarihi!) : '-'}',
                cellStyle,
                flex: 1,
              ),
              _buildCell('Kalınlık: ${stock.kalinlik?.toStringAsFixed(2) ?? '-'} mm', cellStyle, flex: 1),
              _buildCell('Plaka Adet: ${stock.plakaAdedi ?? '-'}', cellStyle, flex: 1),
              _buildCell('Stok En: ${stock.stokEn?.toStringAsFixed(2) ?? '-'} cm', cellStyle, flex: 1),
              _buildCell('Stok Boy: ${stock.stokBoy?.toStringAsFixed(2) ?? '-'} cm', cellStyle, flex: 1),
              _buildCell('Stok Alan: ${stock.stokAlan?.toStringAsFixed(2) ?? '-'} m²', cellStyle, flex: 1),
              _buildCell('Stok Tonaj: ${stock.stokTonaj?.toStringAsFixed(2) ?? '-'} ton', cellStyle, flex: 1),
              _buildCell('Durum: ${stock.durum ?? '-'}', cellStyle, flex: 1),
              _buildCell('Rez.No: ${stock.rezervasyonNo ?? '-'}', cellStyle, flex: 1),
            ],
          ),
          pw.SizedBox(height: 2),
          // Satır 3
          pw.Row(
            children: [
              _buildCell('Satış En: ${stock.satisEn?.toStringAsFixed(2) ?? '-'} cm', cellStyle, flex: 1),
              _buildCell('Satış Boy: ${stock.satisBoy?.toStringAsFixed(2) ?? '-'} cm', cellStyle, flex: 1),
              _buildCell('Satış Alan: ${stock.satisAlan?.toStringAsFixed(2) ?? '-'} m²', cellStyle, flex: 1),
              _buildCell('Satış Tonaj: ${stock.satisTonaj?.toStringAsFixed(2) ?? '-'} ton', cellStyle, flex: 1),
              _buildCell('Kaydeden: ${stock.kaydedenPersonel ?? '-'}', cellStyle, flex: 2),
              _buildCell(
                'Çıkış: ${stock.urunCikisTarihi != null ? _dateFormat.format(stock.urunCikisTarihi!) : '-'}',
                cellStyle,
                flex: 1,
              ),
              _buildCell('Alıcı: ${stock.aliciFirma ?? '-'}', cellStyle, flex: 2),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCell(String text, pw.TextStyle style, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(text, style: style),
    );
  }

  /// Excel raporu oluştur
  Future<Uint8List> generateExcel(
    List<StockModel> stocks,
    StockFilterData? filters,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Stok Raporu'];

    // Başlık satırları için stil
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.blue100,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Meta bilgiler
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('STOK RAPORU');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue('Toplam Kayıt: ${stocks.length} adet');
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Oluşturma Tarihi: ${_dateTimeFormat.format(DateTime.now())}');
    
    final filterInfo = _buildFilterInfo(filters);
    if (filterInfo.isNotEmpty) {
      sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Filtreler: $filterInfo');
    }

    // Başlık satırı (6. satır)
    final headers = [
      'ID', 'EPC', 'Barkod No', 'Bandıl No', 'Plaka No', 'Ürün Tipi', 'Ürün Türü',
      'Yüzey İşlemi', 'Seleksiyon', 'Üretim Tarihi', 'Kalınlık (mm)', 'Plaka Adedi',
      'Stok En (cm)', 'Stok Boy (cm)', 'Stok Alan (m²)', 'Stok Tonaj (ton)',
      'Satış En (cm)', 'Satış Boy (cm)', 'Satış Alan (m²)', 'Satış Tonaj (ton)',
      'Durum', 'Rezervasyon No', 'Kaydeden Personel', 'Ürün Çıkış Tarihi', 'Alıcı Firma',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 5));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Veri satırları
    for (int rowIndex = 0; rowIndex < stocks.length; rowIndex++) {
      final stock = stocks[rowIndex];
      final excelRow = rowIndex + 6; // 6. satırdan başla (0-indexed)

      final values = [
        stock.id.toString(),
        stock.epc,
        stock.barkodNo,
        stock.bandilNo ?? '',
        stock.plakaNo ?? '',
        stock.urunTipi ?? '',
        stock.urunTuru ?? '',
        stock.yuzeyIslemi ?? '',
        stock.seleksiyon ?? '',
        stock.uretimTarihi != null ? _dateFormat.format(stock.uretimTarihi!) : '',
        stock.kalinlik?.toStringAsFixed(2) ?? '',
        stock.plakaAdedi?.toString() ?? '',
        stock.stokEn?.toStringAsFixed(2) ?? '',
        stock.stokBoy?.toStringAsFixed(2) ?? '',
        stock.stokAlan?.toStringAsFixed(2) ?? '',
        stock.stokTonaj?.toStringAsFixed(2) ?? '',
        stock.satisEn?.toStringAsFixed(2) ?? '',
        stock.satisBoy?.toStringAsFixed(2) ?? '',
        stock.satisAlan?.toStringAsFixed(2) ?? '',
        stock.satisTonaj?.toStringAsFixed(2) ?? '',
        stock.durum ?? '',
        stock.rezervasyonNo ?? '',
        stock.kaydedenPersonel ?? '',
        stock.urunCikisTarihi != null ? _dateFormat.format(stock.urunCikisTarihi!) : '',
        stock.aliciFirma ?? '',
      ];

      for (int colIndex = 0; colIndex < values.length; colIndex++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: excelRow))
            .value = TextCellValue(values[colIndex]);
      }
    }

    // Varsayılan sayfa sil
    excel.delete('Sheet1');

    return Uint8List.fromList(excel.encode()!);
  }

  /// Filtre bilgisini string olarak oluştur
  String _buildFilterInfo(StockFilterData? filters) {
    if (filters == null) return '';

    final parts = <String>[];

    if (filters.epc.isNotEmpty) parts.add('EPC: ${filters.epc}');
    if (filters.barkod.isNotEmpty) parts.add('Barkod: ${filters.barkod}');
    if (filters.bandilNo.isNotEmpty) parts.add('Bandıl: ${filters.bandilNo}');
    if (filters.plakaNo.isNotEmpty) parts.add('Plaka: ${filters.plakaNo}');
    if (filters.urunTipi != null && filters.urunTipi != 'Hepsi') {
      parts.add('Ürün Tipi: ${filters.urunTipi}');
    }
    if (filters.urunTuru != null && filters.urunTuru != 'Hepsi') {
      parts.add('Ürün Türü: ${filters.urunTuru}');
    }
    if (filters.yuzeyIslemi != null && filters.yuzeyIslemi != 'Hepsi') {
      parts.add('Yüzey İşlemi: ${filters.yuzeyIslemi}');
    }
    if (filters.filtreDurum != null && filters.filtreDurum != 'Hepsi') {
      parts.add('Durum: ${filters.filtreDurum}');
    }
    if (filters.uretimTarihi.isNotEmpty) {
      parts.add('Üretim Tarihi: ${filters.uretimTarihi} (${filters.tarihPeriyodu})');
    }

    return parts.join(', ');
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
      subject: 'Stok Raporu',
    );
  }

  /// Downloads klasörünü al (Android için)
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // Önce doğrudan Downloads klasörünü dene
      final downloadsDir = Directory('/storage/emulated/0/Download');
      
      // Android 11+ için MANAGE_EXTERNAL_STORAGE izni gerekebilir
      // Ancak Downloads klasörüne erişim genellikle izin gerektirmez
      try {
        if (await downloadsDir.exists()) {
          // Yazma testi yap
          final testFile = File('${downloadsDir.path}/.test_write_${DateTime.now().millisecondsSinceEpoch}');
          await testFile.writeAsString('test');
          await testFile.delete();
          return downloadsDir;
        }
      } catch (e) {
        // Downloads'a yazamıyoruz, alternatif dene
      }

      // Alternatif 1: External storage directory kullan
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        // Uygulama-özel external storage (izin gerektirmez)
        return extDir;
      }
    }

    // iOS veya yedek olarak uygulama dokümanları klasörü
    return await getApplicationDocumentsDirectory();
  }
}
