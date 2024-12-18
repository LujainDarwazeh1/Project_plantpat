import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:plantpat/src/screen/ipaddress.dart'; 
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/shopping_cart.dart'; 

class RatingPage extends StatefulWidget {
  final List<int> plantIds;

  RatingPage({required this.plantIds});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late Future<List<Map<String, dynamic>>> _plantsFuture;
  final List<Map<String, dynamic>> ratings = [];

  @override
  void initState() {
    super.initState();
    _plantsFuture = _fetchPlants(widget.plantIds);
  }

  Future<List<Map<String, dynamic>>> _fetchPlants(List<int> ids) async {
    final List<Map<String, dynamic>> plants = [];
    for (var id in ids.toSet()) { 
      final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/plantbyid?plant_id=$id'));

      if (response.statusCode == 200) {
        final plantData = jsonDecode(response.body);

       
        if (plantData['image'] == null) {
          plantData['image'] = [];
        }

        plants.add(plantData);
      } else {
        throw Exception('Failed to load plant data');
      }
    }
    return plants;
  }

void _clearIds() {
 
    if (CartPageState.idsplant != null) {
      setState(() {
        CartPageState.idsplant.clear();
      });
    }
  }

  Future<void> _submitRatings() async {
    
    await _PlantRatingWidgetState. submitRating(ratings); 
      setState(() {
        CartPageState.idsplant.clear(); 
      });
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 200), () {
      Flushbar(
        message: "Thank you for your feedback",
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
    });
   
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Ratings'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
             
              Navigator.pop(context); 
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No plants found'));
          } else {
            final plants = snapshot.data!;
            return Column(
              children: [
              
                Expanded(
  child: ListView.builder(
    itemCount: plants.length,
    itemBuilder: (context, index) {
      final plant = plants[index];
      return PlantRatingWidget(
        imageData: plant['image'] ?? {},
        name: plant['name'] ?? 'Unknown',
        plantId: plant['id'], 
        onRatingChanged: (plantId, rating) {
          setState(() {
            int existingIndex = ratings.indexWhere(
                (entry) => entry['plant_id'] == plantId);

            if (existingIndex != -1) {
              ratings[existingIndex]['rating'] = rating;
            } else {
              ratings.add({
                'plant_id': plantId,
                'rating': rating
              });
            }
          });
        },
      );
    },
  ),
),

                Container(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _submitRatings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      textStyle: TextStyle(fontSize: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
class PlantRatingWidget extends StatefulWidget {
  final Map<String, dynamic> imageData;
  final String name;
  final int plantId; 
  final void Function(int, double) onRatingChanged; 

  PlantRatingWidget({
    required this.imageData,
    required this.name,
    required this.plantId, 
    required this.onRatingChanged,
  });

  @override
  _PlantRatingWidgetState createState() => _PlantRatingWidgetState();
}

class _PlantRatingWidgetState extends State<PlantRatingWidget> {
  double rating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget displayImage;

    if (widget.imageData.containsKey('data') &&
        widget.imageData['data'] is List<dynamic>) {
      try {
        List<int> imageBytes = List<int>.from(widget.imageData['data']);
        Uint8List uint8List = Uint8List.fromList(imageBytes);
        displayImage = Image.memory(
          uint8List,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } catch (e) {
        print('Error converting image data: $e');
        displayImage = Icon(Icons.image, size: 100, color: Colors.grey);
      }
    } else {
      displayImage = Icon(Icons.image, size: 100, color: Colors.grey);
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 300,
                maxWidth: double.infinity,
              ),
              child: displayImage,
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
                widget.onRatingChanged(widget.plantId, rating); 
              },
            ),
            SizedBox(height: 8.0),
            Text(
              widget.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

static Future<void> submitRating(List<Map<String, dynamic>> ratings) async {
  print('Submitting Ratings: $ratings');

  try {
    final response = await http.post(
      Uri.parse('http://$ip:3000/plantpat/plant/addRatingProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': Login.idd,
        'ratings': ratings,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Rating number added successfully');
    } else {
      print('Failed to add rating number');
    }
  } catch (e) {
    print('Error submitting rating: $e');
  }
}

}