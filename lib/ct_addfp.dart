import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class addfp extends StatefulWidget {
  const addfp({super.key});

  @override
  State<addfp> createState() => _RegisterState();
}

class _RegisterState extends State<addfp> {

  TextEditingController name = TextEditingController();
  TextEditingController relation = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController post = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  File? img;

  List blinds = [];
  String? selectedBid;

  @override
  void initState() {
    super.initState();
    loadBlinds();
  }


  Future<void> loadBlinds() async {
    SharedPreferences sd = await SharedPreferences.getInstance();
    String? ipc = sd.getString('ip');
    String? lid = sd.getString('lid');

    final uri = Uri.parse('$ipc/myapp/caretaker_view_blind_for_fami/');
    var response = await http.post(uri, body: {'lid': lid});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'ok') {
        setState(() {
          blinds = data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('add fp')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [


              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Blind person',
                ),
                value: selectedBid,
                items: blinds.map<DropdownMenuItem<String>>((b) {
                  return DropdownMenuItem<String>(
                    value: b['bid'].toString(),
                    child: Text(b['name']),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBid = val;
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: name,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Relation'),
                controller: relation,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: email,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Place'),
                controller: place,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Post'),
                controller: post,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Pin'),
                controller: pin,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                controller: phone,
              ),

              ElevatedButton(onPressed: image, child: const Text('Select photo')),
              ElevatedButton(onPressed: send_data, child: const Text('Sign up')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> image() async {
    final pickedimage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        img = File(pickedimage.path);
      });
    } else {
      Fluttertoast.showToast(msg: 'please select an image');
    }
  }

  Future<void> send_data() async {
    if (selectedBid == null) {
      Fluttertoast.showToast(msg: "Please select blind person");
      return;
    }

    SharedPreferences sd = await SharedPreferences.getInstance();
    String? ipc = sd.getString('ip');
    String? lid = sd.getString('lid');

    final uri = Uri.parse('$ipc/myapp/addfp/');
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name.text;
    request.fields['relation'] = relation.text;
    request.fields['place'] = place.text;
    request.fields['post'] = post.text;
    request.fields['pin'] = pin.text;
    request.fields['phone'] = phone.text;
    request.fields['email'] = email.text;
    request.fields['lid'] = lid!;
    request.fields['bid'] = selectedBid!;

    if (img != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', img!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (data['status'] == 'registered successfully') {
        Fluttertoast.showToast(msg: 'registered successfully');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
