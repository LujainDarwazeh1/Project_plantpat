import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

class user {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;

  final String address;
  final String phoneNumber;
  final String userType;

  user({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  
    required this.address,
    required this.phoneNumber,
    required this.userType,
  });

  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
   
      address: json['address'],
      phoneNumber: json['phone_number'],
      userType: json['user_type'],
    );
  }
}

Future<List<user>> fetchAllUserNames() async {
  final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/AllUserName'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> usersJson = data['message']; 
    return usersJson.map((json) => user.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<user> _customers = [];
  Map<int, bool> _selectedUsers = {};
  String _selectedFilter = 'All Customers';

  @override
  void initState() {
    super.initState();
    _loadCustomers(); 
  }

  Future<void> _loadCustomers() async {
    try {
      final users = await fetchAllUserNames();
      setState(() {
        _customers = users;
        _filterCustomers(_selectedFilter); 
      });
    } catch (e) {
      
      print('Failed to load users: $e');
    }
  }

  void _filterCustomers(String filter) {
    setState(() {
      _selectedFilter = filter;
      _selectedUsers.clear(); 
      if (filter == 'All Customers') {
        for (var customer in _customers) {
          _selectedUsers[customer.userId] = false; 
        }
      } else {
        _selectedUsers.clear(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   
    final filteredCustomers = _selectedFilter == 'All Customers'
        ? _customers
        : _customers
            .where((customer) => customer.userType == _selectedFilter)
            .toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customers'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {
                _showAddCustomerDialog(context); 
              },
            ),
            IconButton(
  icon: Icon(Icons.edit, color: Colors.blue),
  onPressed: () {
    print('Edit button pressed');
    if (_selectedUsers.values.contains(true)) {
      _showEditCustomerDialog(context); 
    } else {
      _showNoSelectionDialog(context); 
    }
  },
),

        IconButton(
  icon: Icon(Icons.delete, color: Colors.red),
  onPressed: () {
    if (_selectedUsers.values.contains(true)) {
      final selectedUser = _customers.firstWhere((customer) => _selectedUsers[customer.userId] == true);
      _showDeleteDialog(context, selectedUser);
    } else {
      _showNoSelectionDialog2(context); 
    }
  },
),
 IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
              
              },
            ),
          ],
        ),
        drawer: AppDrawer(), 
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: <String>[
                      'All Customers',
                      'Admin',
                      'Delivery employee',
                      'Buyer'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _filterCustomers(value!);
                    },
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () {
                     
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
             
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Select')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('First Name')),
                      DataColumn(label: Text('Second Name')),
                      DataColumn(label: Text('Email')),
              
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Phone Number')),
                      DataColumn(label: Text('User Type')),
                    ],
                    rows: filteredCustomers.map((customer) {
                      return _buildDataRow(
                        id: customer.userId,
                        firstName: customer.firstName,
                        secondName: customer.lastName,
                        email: customer.email,
                
                        address: customer.address,
                        phoneNumber: customer.phoneNumber,
                        userType: customer.userType,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow({
    required int id,
    required String firstName,
    required String secondName,
    required String email,

    required String address,
    required String phoneNumber,
    required String userType,
  }) {
    return DataRow(
      cells: [
        DataCell(Checkbox(
          value: _selectedUsers[id] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _selectedUsers[id] = value ?? false;
            });
          },
        )),
        DataCell(Text(id.toString())),
        DataCell(Text(firstName)),
        DataCell(Text(secondName)),
        DataCell(Text(email)),
    
        DataCell(Text(address)),
        DataCell(Text(phoneNumber)),
        DataCell(Text(userType)),
      ],
    );
  }
void _showAddCustomerDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String secondName = '';
  String email = '';
  String password = '';
  String address = '';
  String phoneNumber = '';
  String userType = 'Buyer'; 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Customer'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  onChanged: (value) {
                    firstName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Second Name'),
                  onChanged: (value) {
                    secondName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    address = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: userType,
                  decoration: InputDecoration(labelText: 'User Type'),
                  items: <String>['Admin', 'Delivery employee', 'Buyer'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    userType = value!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                await adduser(
                  firstName,
                  secondName,
                  email,
                  password,
                  address,
                  phoneNumber,
                  userType,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

Future<void> adduser(
  String firstName,
  String secondName,
  String email,
  String password,
  String address,
  String phoneNumber,
  String userType,
) async {
  final url = Uri.parse('http://$ip:3000/plantpat/user/adduseradmin');
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': firstName,
        'last_name': secondName,
        'email': email,
        'password': password,
        'address': address,
        'phone_number': phoneNumber,
        'user_type': userType,
      }),
    );

   
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final snackBar = response.statusCode == 200
        ? SnackBar(
            content: Text('User added successfully'),
            backgroundColor: Colors.green,
          )
        : SnackBar(
            content: Text('Failed to add user: ${response.body}'),
            backgroundColor: Colors.red,
          );

  
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('User added successfully');
   
      await _loadCustomers();
    } else {
      print('Failed to add user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}










void _showEditCustomerDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  
  final selectedUserId = _selectedUsers.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .first;

  final selectedUser = _customers.firstWhere((user) => user.userId == selectedUserId);

  
  final firstNameController = TextEditingController(text: selectedUser.firstName);
  final lastNameController = TextEditingController(text: selectedUser.lastName);
  final emailController = TextEditingController(text: selectedUser.email);
  final addressController = TextEditingController(text: selectedUser.address);
  final phoneNumberController = TextEditingController(text: selectedUser.phoneNumber);
  String userType = selectedUser.userType;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Customer'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
     TextFormField(
                  initialValue: selectedUser.userId.toString(),
                  decoration: InputDecoration(labelText: 'Customer ID'),
                  enabled: false, 
                ),




                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                DropdownButtonFormField<String>(
                  value: userType,
                  decoration: InputDecoration(labelText: 'User Type'),
                  items: <String>['Customer', 'Admin', 'Delivery employee', 'Buyer'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    userType = value!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                await updateuser(
                  selectedUserId,
                  firstNameController.text,
                  lastNameController.text,
                  emailController.text,
                  addressController.text,
                  phoneNumberController.text,
                  userType,
                );

                Navigator.of(context).pop();
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}





















Future<void> updateuser(
  int userId,
  String firstName,
  String lastName,
  String email,
  String address,
  String phoneNumber,
  String userType,
) async {
  final url = Uri.parse('http://$ip:3000/plantpat/edit/editprofile');
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'userType': userType,
      }),
    );

    final snackBar = response.statusCode == 200
        ? SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          )
        : SnackBar(
            content: Text('Failed to update user'),
            backgroundColor: Colors.red,
          );

    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (response.statusCode == 200) {
      print('User updated successfully');
     
      await _loadCustomers();
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}



void _showDeleteDialog(BuildContext context, user userr) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Customer Account'),
        content: Text('Are you sure you want to delete the account of ${userr.firstName} ${userr.lastName}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); 
             await _deleteCustomer(userr); 
            },
            child: Text('Continue'),
          ),
        ],
      );
    },
  );
}


Future<void> _deleteCustomer(user userr) async {
  final url = Uri.parse('http://$ip:3000/plantpat/user/delete?userId=${userr.userId}');
  try {
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final snackBar = response.statusCode == 200
        ? SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
          )
        : SnackBar(
            content: Text('Failed to delete user'),
            backgroundColor: Colors.red,
          );

   
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (response.statusCode == 200) {
     
      await _loadCustomers();
    } else {
      print('Failed to delete user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}










  void _showNoSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Selection'),
          content: Text('Please select at least one customer to edit.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

 void _showNoSelectionDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Selection'),
          content: Text('Please select at least one customer to delete.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }






  

  void _deleteSelectedCustomers() {
    final selectedIds = _selectedUsers.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedIds.isEmpty) {
      _showNoSelectionDialog(context);
      return;
    }

   
  }
}
