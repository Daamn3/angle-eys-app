import 'dart:convert';

import 'package:angeleyesapp/ct_home.dart';
import 'package:angeleyesapp/ct_register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController uname = TextEditingController();
  TextEditingController pass= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Angel Eyes LoginPage'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(decoration: InputDecoration( labelText: 'User Name',hintText: 'Enter Your User name') ,controller: uname,),
            TextFormField(decoration: InputDecoration( labelText: 'Password',hintText: 'Enter Your Password'),controller: pass,),
            ElevatedButton(onPressed: send_data, child: Text('Login')),
            TextButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));}, child: Text('create an account')),
          ],
        ) ,
      ),

    );
  }
  Future<void>send_data()async{
    SharedPreferences sh=await SharedPreferences.getInstance();
    var ip=sh.getString('ip');
    print(ip);
    final res=await http.post(Uri.parse('$ip/myapp/ct_home/'),body: {
      'uname':uname.text.trim(),
      'pass':pass.text.trim(),
    });
    final data=json.decode(res.body);
    String message=data['message'].toString();
    print(message);
    if(message=='login successfull'){
      sh.setString('lid',data['lid'].toString() );

      Navigator.push(context, MaterialPageRoute(builder: (context)=>ct_home()));
    }
    else{
      Fluttertoast.showToast(msg: "login invalid");
    }

  }
}
