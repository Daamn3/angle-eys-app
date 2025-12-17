import 'package:flutter/material.dart';

class ct_complaints extends StatefulWidget {
  const ct_complaints({super.key});

  @override
  State<ct_complaints> createState() => _ct_complaintsState();
}

class _ct_complaintsState extends State<ct_complaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ct_complaints'),),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
