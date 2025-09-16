import 'package:flutter/material.dart';

Widget pertemuanCardBuilder({
  required String hari,
  required String tanggal,
  required String jam,
  required String pertemuanTitle,
  required String pertemuanDesc,
  required String extended,
  required String extendedPlatinum,
}) {
  Widget infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
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
        Text(
          "Reguler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 6),
        Text(pertemuanTitle, style: TextStyle(fontSize: 14)),
        Text(
          pertemuanDesc,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        Text(
          "Extended",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 6),
        Text(
          extended.isNotEmpty ? extended : "-",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 16),
        Text(
          "Extended + Platinum Zone",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 6),
        Text(
          extendedPlatinum.isNotEmpty ? extendedPlatinum : "-",
          style: TextStyle(fontSize: 13),
        ),
      ],
    ),
  );
}
