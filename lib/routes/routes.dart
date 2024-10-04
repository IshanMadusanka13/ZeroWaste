import 'package:go_router/go_router.dart';
import 'package:zero_waste/screens/binManagement/bin_view.dart';
import 'package:zero_waste/screens/binManagement/create_bin_screen.dart';
import 'package:zero_waste/screens/garbageCollection/record_garage_entry_user_screen.dart';
import 'package:zero_waste/screens/garbageCollection/user_history_screen.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'package:zero_waste/screens/inquiryManagement/all_analysis.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_binAndPickups_i.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_extraTrash_i.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_normal_i.dart';
import 'package:zero_waste/screens/inquiryManagement/waste_analysis.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_binAndPickups.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_extratrash.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_normal.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_dashboard.dart';
import 'package:zero_waste/screens/inquiryManagement/view_inquiries.dart';
import 'package:zero_waste/screens/rewardingSystem/manage_rewards_screen.dart';
import 'package:zero_waste/screens/userManagement/login_screen.dart';
import 'package:zero_waste/screens/splash_screen.dart';
import 'package:zero_waste/screens/userManagement/register_screen.dart';



class AppRouter {
  static final router = GoRouter(
    routes: [
      //General Routes
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

      //User Management Routes
      GoRoute(path: '/user/login', builder: (context, state) => LoginScreen()),
      GoRoute(
          path: '/user/register',
          builder: (context, state) => RegisterScreen()),

      //Bin Management Routes
      GoRoute(path: '/bin/view', builder: (context, state) => BinView()),
      GoRoute(
          path: '/bin/create', builder: (context, state) => CreateBinScreen()),

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

      //Garbage Assistant ROutes
      GoRoute(
        path: '/inquiry',
        builder:(context, state) => const InquiryDashboardScreen() ),
      GoRoute(
        path: '/inquiry/add_normal_inquiry',
        builder:(context, state) => const InquiryAddScreen() ),
      GoRoute(
        path: '/inquiry/add_extratrash_pickups',
        builder:(context, state) => const InquiryAddExtraPickupScreen() ),
      GoRoute(
        path: '/inquiry/add_collection_issues',
        builder:(context, state) => const InquiryAddBinCollectionIssuesScreen() ),
      GoRoute(
        path: '/inquiry/daily_analysis',
        builder:(context, state) => const WasteAnalysisScreen() ),
      GoRoute(
        path: '/inquiry/view',
        builder:(context, state) => const InquiryViewScreen() ),
      GoRoute(
        path: '/inquiry/daily_analysis/analysis',
        builder:(context, state) => const AllAnalysisScreen() ),
      GoRoute(
        path: '/inquiry/u_normal_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateNormalInquiryScreen(inquiryID: inquiryID);
        },
      ),
      GoRoute(
        path: '/inquiry/u_extra_trash_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateExtraTrashInquiriesScreen(inquiryID: inquiryID);
        },
      ),
      GoRoute(
        path: '/inquiry/u_pickup_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateBinAndPickupScreen(inquiryID: inquiryID);
        },
      ),
      

      
    ],
  );
}


// Method to handle navigation to the update page based on inquiry type
// void _navigateToUpdatePage(BuildContext context, String inquiryType, String inquiryID) {
//   switch (inquiryType) {
//     case 'Normal Inquiry':
//       context.go('/inquiry/u_normal_inquiry/$inquiryID');
//       break;
//     case 'Extra Trash Pickups':
//       context.go('/inquiry/u_extra_trash_inquiry/$inquiryID');
//       break;
//     case 'Overflowing bin issues':
//       context.go('/inquiry/u_pickup_inquiry/$inquiryID');
//       break;
//     case 'Illegal Garbage Dumps':
//       context.go('/inquiry/u_pickup_inquiry/$inquiryID');
//       break;
//     default:
//       // Handle other cases if necessary
//       break;
//   }
// }
