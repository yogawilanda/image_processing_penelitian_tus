import 'package:flutter/material.dart';

class ScanList extends StatelessWidget {
  final List<Map<String, dynamic>> scanData = [
    {
      "scan_id": 1,
      "container_number": {"value": "TRLU1234567", "confidence_score": 0.95},
      "scan_time": "2024-02-10T16:02:00Z",
      "location": {"latitude": -7.256389, "longitude": 112.780533},
      "errors": []
    },
    {
      "scan_id": 2,
      "container_number": {"value": "TRLU7654321", "confidence_score": 0.92},
      "scan_time": "2024-02-10T16:15:30Z",
      "location": {"latitude": -8.056712, "longitude": 118.879045},
      "errors": ["Damaged seal"]
    },
    {
      "scan_id": 3,
      "container_number": {"value": "MSKU8901234", "confidence_score": 0.98},
      "scan_time": "2024-02-10T16:25:45Z",
      "location": {"latitude": -5.381267, "longitude": 123.891532},
      "errors": []
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: double.maxFinite,
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: scanData.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${scanData[index]["scan_id"]}'),
            ),
            title: Text(
                'Container: ${scanData[index]["container_number"]["value"]}'),
            subtitle: Text(
                'Scan ID: ${scanData[index]["scan_id"]} | Scan Time: ${scanData[index]["scan_time"]}'),
            onTap: () {
              print('Tapped on scan ${scanData[index]["scan_id"]}');
            },
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_rounded),
              color: Colors.red.shade700,
            ),
          );
        },
      ),
    );
  }
}
