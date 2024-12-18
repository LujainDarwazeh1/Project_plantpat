import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/searchresults.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  List<String> _searchResults = [];
  static final List<String> listItem = []; 

  int _selectedIndex = 1;


void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      break;
    case 1:  // This case handles the navigation to SearchPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
      break;
    case 3:
     
      break;
  }
}

  void _updateSearchResults(String query) {
    if (query.isNotEmpty) {
      searchGet(query);  
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _addToSearchHistory(String item) {
    if (_searchHistory.contains(item)) {
      _searchHistory.remove(item);
    }
    _searchHistory.insert(0, item);
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
  }

  void _removeFromSearchHistory(int index) {
    setState(() {
      _searchHistory.removeAt(index);
    });
  }

  Future<void> searchGet(String name) async {
    http.Response? response;

    try {
      response = await http.get(Uri.parse(
          'http://$ip:3000/plantpat/search/retriveWordOfsearch?name=$name'));
          var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);
        print(responseData);

        listItem.clear();
        responseData.forEach((item) {
          String plantName = item['plant_name'];
        //  String sectionName = item['section_name'];

          String plantName1 = plantName.toLowerCase();
        //  String sectionName1 = sectionName.toLowerCase();

          if (!listItem.contains(plantName1)) {
            listItem.add(plantName1);
          }
          // if (!listItem.contains(sectionName1)) {
          //   listItem.add(sectionName1);
          // }
        });

        setState(() {
          _searchResults = listItem;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                    });
                  },
                ),
 focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0), 
      borderSide: BorderSide(color: Colors.green), 
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0), 
      borderSide: BorderSide(color: Colors.grey), 
    ),
              ),
              onChanged: (value) {
                _updateSearchResults(value);  
              },
              onSubmitted: (query) {
                _addToSearchHistory(query);
                _searchController.clear();
                _updateSearchResults('');
              },
            ),
            SizedBox(height: 10),
            if (_searchResults.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchResults[index]),
                    onTap: () {
  _addToSearchHistory(_searchResults[index]);
  print("_searchResults[index]:::::::::::::::::::::::::::::");
  print(_searchResults[index]);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Searchresults(name: _searchResults[index]),
    ),
  );
},

                    );
                  },
                ),
              ),
            ] else if (_searchHistory.isNotEmpty) ...[
              Text('Recent Searches:'),
              Column(
                children: List.generate(_searchHistory.length, (index) {
                  return ListTile(
                    title: Text(_searchHistory[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeFromSearchHistory(index);
                      },
                    ),
                    onTap: () {
                      _searchController.text = _searchHistory[index];
                      _updateSearchResults(_searchHistory[index]);
                    },
                  );
                }),
              ),
            ]
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.green),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }
}

