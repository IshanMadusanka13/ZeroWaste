import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temporary Home Screen'),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              shadowColor: Colors.green.shade200,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    user != null
                        ? Text('Logged in as: ${user.email}')
                        : const Text('No user logged in'),
                    const SizedBox(height: 20),
                    // Wrapping buttons in ListView for scrollable content
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _buildDashboardButton(
                            context: context,
                            text: 'Login',
                            icon: Icons.login,
                            route: '/user/login',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Register',
                            icon: Icons.app_registration,
                            route: '/user/register',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Bin Create',
                            icon: Icons.create,
                            route: '/bin/create',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Bin View',
                            icon: Icons.remove_red_eye,
                            route: '/bin/view',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Record Garbage Entry',
                            icon: Icons.add_circle_outline,
                            route: '/record-entry',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Manage Rewards',
                            icon: Icons.card_giftcard,
                            route: '/manage-rewards',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'User History',
                            icon: Icons.history,
                            route: '/user-history',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'Smart Bin Level',
                            icon: Icons.recycling,
                            route: '/smartbin/garabagelevel',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'SmartBin QR Code Gen',
                            icon: Icons.qr_code,
                            route: '/smartbin/qrgenarate',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'QR Code Scanner',
                            icon: Icons.qr_code,
                            route: '/smartbin/qrscanner',
                          ),
                          const SizedBox(height: 20),
                          _buildDashboardButton(
                            context: context,
                            text: 'notification',
                            icon: Icons.notification_important,
                            route: '/notifications',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
