import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
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

  List<String> periyotList = ["Günlük", "Haftalık", "Aylık","Yıllık"];
  List<String> secenek = ["Seçiniz","Hepsi", "Yarı Mamül", "Bitiş Mamül"];
  List<String> secenekTuru = ["Seçiniz","Hepsi", "Granit", "Mermer","Traverten"];
  List<String> secenekYuzeyIslemi = ["Seçiniz","Hepsi", "Polished", "Honed","Tumbled"];
  List<String> durumFiltre = ["Hepsi", "Stokta", "Onay Bekliyor","Onaylandı","Sevkiyat Tamamlandı"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          // ------ APPBAR BURADA KALIYOR ------
          PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBar(
              title: const Text("Rezervasyon Oluşturma Ekranı"),
              centerTitle: false,
              backgroundColor: Colors.white60,
              elevation: 2,
            ),
          ),

          // ------ SAYFA İÇERİĞİ ------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  buildReservationInfoCard(),
                  _buildTopFilters(),
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

  Widget buildReservationInfoCard() {
    // 1. Kartı sola yaslamak ve içeriği kadar yer kaplamasını sağlamak için Align kullanıyoruz.
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        // 2. İç padding'i biraz düşürerek (12 -> 8) kenar boşluklarını azalttık.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // 3. Row'un sadece çocukları kadar genişlemesini sağlıyoruz.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- İşlem Tarihi --------
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "İşlem Tarihi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Tarih seçin",
                          suffixIcon: const Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
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

                const SizedBox(width: 20),

                // -------- Rezervasyon Kodu --------
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rezervasyon Kodu",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Rezervasyon No --------
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rezervasyon No",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Alıcı Firma Dropdown --------
                SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alıcı Firma",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(value: "A", child: Text("Firma A")),
                          DropdownMenuItem(value: "B", child: Text("Firma B")),
                          DropdownMenuItem(value: "C", child: Text("Firma C")),
                        ],
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // -------- Firma Seç veya Ekle (buton etikete hizalı) --------
                SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Etiket yüksekliği kadar boşluk bırak (label + gap)
                      const SizedBox(height: 26),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 14),
                        ),
                        child: const Text("Firma Seç , Ekle"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Rezervasyon Sorumlusu --------
                SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rezervasyon Sorumlusu",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Afsuam RFID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Temizle (buton etikete hizalı) --------
                SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26, vertical: 14),
                        ),
                        child: const Text("Temizle"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // ---------------------- FILTERS ------------------------
  Widget _buildTopFilters() {
    // 1. Align ile sarmalayarak kartın tüm genişliğe yayılmasını engelliyoruz.
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        // Kartın dış kenar boşluklarını kontrol etmek isterseniz margin ekleyebilirsiniz
        // margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        // 2. İç padding'i 12'den 8'e düşürdük (daha sıkı görünüm için)
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          // 3. Sabit Height (140px) veren SizedBox'ı kaldırdık.
          // Böylece kart sadece içindeki inputların boyu kadar uzayacak.
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // Row'un da sadece çocukları kadar yer kaplamasını garantiye alıyoruz
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _input("EPC", epcController),
                _input("Barkod", barkodController,
                    hasButton: true,
                    buttonText: "Barkodu Oku",
                    buttonTextColor: Colors.black),
                _input("Bandıl No", bandilController),
                _input("Üretim Tarihi", uretimTarihiController, isDate: true),
                _dropdown("Tarih Periyodu", periyotList, tarihPeriyodu,
                        (v) => setState(() => tarihPeriyodu = v!)),
                _dropdown("Durum ile Filtrele", durumFiltre, filtreDurum,
                        (v) => setState(() => filtreDurum = v!)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- Input Builder -------------------
  Widget _input(String label, TextEditingController controller,
      {bool isDate = false, bool hasButton = false, String? buttonText, Color? buttonTextColor}) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isDate,
                  onTap: isDate
                      ? () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.text =
                      "${date.day}.${date.month}.${date.year}";
                    }
                  }
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
              if (hasButton) const SizedBox(width: 6),
              if (hasButton)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: buttonTextColor ?? Colors.black),
                  child: Text(buttonText ?? "..."),
                )
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------- Dropdown ------------------------
  Widget _dropdown(String label, List<String> items, String value,
      Function(String?) onChange) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          DropdownButtonFormField(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
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
      ),
    );
  }

  // ---------------------- TABLE ---------------------------
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
      ),
    );
  }

  // ----------------------- BUTTONS ------------------------
  Widget _buildBottomButtons() {
    return SizedBox(
      height: 64, // gerekirse ayarla
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _actionBtn("Rezervasyon ekle"),
            _actionBtn("Rezervasyondan çıkar"),
            _actionBtn("Boyutları Güncelle"),
            _actionBtn("Boyutları Güncelle"),
            _actionBtn("Rezervasyon Oluştur"),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
      child: Text(text),
    );
  }
}
