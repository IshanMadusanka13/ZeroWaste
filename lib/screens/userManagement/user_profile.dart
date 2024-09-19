import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late HouseholdUser hhu;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    getUserDetails(user);
  }

  Future<void> getUserDetails(User? user) async {
    print(user?.toMap());
    HouseholdUser? fetchedUser =
        await HouseholdUserRepository().getHouseholdUserByUserId(user!.id);
    if (fetchedUser != null) {
      setState(() {
        hhu = fetchedUser;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${hhu.fName}'),
                            SizedBox(height: 8.0),
                            Text('Email: ${hhu.mobile}'),

                            const SizedBox(height: 20),
                            _buildDashboardButton(
                              context: context,
                              text: 'Dark Mode',
                              icon: Icons.create,
                              route: '/',
                            ),
                            const SizedBox(height: 20),
                            _buildDashboardButton(
                              context: context,
                              text: 'Edit Profile',
                              icon: Icons.create,
                              route: '/',
                            ),
                            const SizedBox(height: 20),
                            _buildDashboardButton(
                              context: context,
                              text: 'Sign Out',
                              icon: Icons.create,
                              route: '/',
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
  Widget _buildDashboardButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required String route,
  }) {
    return ElevatedButton.icon(
      onPressed: () => context.go(route),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        backgroundColor: Colors.green.shade600,
        shadowColor: Colors.green.shade300,
      ),
      icon: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

