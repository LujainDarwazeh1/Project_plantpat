import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalRevenue = 0.0;
  double totalOrders = 0.0;
  double totalCustomers = 0.0;
  double totalProducts = 0.0;
  List<String> bestSellingProductNames = [];
  List<double> bestSellingProductRevenues = [];
  List<String> recentOrderDates = [];
  List<double> recentOrderAmounts = [];
  List<String> recentOrderStatuses = [];
  List<String> recentOrderFirstNames = [];

  @override
  void initState() {
    super.initState();
    fetchTotalRevenue();
    fetchTotalOrders();
    fetchTotalCustomers();
    fetchTotalProducts();
    fetchBestSellingProducts();
    fetchRecentOrders();
  }

  Future<void> fetchTotalRevenue() async {
    try {
      final String apiUrl = 'http://$ip:3000/plantpat/plant/totalRevenue';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final revenueString = data['total_revenue'] as String;
        setState(() {
          totalRevenue = double.tryParse(revenueString) ?? 0.0;
        });
      } else {
        throw Exception('Failed to load total revenue');
      }
    } catch (e) {
      print('Error fetching total revenue: $e');
      setState(() {
        totalRevenue = 0.0;
      });
    }
  }

  Future<void> fetchTotalOrders() async {
    try {
      final String apiUrl = 'http://$ip:3000/plantpat/plant/totalOrder';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = data['total_orders'] as int;
        setState(() {
          totalOrders = orders.toDouble();
        });
      } else {
        throw Exception('Failed to load total orders');
      }
    } catch (e) {
      print('Error fetching total orders: $e');
      setState(() {
        totalOrders = 0.0;
      });
    }
  }

  Future<void> fetchTotalCustomers() async {
    try {
      final String apiUrl = 'http://$ip:3000/plantpat/user/totalcustomer';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customers = data['total_customers'] as int;
        setState(() {
          totalCustomers = customers.toDouble();
        });
      } else {
        throw Exception('Failed to load total customers');
      }
    } catch (e) {
      print('Error fetching total customers: $e');
      setState(() {
        totalCustomers = 0.0;
      });
    }
  }

  Future<void> fetchTotalProducts() async {
    try {
      final String apiUrl = 'http://$ip:3000/plantpat/plant/totalproduct';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['totalProducts'] as int;
        setState(() {
          totalProducts = products.toDouble();
        });
      } else {
        throw Exception('Failed to load total products');
      }
    } catch (e) {
      print('Error fetching total products: $e');
      setState(() {
        totalProducts = 0.0;
      });
    }
  }

  Future<void> fetchBestSellingProducts() async {
    try {
      final String apiUrl = 'http://$ip:3000/plantpat/plant/BestSelling';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<String> plantNames = [];
        final List<double> revenues = [];

        for (var item in data) {
          plantNames.add(item['plant_name']);
          revenues.add((item['total_revenue'] as num).toDouble());
        }

        setState(() {
          bestSellingProductNames = plantNames;
          bestSellingProductRevenues = revenues;
        });
      } else {
        throw Exception('Failed to load best selling products');
      }
    } catch (e) {
      print('Error fetching best selling products: $e');
      setState(() {
        bestSellingProductNames = [];
        bestSellingProductRevenues = [];
      });
    }
  }

Future<void> fetchRecentOrders() async {
  try {
    final String apiUrl = 'http://$ip:3000/plantpat/plant/RecetOrders';
    print('Fetching recent orders from: $apiUrl'); 
    final response = await http.get(Uri.parse(apiUrl));

    print('Response status: ${response.statusCode}'); 
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Response body: ${response.body}'); 

      final List<String> dates = [];
      final List<double> amounts = [];
      final List<String> statuses = [];
      final List<String> firstNames = [];

      for (var item in data) {
        print('Item: $item'); 
        dates.add(item['payment_date']);

       
        double amount = double.tryParse(item['amount']) ?? 0.0;
        amounts.add(amount);

        statuses.add(item['status']);
        firstNames.add(item['first_name']);
      }

      setState(() {
        recentOrderDates = dates;
        recentOrderAmounts = amounts;
        recentOrderStatuses = statuses;
        recentOrderFirstNames = firstNames;
      });
    } else {
      print('Failed to load recent orders, status code: ${response.statusCode}'); 
      throw Exception('Failed to load recent orders');
    }
  } catch (e) {
    print('Error fetching recent orders: $e'); 
    setState(() {
      recentOrderDates = [];
      recentOrderAmounts = [];
      recentOrderStatuses = [];
      recentOrderFirstNames = [];
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.green,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            //SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4,
                children: [
                  InfoCard(
                    title: 'Total Revenue',
                    value: '\$${totalRevenue.toStringAsFixed(2)}',
                  ),
                  InfoCard(
                    title: 'Total Orders',
                    value: '${totalOrders.toStringAsFixed(0)}',
                  ),
                  InfoCard(
                    title: 'Total Customers',
                    value: '${totalCustomers.toStringAsFixed(0)}',
                  ),
                  InfoCard(
                    title: 'Total Products',
                    value: '${totalProducts.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
          // SizedBox(height: 16),
            Text(
              'Best Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
         //   SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: bestSellingProductNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        bestSellingProductNames[index],
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        '\$${bestSellingProductRevenues[index].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Recent Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                child: ListView.builder(
                  itemCount: recentOrderDates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.shopping_cart, color: Colors.green),
                      title: Text(
                        'Order from ${recentOrderFirstNames[index]}',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Date: ${recentOrderDates[index]} - Amount: \$${recentOrderAmounts[index].toStringAsFixed(2)} - Status: ${recentOrderStatuses[index]}',
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                
                fontWeight: FontWeight.bold,
                color: Colors.green, 
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                color: Colors.black, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
