import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

class Order {
  final int id;
  final String username;
  final String amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String deliveryOption;
  final String products;
  final String counts;




  Order({
    required this.id,
    required this.username,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.deliveryOption,
    required this.products,
    required this.counts,

  });

  factory Order.fromJson(Map<String, dynamic> json, int id) {
    return Order(
      id: id,
      username: json['username'] ?? 'Unknown', 
      amount: json['amount'] ?? '0', 
      paymentDate: DateTime.tryParse(json['payment_date']) ?? DateTime.now(), 
      paymentMethod: json['payment_method'] ?? 'Unknown', 
      deliveryOption: json['delivery_option'] ?? 'Unknown', 
      products: json['products'] ?? '', 
      counts:json['counts'] ?? '',
    );
  }
}


























Future<String> _fetchUsernameForUserId(int userId) async {
  try {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/Namebyid?userId=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final firstName = data[0]['first_name'] ?? 'Unknown';
        final lastName = data[0]['last_name'] ?? 'Unknown';
        return '$firstName $lastName';
      }
    }
    return 'Unknown';
  } catch (e) {
    print('Error fetching username: $e');
    return 'Unknown';
  }
}




Future<String> _fetchUseridForUsername(String userId) async {
  try {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/Namebyid?userId=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final firstName = data[0]['first_name'] ?? 'Unknown';
        final lastName = data[0]['last_name'] ?? 'Unknown';
        return '$firstName $lastName';
      }
    }
    return 'Unknown';
  } catch (e) {
    print('Error fetching username: $e');
    return 'Unknown';
  }
}






class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> _orders = [];
  Map<int, bool> _selectedOrders = {};
  String _selectedFilter = 'All Orders';
   String? _selectedPaymentMethod; 
  String? _selectedDeliveryOption; 

  @override
  void initState() {
    super.initState();
    fetchOrders(); 
  }

Future<void> fetchOrders() async {
  try {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/payment/AllPayment'));

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody != null && responseBody.isNotEmpty) {
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);

        if (responseJson.containsKey('data') && responseJson['data'] is List) {
          final List<dynamic> ordersJson = responseJson['data'];
          final List<Order> orders = [];
          int idCounter = 1; 

          for (var json in ordersJson) {
            final userId = json['user_id'];
            final username = await _fetchUsernameForUserId(userId); 
            orders.add(Order.fromJson({
              ...json,
              'username': username, 
            }, idCounter++));
          }

          setState(() {
            _orders = orders;
          });
        } else {
          throw Exception('Invalid JSON format: Missing or incorrect "data" key');
        }
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching orders: $error');
  }
}






  void _filterOrders(String filter) {
    setState(() {
      _selectedFilter = filter;
      _selectedOrders.clear();
    });
  }

