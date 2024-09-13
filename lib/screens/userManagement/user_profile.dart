import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/repositories/user_repository.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    getUserDetails(user as User);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                /*flexibleSpace: FlexibleSpaceBar(
                  title: Text(user.name),
                  background: Image.network(
                    user.profilePictureUrl,
                    fit: BoxFit.cover,
                  ),
                ),*/
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${user.name}'),
                      SizedBox(height: 8.0),
                      Text('Email: ${user?.email}'),
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

  Future<void> getUserDetails(User user) async {
    HouseholdUser? hhu = await HouseholdUserRepository().getHouseholdUserByEmail(user.email!);
  }
}
