import 'package:flutter/material.dart';

Widget pertemuanCardBuilder({
  required String hari,
  required String tanggal,
  required String jam,
  String? regulerTitle,
  String? regulerDesc,
  String? extendedTitle,
  String? extendedDesc,
  String? extendedPlatinumTitle,
  String? extendedPlatinumDesc,
}) {
  Widget infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(
          "${value}",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget section(String title, String? subtitle, String? desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 6),
        if ((subtitle ?? "").isNotEmpty || (desc ?? "").isNotEmpty) ...[
          Text(subtitle ?? "", style: TextStyle(fontSize: 14)),
          if (desc != null && desc.isNotEmpty)
            Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ] else
          Text("-", style: TextStyle(fontSize: 13)),
        SizedBox(height: 16),
      ],
    );
  }

  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pertemuan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            infoColumn("Hari", hari),
            infoColumn("Tanggal", tanggal),
            infoColumn("Jam", jam),
          ],
        ),
        SizedBox(height: 20),

        // Bagian untuk tiap tipe
        section("Reguler", regulerTitle, regulerDesc),
        section("Extended", extendedTitle, extendedDesc),
        section(
          "Extended + Platinum Zone",
          extendedPlatinumTitle,
          extendedPlatinumDesc,
        ),
      ],
    ),
  );
}