@override
Widget build(BuildContext context) {
  final filteredOrders = _selectedFilter == 'All Orders'
      ? _orders
      : _orders.where((order) {
          if (_selectedFilter == 'Payment Method') {
            
            return order.paymentMethod == _selectedPaymentMethod; 
          } else if (_selectedFilter == 'Delivery Option') {
           
            return order.deliveryOption == _selectedDeliveryOption; 
          }
          return false;
        }).toList();

  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.green,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  _showAddOrderDialog(context);
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  if (_selectedOrders.values.contains(true)) {
                    _showEditOrderDialog(context);
                  } else {
                    _showNoSelectionDialog(context);
                  }
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  final selectedOrders = _orders.where((order) => _selectedOrders[order.id] == true).toList();
                  if (selectedOrders.length == 1) {
                    final selectedOrder = selectedOrders.first;
                    _showDeleteDialog(context, selectedOrder);
                  } else if (selectedOrders.isEmpty) {
                    _showNoSelectionDialog2(context);
                  } else {
                    
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
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                    items: <String>['All Orders', 'Payment Method', 'Delivery Option']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                        
                        if (_selectedFilter == 'Payment Method') {
                          _selectedPaymentMethod = null; 
                        } else if (_selectedFilter == 'Delivery Option') {
                          _selectedDeliveryOption = null; 
                        }
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  if (_selectedFilter == 'Payment Method') 
                    DropdownButton<String>(
                      value: _selectedPaymentMethod,
                      items: <String>['Cash', 'Card']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  if (_selectedFilter == 'Delivery Option') 
                    DropdownButton<String>(
                      value: _selectedDeliveryOption,
                      items: <String>['Our delivery system', 'Free pick up point']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDeliveryOption = value!;
                        });
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Select')),
                    DataColumn(label: Text('User Name')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Payment Date')),
                    DataColumn(label: Text('Payment Method')),
                    DataColumn(label: Text('Delivery Option')),
                    DataColumn(label: Text('')),
                  ],
                  rows: filteredOrders.map((order) {
                    return _buildDataRow(order);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


void _showNoSelectionDialog2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No Selection'),
        content: Text('Please select at least one Order to delete.'),
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























DataRow _buildDataRow(Order order) {
  return DataRow(
    cells: [
      DataCell(Checkbox(
        value: _selectedOrders[order.id] ?? false,
        onChanged: (bool? value) {
          setState(() {
            _selectedOrders[order.id] = value ?? false;
          });
        },
      )),
      DataCell(Text(order.username)), 
      DataCell(Text(order.amount)),
      DataCell(Text(order.paymentDate.toLocal().toString().split(' ')[0])),
      DataCell(Text(order.paymentMethod)),
      DataCell(Text(order.deliveryOption)),
     DataCell(TextButton(
  child: Text('Show More'),
  style: TextButton.styleFrom(
    backgroundColor: Colors.green, 
    foregroundColor: Colors.white, 
  ),
  onPressed: () {
    
    _showOrderDetails(order);
  },
)),

    ],
  );
}


void _showOrderDetails(Order order) async {
  List<String> productsList = order.products.split(','); 
  List<String> countsList = order.counts.split(','); 


  List<Map<String, String>> productDetails = [];


  for (int i = 0; i < productsList.length; i++) {
    String productId = productsList[i].trim();
    String count = countsList[i].trim();
    
    int plantId = int.parse(productId);
    String productName = await _fetchProductName(plantId);

    productDetails.add({
      'id': plantId.toString(),
      'name': productName,
      'count': count,
    });
  }


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.green), 
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (var i = 0; i < productDetails.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Product ID: ${productDetails[i]['id']}'),
                              Text('Product Name: ${productDetails[i]['name']}'),
                              Text('Product Quantity: ${productDetails[i]['count']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50), 
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green, 
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}







Future<String> _fetchProductName(int plantId) async {
  final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/plantnamebyid?plant_id=$plantId'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data['name'] ?? 'Unknown'; 
  } else {
   
    return 'Error fetching name';
  }
}





void _showAddOrderDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String amount = '';
  DateTime paymentDate = DateTime.now();
  String paymentMethod = '';
  String deliveryOption = '';
  String products = '';
  String counts = '';
  

  final paymentDateController = TextEditingController(
    text: paymentDate.toLocal().toString().split(' ')[0],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Order'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'User Name'),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    username = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Payment Date'),
                  controller: paymentDateController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: paymentDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != paymentDate) {
                      paymentDate = picked;
                      paymentDateController.text = picked.toLocal().toString().split(' ')[0];
                    }
                  },
                  readOnly: true,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Payment Method'),
                  value: paymentMethod.isNotEmpty ? paymentMethod : null,
                  items: <String>['Cash', 'Card'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    paymentMethod = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a payment method';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Delivery Option'),
                  value: deliveryOption.isNotEmpty ? deliveryOption : null,
                  items: <String>['Our delivery system', 'Free pick up point'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    deliveryOption = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a delivery option';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  
                  decoration: InputDecoration(labelText: 'Products (comma-separated)'),
                  onChanged: (value) {
                    products = value;
                  },
                ),
                TextFormField(
                  
                  decoration: InputDecoration(labelText: 'Counts (comma-separated )'),
                  onChanged: (value) {
                    counts = value;
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
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
               
                final int nextId = _orders.isEmpty ? 1 : (_orders.first.id + 1);

                final order = Order(
                  id: nextId, 
                  username: username,
                  amount: amount,
                  paymentDate: paymentDate,
                  paymentMethod: paymentMethod,
                  deliveryOption: deliveryOption,
                  products: products,
                  counts:counts,
                );

            
                setState(() {
                  _orders.insert(0, order); 
                  _filterOrders(_selectedFilter); 
                });

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



  Future<void> _addOrder(
      int userId, String amount, DateTime paymentDate, String paymentMethod, String deliveryOption, String products) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.88.5:3000/plantpat/payment/addOrder'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({
  //         'user_id': userId,
  //         'amount': amount,
  //         'payment_date': paymentDate.toIso8601String(),
  //         'payment_method': paymentMethod,
  //         'delivery_option': deliveryOption,
  //         'products': products.split(',').map((e) => int.parse(e)).toList(), // Convert to list of integers
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       fetchOrders(); // Refresh the list
  //     } else {
  //       throw Exception('Failed to add order: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error adding order: $error');
  //  }
  }

void _showEditOrderDialog(BuildContext context) {
  final selectedIds = _selectedOrders.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  if (selectedIds.length != 1) {
    _showNoSelectionDialog(context); 
    return;
  }

  final order = _orders.firstWhere((o) => o.id == selectedIds[0]);
  final _formKey = GlobalKey<FormState>();

  String username = order.username;
  double amount = double.tryParse(order.amount) ?? 0.0;
  DateTime paymentDate = order.paymentDate;
  String paymentMethod = order.paymentMethod;
  String deliveryOption = order.deliveryOption;
  String products=order.products;
  String counts=order.counts;
  

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Order'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: username,
                  decoration: InputDecoration(labelText: 'User Name'),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextFormField(
                  initialValue: amount.toString(),
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = double.tryParse(value) ?? 0.0;
                  },
                ),
                TextFormField(
                  initialValue: paymentDate.toLocal().toString().split(' ')[0],
                  decoration: InputDecoration(labelText: 'Payment Date'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: paymentDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != paymentDate) {
                      setState(() {
                        paymentDate = picked;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Payment Method'),
                  value: paymentMethod.isNotEmpty ? paymentMethod : null,
                  items: ['Cash', 'Card'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Delivery Option'),
                  value: deliveryOption.isNotEmpty ? deliveryOption : null,
                  items: ['Free pick up point', 'Our delivery system'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      deliveryOption = value!;
                    });
                  },
                ),


                 TextFormField(
                  initialValue: products,
                  decoration: InputDecoration(labelText: 'Products'),
                  onChanged: (value) {
                    products = value;
                  },
                ),
                  TextFormField(
                  initialValue: counts,
                  decoration: InputDecoration(labelText: 'Counts'),
                  onChanged: (value) {
                    counts = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
     ElevatedButton(
  child: Text('Save'),
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      
      List<String> productIds = products.split(',').map((e) => e.trim()).toList();
      List<String> countsList = counts.split(',').map((e) => e.trim()).toList();

      if (productIds.length != countsList.length) {
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product IDs and counts do not match')));
        return;
      }

      double totalAmount = 0.0;

      for (int i = 0; i < productIds.length; i++) {
        int plantId = int.tryParse(productIds[i]) ?? 0;
        int count = int.tryParse(countsList[i]) ?? 0;

        if (plantId > 0 && count > 0) {
          try {
            double price = await getPriceById(plantId);
            totalAmount += price * count;
          } catch (e) {
          
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching price for plant ID $plantId')));
            return;
          }
        }
      }

      setState(() {
        final index = _orders.indexWhere((o) => o.id == selectedIds[0]);
        if (index != -1) {
          _orders[index] = Order(
            id: order.id,
            username: username,
            amount: totalAmount.toString(), 
            paymentDate: paymentDate,
            paymentMethod: paymentMethod,
            deliveryOption: deliveryOption,
            products: products,
            counts: counts,
          );
        }
        _filterOrders(_selectedFilter); 
      });

      Navigator.of(context).pop();
    }
  },
)

        ],
      );
    },
  );
}

Future<double> getPriceById(int plantId) async {
  final response = await http.get(
    Uri.parse('http://$ip:3000/plantpat/plant/price?id=$plantId'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['price'];
  } else {
    throw Exception('Failed to load plant price');
  }
}










  void _showNoSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Selection'),
          content: Text('Please select at least one Order to edit.'),
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


void _showDeleteDialog(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Order'),
        content: Text('Are you sure you want to delete the order for ${order.username}?'),
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
             await _deleteOrder(order); 
            },
            child: Text('Continue'),
          ),
        ],
      );
    },
  );
}





Future<void> _deleteOrder(Order order) async {
  final orderId = order.id;

  if (orderId == null) {
   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Invalid order ID.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
  
    try {
    
      setState(() {
        _orders.removeWhere((o) => o.id == orderId);
        _selectedOrders.remove(orderId); 
        _filterOrders(_selectedFilter); 
      });
    } catch (error) {
     
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete the order. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}




  }
