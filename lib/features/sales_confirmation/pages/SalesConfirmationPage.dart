import 'package:flutter/material.dart';

class SalesConfirmationPage extends StatefulWidget {
  const SalesConfirmationPage({super.key});

  @override
  State<SalesConfirmationPage> createState() => _SalesConfirmationPageState();
}

class _SalesConfirmationPageState extends State<SalesConfirmationPage> {
  final TextEditingController epcController = TextEditingController();
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController bandilController = TextEditingController();
  final TextEditingController uretimTarihiController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();

  String tarihPeriyodu = "Günlük";
  String urunTipi = "Seçiniz";
  String urunTuru = "Seçiniz";
  String yuzeyIslemi = "Seçiniz";
  String filtreDurum = "Hepsi";

  List<String> periyotList = ["Günlük", "Haftalık", "Aylık", "Yıllık"];
  List<String> secenek = ["Seçiniz", "Hepsi", "Yarı Mamül", "Bitiş Mamül"];
  List<String> secenekTuru = ["Seçiniz", "Hepsi", "Granit", "Mermer", "Traverten"];
  List<String> secenekYuzeyIslemi = ["Seçiniz", "Hepsi", "Polished", "Honed", "Tumbled"];
  List<String> durumFiltre = ["Hepsi", "Stokta", "Onay Bekliyor", "Onaylandı", "Sevkiyat Tamamlandı"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          // ----------- APPBAR TUTULDU -----------
          PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBar(
              title: const Text("Satış Yönetimi"),
              backgroundColor: Colors.white60,
              centerTitle: false,
              elevation: 2,
            ),
          ),

          // ----------- GÖVDE -----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  buildReservationFilterCard(),
                  const SizedBox(height: 12),

                  Expanded(flex: 1, child: _buildDataTable()),
                  const SizedBox(height: 12),
                  Expanded(flex: 1, child: _buildDataTable2()),

                  const SizedBox(height: 10),
                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- FİLTRE KARTI -------------------
  Widget buildReservationFilterCard() {
    final inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(6));
    const contentPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 10);

    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ---- Rezervasyon Tarihi ----
                SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rezervasyon tarihi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 5),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Tarih",
                          suffixIcon: const Icon(Icons.calendar_month, size: 20),
                          border: inputBorder,
                          contentPadding: contentPadding,
                        ),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // ---- Rezervasyon Kodu ----
                _simpleField("Rez. Kodu", 130, inputBorder, contentPadding),
                const SizedBox(width: 10),

                // ---- Rezervasyon No ----
                _simpleField("Rez. No", 130, inputBorder, contentPadding),
                const SizedBox(width: 10),

                // ---- Alıcı Firma ----
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Alıcı Firma", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 5),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(value: "A", child: Text("Firma A")),
                          DropdownMenuItem(value: "B", child: Text("Firma B")),
                          DropdownMenuItem(value: "C", child: Text("Firma C")),
                        ],
                        onChanged: (value) {},
                        decoration: InputDecoration(border: inputBorder, contentPadding: contentPadding),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                _simpleField("Rez. Sorumlusu", 150, inputBorder, contentPadding),
                const SizedBox(width: 10),

                _simpleField("Satış Sorumlusu", 150, inputBorder, contentPadding),
                const SizedBox(width: 10),

                _dropdown("Tarih Periyodu", periyotList, tarihPeriyodu, (v) => setState(() => tarihPeriyodu = v!)),
                _dropdown("Durum ile Filtrele", durumFiltre, filtreDurum, (v) => setState(() => filtreDurum = v!)),

                // ---- Temizle ----
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  icon: const Icon(Icons.clear_all, size: 20),
                  label: const Text("Temizle"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _simpleField(String label, double width, OutlineInputBorder border, EdgeInsets padding) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          TextField(decoration: InputDecoration(border: border, contentPadding: padding)),
        ],
      ),
    );
  }

  // ------------------- DROPDOWN -------------------
  Widget _dropdown(String label, List<String> items, String value, Function(String?) onChange) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          DropdownButtonFormField(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChange,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- TABLO 1 -------------------
  Widget _buildDataTable() {
    return Card(
      elevation: 3,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("RezervasyonNO")),
              DataColumn(label: Text("RezervasyonKodu")),
              DataColumn(label: Text("Alıcı Firma")),
              DataColumn(label: Text("Rezervasyon Sorumlusu")),
              DataColumn(label: Text("Satış Sorumlusu")),
              DataColumn(label: Text("İşlem Tarihi")),
              DataColumn(label: Text("Durum")),
              DataColumn(label: Text("ÜrünÇıkışTarihi")),
              DataColumn(label: Text("Sevkiyat adresi")),
            ],
            rows: const [],
          ),
        ),
      ),
    );
  }

  // ------------------- TABLO 2 -------------------
  Widget _buildDataTable2() {
    return Card(
      elevation: 3,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("RezervasyonNO")),
              DataColumn(label: Text("RezervasyonKodu")),
              DataColumn(label: Text("Alıcı Firma")),
              DataColumn(label: Text("Rezervasyon Sorumlusu")),
              DataColumn(label: Text("Satış Sorumlusu")),
              DataColumn(label: Text("İşlem Tarihi")),
              DataColumn(label: Text("Durum")),
              DataColumn(label: Text("ÜrünÇıkışTarihi")),
              DataColumn(label: Text("Sevkiyat adresi")),
            ],
            rows: const [],
          ),
        ),
      ),
    );
  }

  // ------------------- BUTONLAR -------------------
  Widget _buildBottomButtons() {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _actionBtn("Rapor Oluştur"),
            _actionBtn("Packing List"),
            _actionBtn("Seçili Rezervasyona Ürün Ekle"),
            _actionBtn("Seçili Rezervasyondan Ürün Çıkar"),
            _actionBtn("Boyutları Güncelle"),
            _actionBtn("Rezervasyon Onayla"),
            _actionBtn("Rezervasyon İptal Et"),
            _actionBtn("Onayı Geri Al"),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        ),
        child: Text(text),
      ),
    );
  }
}
