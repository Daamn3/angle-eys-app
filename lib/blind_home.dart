import 'package:angeleyesapp/ct_bpmanage.dart';
import 'package:angeleyesapp/ct_complaints.dart';
import 'package:angeleyesapp/ct_emergency.dart';
import 'package:angeleyesapp/ct_fpmanage.dart';
import 'package:angeleyesapp/ct_location.dart';
import 'package:angeleyesapp/login.dart';
import 'package:flutter/material.dart';
class BlindHome extends StatefulWidget {
  const BlindHome({super.key});

  @override
  State<BlindHome> createState() => _BlindHomeState();
}


class _BlindHomeState extends State<BlindHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Blind home'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
          }, icon: Icon(Icons.login_outlined))
        ],
      ),
      body: Center(
        child: Column(
          children: [


          ],
        ),
      ),

    );
  }
}
