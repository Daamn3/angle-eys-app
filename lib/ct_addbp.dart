import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class addbp extends StatefulWidget {
  const addbp({super.key});

  @override
  State<addbp> createState() => _RegisterState();
}

class _RegisterState extends State<addbp> {
  String? a;
  TextEditingController name= TextEditingController();
  TextEditingController imei= TextEditingController();
  TextEditingController place= TextEditingController();
  TextEditingController post= TextEditingController();
  TextEditingController pin= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController email=TextEditingController();
  File? img;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('register'),),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextFormField(decoration: InputDecoration(labelText: 'Name',hintText: 'enter your  name'),controller: name,),
              TextFormField(decoration: InputDecoration(labelText: 'IMEI Number',hintText: 'enter your imei numer'),controller: imei,),
              TextFormField(decoration: InputDecoration(labelText: 'email',hintText: 'enter your email'),controller: email,),
              // DropdownButton(items:['male','female'].map((String? newv)=> DropdownMenuItem(value:value,child: Text('Value',)).toList(), onChanged: (String? newv){setState(() {
              //   a=newv;
              // });}))
              // DropdownButtonFormField<String>(value: a, items: ['male','female'].map((String value) => DropdownMenuItem(value:value,child:Text(value))).toList(), onChanged: (String? newvalue){
              //   setState(() {
              //     a=newvalue;
              //   });
              // }),
              TextFormField(decoration: InputDecoration(labelText: 'Place',hintText: 'enter your place'),controller: place,),
              TextFormField(decoration: InputDecoration(labelText: 'Post',hintText: 'enter your Postal area'),controller: post,),
              TextFormField(decoration: InputDecoration(labelText: 'pin',hintText: 'enter your pin'),controller: pin,),
              TextFormField(decoration: InputDecoration(labelText: 'phone Number',hintText: 'enter your phone number'),controller: phone,),
              ElevatedButton(onPressed: image, child: Text('Select photo')),
              ElevatedButton(onPressed: send_data, child: Text('Sign up')),


            ],
          ),
        ),
      ),
    );
  }
  Future<void> image() async {
    final pickedimage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        img = File(pickedimage.path);
      });
    }
    else {
      print('img not selected');
      Fluttertoast.showToast(msg: 'please select an image');
    }
  }
  Future<void> send_data() async{

    SharedPreferences sd=await SharedPreferences.getInstance();
    String? ipc=sd.getString('ip');
    String? lid=sd.getString('lid');

    if(ipc==null){
      Fluttertoast.showToast(msg: "server ip not found");
      return;
    }

    final uri =Uri.parse('$ipc/myapp/addbp/');
    var request = http.MultipartRequest('POST',uri);
    request.fields['name']=name.text;
    request.fields['imei']=imei.text;
    request.fields['place']=place.text;
    request.fields['post']=post.text;
    request.fields['pin']=pin.text;
    request.fields['phone']=phone.text;
    request.fields['email']=email.text;
    request.fields['lid']=lid!;
    if (img !=null)
    {
      request.files
          .add(await http.MultipartFile.fromPath('photo', img!.path ));
    }
    try{
      var response=await request.send();
      var respStr =await response.stream.bytesToString();
      var data=jsonDecode(respStr);

      if(response.statusCode ==200 && data['status']=='registered successfully'){
        Fluttertoast.showToast(msg: 'registered successfully');
      }
      else if(response.statusCode==200 && data['status']=="user already exists"){
        Fluttertoast.showToast(msg: "User already exists");
      }
    }catch(e){
      Fluttertoast.showToast(msg: "Error:$e");
    }

  }
}

