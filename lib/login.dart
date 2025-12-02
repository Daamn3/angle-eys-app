import 'package:flutter/material.dart';
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
            TextFormField(decoration: InputDecoration( labelText: 'Password',hintText: 'Enter Your Passwird'),controller: pass,),
            ElevatedButton(onPressed: send_data, child: Text('Login'))
          ],
        ) ,
      ),

    );
  }
  Future<void>send_data()async{
    SharedPreferences sh=await SharedPreferences.getInstance();
    var ip=sh.getString('ip');
    print(ip);
    final res=await http.post(Uri.parse('$ip/myapp/applogin/'),body: {
      'uname':uname.text.trim(),
      'pass':pass.text.trim(),
    });

  }
}
