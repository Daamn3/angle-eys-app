import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ct_profile extends StatefulWidget {
  const ct_profile({super.key});

  @override
  State<ct_profile> createState() => _ct_profileState();
}

class _ct_profileState extends State<ct_profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile();
  }
  String? a;
  String? fname;
  String? lname;
  String? gender;
  String? place;
  String? post;
  String? pin;
  String? phone;
  String? email;
  String? photo;


  Future<void>profile()async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    final lid = sh.getString('lid');
    final url = sh.getString('ip');
    a=url;
  final res = await http.post(Uri.parse('$url/myapp/pro_det/'), body:
  {
  'lid': lid
  });

  final data = json.decode(res.body);
  print(data);
  setState(() {

    fname=data['fname'];
    lname=data['lname'];
    gender=data['gender'];
    place=data['place'];
    post=data['post'];
    pin=data['pin'].toString();
    phone=data['phone'];
    email=data['email'];
    photo=data['photo'];

    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ct_profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('First name : $fname'),
              Text('Last name : $lname'),
              Text('Gender : $gender'),
              Text('Place : $place'),
              Text('Postal Area : $post'),
              Text('PIN Code : $pin'),
              Text('Phone Number : $phone'),
              Text('Email : $email'),
              Image.network('$a$photo'),

            ],
          ),
        ),
      ),
    );
  }
}
