import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Editprof extends StatefulWidget {
  const Editprof({super.key});

  @override
  State<Editprof> createState() => _EditprofState();
}

class _EditprofState extends State<Editprof> {
  String? a;
  String? lid;
  TextEditingController fname= TextEditingController();
  TextEditingController lname= TextEditingController();
  TextEditingController place= TextEditingController();
  TextEditingController post= TextEditingController();
  TextEditingController pin= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController email=TextEditingController();
  File? img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit your Profile'),
          backgroundColor: Colors.orangeAccent
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
                            TextFormField(decoration: InputDecoration(labelText: 'First Name',hintText: 'enter your first name'),controller: fname,),
              TextFormField(decoration: InputDecoration(labelText: 'Last Name',hintText: 'enter your last name'),controller: lname,),
              // DropdownButton(items:['male','female'].map((String? newv)=> DropdownMenuItem(value:value,child: Text('Value',)).toList(), onChanged: (String? newv){setState(() {
              //   a=newv;
              // });}))
              DropdownButtonFormField<String>(value: a, items: ['male','female'].map((String value) => DropdownMenuItem(value:value,child:Text(value))).toList(), onChanged: (String? newvalue){
                setState(() {
                  a=newvalue;
                });
              }),
              TextFormField(decoration: InputDecoration(labelText: 'email',hintText: 'enter your email'),controller: email,),
              TextFormField(decoration: InputDecoration(labelText: 'Place',hintText: 'enter your place'),controller: place,),
              TextFormField(decoration: InputDecoration(labelText: 'Post',hintText: 'enter your Postal area'),controller: post,),
              TextFormField(decoration: InputDecoration(labelText: 'pin',hintText: 'enter your pin'),controller: pin,),
              TextFormField(decoration: InputDecoration(labelText: 'phone Number',hintText: 'enter your phone number'),controller: phone,),
              ElevatedButton(onPressed: pickimage, child: Text('Choose an image')),
              ElevatedButton(onPressed: Send_data, child: Text('Submit'))

            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState(){
    super.initState();
    profiledetails();
  }


  Future<void> profiledetails() async{
    print('prof wrk');
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? storedIp = sp.getString('ip');
    String? ipstr = sp.getString('ip');
    String? lid = sp.getString('lid');
    final res = await http.post(Uri.parse('$ipstr/myapp/Editprof/'), body: {
      'lid': lid
    });
    final data = json.decode(res.body);
    print('$data adfadf');
    setState(() {
      ipstr=storedIp??'';
      fname.text = data['fname'];
      lname.text = data['lname'];
      // a = data['gender'];
      place.text = data['place'];
      post.text = data['post'];
      pin.text = data['pin'].toString();
      phone.text = data['phone'].toString();
      email.text = data['email'];
      img = data['photo'];
    });
  }

  Future<void> pickimage() async {
    final pickedimg = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedimg != null) {
      setState(() {
        img = File(pickedimg.path);
      });
    }
    else {
      print('Image not detected');
      Fluttertoast.showToast(msg: 'Image not detected!! Select an image.');
    }
  }

  Future<void> Send_data() async{
    SharedPreferences sp=await SharedPreferences.getInstance();
    String? ipstr=sp.getString('ip');
    String lid=sp.getString('lid')??"";

    if (ipstr == null){
      Fluttertoast.showToast(msg: "Server URL not found");
      return;
    }
    final uri=Uri.parse('$ipstr/myapp/Editprof_post/');
    var request = http.MultipartRequest('POST',uri);
    request.fields['lid']=lid;
    request.fields['fname']=fname.text;
    request.fields['lname']=lname.text;
    request.fields['place']=place.text;
    request.fields['post']=post.text;
    request.fields['pin']=pin.text;
    request.fields['phone']=phone.text;
    request.fields['email']=email.text;
    request.fields['gender']=a.toString();
    if (img != null){
      request.files
          .add(await http.MultipartFile.fromPath('photo', img!.path));
    }
    try{
      var response= await request.send();
      var respStr= await response.stream.bytesToString();
      var data= jsonDecode(respStr);
      if (response.statusCode == 200 && data['status'] == "User details Edited Successfully!") {
        Fluttertoast.showToast(msg: "Edited successfully!");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}