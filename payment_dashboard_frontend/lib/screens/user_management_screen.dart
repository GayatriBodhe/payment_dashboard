import 'package:flutter/material.dart';
import 'package:payment_dashboard_frontend/services/api_service.dart';
import 'package:payment_dashboard_frontend/models/user.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = true;
  String? _error;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() { _isLoading = true; });
      final users = await _apiService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addUser() async {
    try {
      await _apiService.addUser(
        _usernameController.text,
        _passwordController.text,
        _roleController.text,
      );
      _fetchUsers();
      _usernameController.clear();
      _passwordController.clear();
      _roleController.clear();
    } catch (e) {
      setState(() { _error = 'Error: $e'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: _roleController,
                        decoration: InputDecoration(labelText: 'Role (admin/viewer)'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addUser,
                        child: Text('Add User'),
                      ),
                      SizedBox(height: 20),
                      Text('Users', style: Theme.of(context).textTheme.headline6),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return ListTile(
                              title: Text(user.username),
                              subtitle: Text('Role: ${user.role}'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

extension on TextTheme {
  get headline6 => null;
}