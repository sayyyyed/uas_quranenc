// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_quranenc/start.dart';
import 'package:uas_quranenc/surah.dart';

class QuranApp extends StatefulWidget {
  @override
  _QuranAppState createState() => _QuranAppState();
}

class _QuranAppState extends State<QuranApp> {
  String selectedSurahIndex = "1"; // Default selected surah index

  Future<List<Map<String, String>>> fetchSurah() async {
    final response = await http.get(
      Uri.parse(
          'https://quranenc.com/api/v1/translation/sura/english_saheeh/$selectedSurahIndex'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['result'];
      return data
          .map<Map<String, String>>((dynamic item) => {
                'arabic_text': item['arabic_text'],
                'translation':
                    item['translation'].replaceAll(RegExp(r'\(\d+\)'), ''),
              })
          .toList();
    } else {
      throw Exception('Failed to load surah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //go back to start.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Start()),
            );
          },
          icon: const Icon(Icons.book),
        ),
        title: Text('Quran App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedSurahIndex,
                items: surahList.map((Map<String, String> surah) {
                  return DropdownMenuItem<String>(
                    value: surah['index']!,
                    child: Text(surah['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSurahIndex = value!;
                  });
                },
              ),
              FutureBuilder<List<Map<String, String>>>(
                future: fetchSurah(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  } else {
                    return Column(
                      children:
                          snapshot.data!.asMap().entries.map<Widget>((entry) {
                        int index = entry.key + 1;
                        var item = entry.value;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${item['arabic_text']}',
                                          style: GoogleFonts.amiri(
                                            textStyle: TextStyle(
                                              fontSize: 30,
                                              color: Colors.teal,
                                              letterSpacing: .25, //right
                                            ),
                                          ),
                                          textAlign: TextAlign
                                              .right, // Set text alignment
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${item['translation']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        softWrap: true,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
