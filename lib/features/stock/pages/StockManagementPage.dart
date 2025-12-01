import 'package:flutter/material.dart';

class StokYonetimiPage extends StatefulWidget {
  const StokYonetimiPage({super.key});

  @override
  State<StokYonetimiPage> createState() => _StokYonetimiPageState();
}

class _StokYonetimiPageState extends State<StokYonetimiPage> {
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
    return Column(
      children: [
        // 🔥 SAYFAYA ÖZEL APPBAR – Drawer ANA İSKELETTEN gelir!
        AppBar(
          title: const Text("Stok Yönetimi"),
          backgroundColor: Colors.white70,
          centerTitle: false,
        ),

        // 🔥 BODY
        Expanded(
          child: Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTopFilters(),
                  const SizedBox(height: 12),

                  Expanded(child: _buildDataTable()),
                  const SizedBox(height: 10),

                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------- FILTERS ------------------------
  Widget _buildTopFilters() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _input("EPC", epcController),
                _input("Barkod", barkodController, hasButton: true, buttonText: "Barkodu Oku"),
                _input("Bandıl No", bandilController),
                _input("Üretim Tarihi", uretimTarihiController, isDate: true),
                _dropdown("Tarih Periyodu", periyotList, tarihPeriyodu, (v) => setState(() => tarihPeriyodu = v!)),
                _input("Plaka No", plakaController),
                _dropdown("Ürün Tipi", secenek, urunTipi, (v) => setState(() => urunTipi = v!)),
                _dropdown("Ürün Türü", secenekTuru, urunTuru, (v) => setState(() => urunTuru = v!)),
                _dropdown("Yüzey İşlemi", secenekYuzeyIslemi, yuzeyIslemi, (v) => setState(() => yuzeyIslemi = v!)),
                _dropdown("Durum ile Filtrele", durumFiltre, filtreDurum, (v) => setState(() => filtreDurum = v!)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- Input Builder -------------------
  Widget _input(String label, TextEditingController controller,
      {bool isDate = false, bool hasButton = false, String? buttonText}) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isDate,
                  onTap: isDate
                      ? () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.text = "${date.day}.${date.month}.${date.year}";
                    }
                  }
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
              if (hasButton) const SizedBox(width: 6),
              if (hasButton)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black),
                  child: Text(buttonText ?? "..."),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------- Dropdown ------------------------
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- TABLE ---------------------------
  Widget _buildDataTable() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("EPC")),
            DataColumn(label: Text("BarkodNo")),
            DataColumn(label: Text("BandılNo")),
            DataColumn(label: Text("PlakaNo")),
            DataColumn(label: Text("ÜrünTipi")),
            DataColumn(label: Text("ÜrünTürü")),
            DataColumn(label: Text("Yüzeyİşlemi")),
            DataColumn(label: Text("Seleksiyon")),
            DataColumn(label: Text("ÜretimTarihi")),
            DataColumn(label: Text("Kalinlik")),
            DataColumn(label: Text("PlakaAdedi")),
            DataColumn(label: Text("StokEn")),
            DataColumn(label: Text("StokBoy")),
            DataColumn(label: Text("StokAlan")),
            DataColumn(label: Text("StokTonaj")),
            DataColumn(label: Text("SatisEn")),
            DataColumn(label: Text("SatisBoy")),
            DataColumn(label: Text("SatisAlan")),
            DataColumn(label: Text("SatisTonaj")),
            DataColumn(label: Text("Durum")),
            DataColumn(label: Text("RezervasyonNo")),
            DataColumn(label: Text("KaydedenPersonel")),
            DataColumn(label: Text("ÜrünCikisTarihi")),
            DataColumn(label: Text("AliciFirma")),
            DataColumn(label: Text("BaseUrl")),
            DataColumn(label: Text("RequestClientOptions")),
            DataColumn(label: Text("TableName")),
            DataColumn(label: Text("PrimaryKey")),
          ],
          rows: [],
        ),
      ),
    );
  }

  // ----------------------- BUTTONS ------------------------
  Widget _buildBottomButtons() {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _actionBtn("Stok Raporu"),
            _actionBtn("Ürün Güncelle"),
            _actionBtn("Sil"),
            _actionBtn("Rezervasyon Bilgisi"),
            _actionBtn("Yenile"),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        ),
        child: Text(text, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
