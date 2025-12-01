import 'package:flutter/material.dart';

class CancelPage extends StatefulWidget {
  const CancelPage({super.key});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
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
  List<String> secenekTuru = [
    "Seçiniz",
    "Hepsi",
    "Granit",
    "Mermer",
    "Traverten"
  ];
  List<String> secenekYuzeyIslemi = [
    "Seçiniz",
    "Hepsi",
    "Polished",
    "Honed",
    "Tumbled"
  ];
  List<String> durumFiltre = [
    "Hepsi",
    "Stokta",
    "Onay Bekliyor",
    "Onaylandı",
    "Sevkiyat Tamamlandı"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ----------- APPBAR TUTULDU -----------
        PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: const Text("İptal Yönetimi"),
            backgroundColor: Colors.white60,
            centerTitle: false,
            elevation: 2,
          ),
        ),

        // 🔥 Geri kalan tamamen body
        Expanded(
          child: Container(
            color: Colors.grey.shade200,
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
        )
      ],
    );
  }

  // ---------------------- FİLTRE KARTI ----------------------
  Widget buildReservationFilterCard() {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
    );
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
                // Rez Kodu
                _inputBox("Rez. Kodu", 130, contentPadding, inputBorder),

                const SizedBox(width: 10),
                _inputBox("Rez. No", 130, contentPadding, inputBorder),

                const SizedBox(width: 10),
                _dropdownBox(
                  "Alıcı Firma",
                  width: 160,
                  items: const ["Firma A", "Firma B", "Firma C"],
                  onChanged: (_) {},
                ),

                const SizedBox(width: 10),
                _inputBox("Satış Sorumlusu", 150, contentPadding, inputBorder),

                const SizedBox(width: 10),
                _dateInput("Rezervasyon Tarihi", 140, contentPadding, inputBorder),

                const SizedBox(width: 10),
                _dateInput("İptal Tarihi", 140, contentPadding, inputBorder),

                const SizedBox(width: 10),
                _dropdown("Tarih Periyodu", periyotList, tarihPeriyodu,
                        (v) => setState(() => tarihPeriyodu = v!)),

                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.clear_all, size: 20),
                  label: const Text("Temizle"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- YARDIMCI UI METODLARI ----------------------
  Widget _inputBox(String label, double width,
      EdgeInsets padding, OutlineInputBorder border) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              border: border,
              contentPadding: padding,
            ),
          )
        ],
      ),
    );
  }

  Widget _dropdownBox(
      String label, {
        required double width,
        required List<String> items,
        required ValueChanged<String?> onChanged,
      }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          DropdownButtonFormField(
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateInput(String label, double width,
      EdgeInsets padding, OutlineInputBorder border) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Tarih",
              suffixIcon: const Icon(Icons.calendar_month, size: 20),
              border: border,
              contentPadding: padding,
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
    );
  }

  Widget _dropdown(String label, List<String> items, String value,
      Function(String?) onChange) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          DropdownButtonFormField(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChange,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- TABLOLAR ----------------------
  Widget _buildDataTable() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("RezervasyonNO")),
              DataColumn(label: Text("RezervasyonKodu")),
              DataColumn(label: Text("Alıcı Firma")),
              DataColumn(label: Text("Satış Sorumlusu")),
              DataColumn(label: Text("İşlem Tarihi")),
              DataColumn(label: Text("İptal Tarihi")),
              DataColumn(label: Text("İptal Eden Personel")),
              DataColumn(label: Text("İptal Sebebi")),
            ],
            rows: [],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable2() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("RezervasyonNO")),
              DataColumn(label: Text("RezervasyonKodu")),
              DataColumn(label: Text("Alıcı Firma")),
              DataColumn(label: Text("Satış Sorumlusu")),
              DataColumn(label: Text("İşlem Tarihi")),
              DataColumn(label: Text("İptal Tarihi")),
              DataColumn(label: Text("İptal Eden Personel")),
              DataColumn(label: Text("İptal Sebebi")),
            ],
            rows: [],
          ),
        ),
      ),
    );
  }

  // ----------------------- ALT BUTONLAR ------------------------
  Widget _buildBottomButtons() {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
      padding: const EdgeInsets.only(right: 8),
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
