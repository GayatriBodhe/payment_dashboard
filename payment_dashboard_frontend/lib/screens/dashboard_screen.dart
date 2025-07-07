import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:payment_dashboard_frontend/screens/login_screen.dart';
import 'package:payment_dashboard_frontend/services/api_service.dart';
import 'package:payment_dashboard_frontend/models/payment.dart';
import 'user_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  List<Payment> _payments = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final payments = await _apiService.getPayments();
      final stats = await _apiService.getStats();
      print('Fetched stats: $stats'); // Debug
      setState(() {
        _payments = payments;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              final apiService = ApiService();
              await apiService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagementScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(color: Colors.blue[700]),
                )
                : _error != null
                ? Center(
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red[700], fontSize: 18),
                  ),
                )
                : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stats',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Today: ${_stats['totalTransactionsToday'] ?? 0}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Week: ${_stats['totalTransactionsWeek'] ?? 0}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Revenue: ₹${num.tryParse(_stats['revenue']?.toString() ?? '0')?.toStringAsFixed(0) ?? '0'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                'Failed: ${_stats['failedTransactions'] ?? 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Status',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: (_stats['totalTransactionsToday'] ??
                                                0 -
                                                    (_stats['failedTransactions'] ??
                                                        0))
                                            .toDouble()
                                            .clamp(0.0, double.infinity),
                                        title: 'Success',
                                        color: Colors.green,
                                      ),
                                      PieChartSectionData(
                                        value:
                                            (_stats['failedTransactions'] ?? 0)
                                                .toDouble(),
                                        title: 'Failed',
                                        color: Colors.red,
                                      ),
                                      PieChartSectionData(
                                        value: (_stats['totalTransactionsToday'] ??
                                                0 -
                                                    (_stats['failedTransactions'] ??
                                                        0) -
                                                    (num.tryParse(
                                                          _stats['revenue']
                                                                  ?.toString() ??
                                                              '0',
                                                        ) ??
                                                        0))
                                            .toDouble()
                                            .clamp(0.0, double.infinity),
                                        title: 'Pending',
                                        color: Colors.yellow,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payments',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _payments.length,
                                itemBuilder: (context, index) {
                                  final payment = _payments[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        '₹${num.tryParse(payment.amount)?.toStringAsFixed(0) ?? '0'}',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            161,
                                            83,
                                            83,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      '${payment.receiver}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      '${payment.method} - ${payment.status} - ${DateFormat('yyyy-MM-dd').format(payment.createdAt)}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    trailing: Icon(
                                      payment.status == 'success'
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color:
                                          payment.status == 'success'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
