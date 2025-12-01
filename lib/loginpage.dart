// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
//
//
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Restaurant Login System',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LoginPage(),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.teal[200]!, Colors.teal[400]!],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 // Smart Cafe Heading
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 50.0),
//                   child: Text(
//                     'Smart Cafe',
//                     style: TextStyle(
//                       fontSize: 42,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 2.0,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 5.0,
//                           color: Colors.black45,
//                           offset: Offset(2.0, 2.0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(30.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15,
//                         offset: Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.teal[100],
//                         child: Icon(
//                           Icons.lock_outline,
//                           color: Colors.teal,
//                           size: 60,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Restaurant Login',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal[800],
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextField(
//                         controller: _usernameController,
//                         decoration: InputDecoration(
//                           labelText: 'Username',
//                           prefixIcon: Icon(Icons.person, color: Colors.teal),
//                           filled: true,
//                           fillColor: Colors.teal[50],
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             borderSide: BorderSide(color: Colors.teal[200]!),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             borderSide: BorderSide(color: Colors.teal[400]!),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: Icon(Icons.lock, color: Colors.teal),
//                           filled: true,
//                           fillColor: Colors.teal[50],
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             borderSide: BorderSide(color: Colors.teal[200]!),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             borderSide: BorderSide(color: Colors.teal[400]!),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: () {
//                           senddata();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.teal[600], // Button color
//                           padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           textStyle: TextStyle(fontSize: 18),
//                         ),
//                         child: Text('Login'),
//                       ),
//                       SizedBox(height: 20),
//                       // Registration link
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Don't have an account?"),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => register()),
//                               );
//                             },
//                             child: Text('Register here'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void senddata() async {
//     String username = _usernameController.text;
//     String password = _passwordController.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     final urls = Uri.parse(url + "/android_login");
//     try {
//       final response = await http.post(urls, body: {
//         'username': username,
//         'password': password,
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Fluttertoast.showToast(msg: 'Success');
//           String type = jsonDecode(response.body)['type'];
//
//           String lid = jsonDecode(response.body)['lid'].toString();
//           sh.setString("lid", lid);
//           if (type == 'supplier') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => supplierHomePage()),
//             );
//           }
//           else if (type == 'delivery_staff') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => delivery_home()),
//             );
//           } else if (type == 'user') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => userhome()),
//             );
//           }
//         } else {
//           Fluttertoast.showToast(msg: 'No User Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }
//
