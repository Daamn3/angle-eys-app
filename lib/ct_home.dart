import 'dart:convert';

import 'package:angeleyesapp/ct_bpmanage.dart';
import 'package:angeleyesapp/ct_complaints.dart';
import 'package:angeleyesapp/ct_emergency.dart';
import 'package:angeleyesapp/ct_fpmanage.dart';
import 'package:angeleyesapp/ct_location.dart';
import 'package:angeleyesapp/ct_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ct_home extends StatefulWidget {
  const ct_home({super.key});

  @override
  State<ct_home> createState() => _ct_homeState();
}

class _ct_homeState extends State<ct_home> {

String? a;
String? img;
  Future<void>profile()async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    final lid = sh.getString('lid');
    final url = sh.getString('ip');
    a=url;

    final res = await http.post(Uri.parse('$url/myapp/pro_pic/'), body:
    {
      'lid': lid
    });

    final data = json.decode(res.body);

    print(data);
    setState(() {
      img=data['photo'];

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ct_home'),
        actions: [
          IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_profile()));
           },
          icon:CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage('$a$img'),
          ),)
        ],

      ),
      body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_bpmanage()));
            },child: const Text('Manage Blind Person')),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_complaints()));
            },child: const Text('view complaints')),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_emergency()));
            },child: const Text('Emergency')),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_fpmanage()));
            },child: const Text('Manage Familiar Person')),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_location()));
            },child: const Text('view Location')),


          ],
        ),

      ),
    ),
    );
  }
}
