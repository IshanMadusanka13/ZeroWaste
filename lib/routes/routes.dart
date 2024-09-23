import 'package:go_router/go_router.dart';
import 'package:zero_waste/screens/binManagement/assign_route.dart';
import 'package:zero_waste/screens/binManagement/bin_view_screen.dart';
import 'package:zero_waste/screens/binManagement/create_bin_screen.dart';
import 'package:zero_waste/screens/binManagement/create_route_screen.dart';
import 'package:zero_waste/screens/garbageCollection/record_garage_entry_user_screen.dart';
import 'package:zero_waste/screens/garbageCollection/user_history_screen.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'package:zero_waste/screens/rewardingSystem/item_dashboard.dart';
import 'package:zero_waste/screens/rewardingSystem/manage_points.dart';
import 'package:zero_waste/screens/rewardingSystem/manage_rewards_screen.dart';
import 'package:zero_waste/screens/rewardingSystem/rewards_gift.dart';
import 'package:zero_waste/screens/userManagement/add_employee_screen.dart';
import 'package:zero_waste/screens/userManagement/login_screen.dart';
import 'package:zero_waste/screens/splash_screen.dart';
import 'package:zero_waste/screens/userManagement/register_screen.dart';
import 'package:zero_waste/screens/userManagement/user_dashboard_screen.dart';
import 'package:zero_waste/screens/userManagement/user_update_screen.dart';

import '../models/user.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      //General Routes
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

      //User Management Routes
      GoRoute(path: '/user/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/user/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/user/update',
          builder: (context, state) => const UserUpdateScreen()),
      GoRoute(
          path: '/employee/register',
          builder: (context, state) => const AddEmployeeScreen()),

      //Bin Management Routes
      GoRoute(path: '/bin/view', builder: (context, state) => BinViewScreen(loginedUser: User(email: '', password: ''))),
      GoRoute(
          path: '/bin/create', builder: (context, state) => const CreateBinScreen()),
      GoRoute(
          path: '/route/create', builder: (context, state) => const CreateRouteScreen()),
      GoRoute(
          path: '/route/assign', builder: (context, state) => const AssignRoute()),

      //Garbage Collection Routes
      GoRoute(
          path: '/collection/entry',
          builder: (context, state) => const RecordGarbageEntryScreen()),
      GoRoute(
          path: '/collection/history',
          builder: (context, state) => const UserHistoryScreen()),

      //Reward Management Routes
      GoRoute(
          path: '/reward/manage',
          builder: (context, state) => const ManageRewardsScreen()),
      GoRoute(
          path: '/reward/points',
          builder: (context, state) => const PointsCreateScreen()),
      GoRoute(
          path: '/reward/gifts',
          builder: (context, state) => const RewardsGiftScreen()),
      GoRoute(
          path: '/reward/items',
          builder: (context, state) => const AdminDashboard()),

      GoRoute(
          path: '/profile',
          builder: (context, state) => const UserDashboardScreen()),
    ],
  );
}
