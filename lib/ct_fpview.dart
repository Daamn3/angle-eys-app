import 'dart:convert';
import 'package:angeleyesapp/ct_addfp.dart';
import 'package:angeleyesapp/ct_editbp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ct_addbp.dart';
import 'ct_home.dart';

class ct_fpview extends StatelessWidget {
  const ct_fpview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'manage familiar person',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewBlindPersons(),
    );
  }
}

class ViewBlindPersons extends StatefulWidget {
  const ViewBlindPersons({super.key});

  @override
  State<ViewBlindPersons> createState() => _ViewBlindPersonsState();
}

class _ViewBlindPersonsState extends State<ViewBlindPersons> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewHistory();
  }

  Future<void> viewHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('ip') ?? '';
      String lid = prefs.getString('lid') ?? '';

      String apiUrl = '$baseUrl/myapp/viewfp/';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'lid': lid,
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          List<Map<String, dynamic>> tempList = [];

          for (var item in jsonData['data']) {
            tempList.add({
              'BLIND': item['BLIND'],
              'name': item['name'],
              'relation': item['relation'],
              'place': item['place'],
              'post': item['post'],
              'pin': item['pin'],
              'phone': item['phone'],
              'email': item['email'],
              'photo': baseUrl + item['photo'],
            });
          }

          setState(() {
            history = tempList;
            isLoading = false;
          });
        } else {
          isLoading = false;
        }
      } else {
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
    }
  }

  // ✅ DELETE FUNCTION (ADDED)
  Future<void> deleteBlindPerson(String bid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('ip') ?? '';

      String apiUrl = '$baseUrl/myapp/delete_fp/';

      var response = await http.post(
        Uri.parse(apiUrl),
        body: {'bid': bid},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['key'] == 'Delete Successfull') {
          setState(() {
            history.removeWhere(
                    (item) => item['id'].toString() == bid);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deleted successfully')),
          );
        }
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'familiar person',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ct_home()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addfp()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(
        child: Text(
          'No data available.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item['photo'] != ''
                      ? Image.network(
                    item['photo'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return const Text(
                          "Image not available");
                    },
                  )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  Text("BLIND: ${item['BLIND']}"),
                  Text("name: ${item['name']}"),
                  Text("relation: ${item['relation']}"),
                  Text("place: ${item['place']}"),
                  Text("post: ${item['post']}"),
                  Text("pin: ${item['pin']}"),
                  Text("phone: ${item['phone']}"),
                  Text("email: ${item['email']}"),
                  const SizedBox(height: 10),

                  // EDIT BUTTON
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setString(
                          'bid', item['id'].toString());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => editbp(),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),

                  // DELETE BUTTON (ADDED)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      deleteBlindPerson(
                          item['id'].toString());
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
