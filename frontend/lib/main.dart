import 'package:cargolink_application/about_screen.dart';
import 'package:cargolink_application/carrier_login_screen.dart';
import 'package:cargolink_application/profile_screen.dart';
import 'package:cargolink_application/trip_history_screen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'app_settings_screen.dart';
import 'carrier_dashboard_screen.dart';
import 'fleet_management_screen.dart';
import 'privacy_security_screen.dart';
import 'support_screen.dart';
import 'carrier_registration_screen.dart';
import 'company_info_screen.dart';
import 'edit_profile_screen.dart';
import 'shipper_login.dart';
import 'shipper_registration.dart';
import 'shipper_dashboard.dart';
import 'post_load_screen.dart';
import 'tracking_map_screen.dart';
import 'shipper_profile_screen.dart';
import 'carrier_biding_screen.dart';
import 'payment_screen.dart';
import 'notification_settings_screen.dart';
import 'notification_screen.dart';
import 'active_trip_screen.dart';
import 'carrier_wallet_screen.dart';
import 'load_board_screen.dart';
import 'load_details_screen.dart';
import 'landing_page.dart';
import 'carrier_profile_screen.dart';

// GLOBAL THEME NOTIFIER
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const CargoLinkApp());
}

class CargoLinkApp extends StatelessWidget {
  const CargoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'CargoLink',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
            ),
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case '/landing':
                return MaterialPageRoute(builder: (_) => const CargoLinkLandingPage());
              case '/shipper_login':
                return MaterialPageRoute(builder: (_) => const ShipperLoginScreen());
              case '/shipper_register':
                return MaterialPageRoute(builder: (_) => const ShipperRegistrationScreen());
              case '/carrier_login':
                return MaterialPageRoute(builder: (_) => const CarrierLoginScreen());
              case '/carrier_registration':
                return MaterialPageRoute(builder: (_) => const CarrierRegistrationScreen());

              case '/carrier_dashboard':
                final String authToken = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => CarrierDashboardScreen(authToken: authToken));

              case '/shipper_dashboard':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => ShipperDashboard(
                    username: args['username'],
                    token: args['token'],
                  ),
                );

              case '/post_load':
                return MaterialPageRoute(builder: (_) => const PostLoadScreen());

              case '/tracking':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => TrackingMapScreen(
                    bookingId: args['bookingId'].toString(),
                    token: args['token'],
                  ),
                );

              case '/shipper_profile':
                return MaterialPageRoute(builder: (_) => const ShipperProfileScreen());
              case '/carrier_profile':
                return MaterialPageRoute(builder: (_) => const CarrierProfileScreen());
              case '/bidding_list':
                return MaterialPageRoute(builder: (_) => const CarrierBiddingScreen());
              case '/payment':
                return MaterialPageRoute(builder: (_) => const PaymentScreen());
              case '/notifications':
                return MaterialPageRoute(builder: (_) => const NotificationsScreen());
              case '/notification_settings':
                return MaterialPageRoute(builder: (_) => const NotificationSettingsScreen());
              case '/company_info':
                return MaterialPageRoute(builder: (_) => const CompanyInfoScreen());
              case '/privacy_security':
                return MaterialPageRoute(builder: (_) => const PrivacySecurityScreen());
              case '/support':
                return MaterialPageRoute(builder: (_) => const SupportScreen());
              case '/edit_profile':
                return MaterialPageRoute(builder: (_) => const EditProfileScreen());
              case '/load_board':
                return MaterialPageRoute(builder: (_) => const LoadBoardScreen());
              case '/load_details':
                return MaterialPageRoute(builder: (_) => const LoadDetailsScreen());
              case '/carrier_wallet':
                return MaterialPageRoute(builder: (_) => const CarrierWalletScreen());
              case '/active_trip':
                return MaterialPageRoute(builder: (_) => const ActiveTripScreen());
              case '/fleet':
                return MaterialPageRoute(builder: (_) => const FleetManagementScreen());
              case '/settings':
                return MaterialPageRoute(builder: (_) => const AppSettingsScreen());
              case '/history':
                return MaterialPageRoute(builder: (_) => const TripHistoryScreen());
              case '/profile':
                return MaterialPageRoute(builder: (_) => const ProfileScreen());
              case '/about':
                return MaterialPageRoute(builder: (_) => const AboutScreen());
              default:
                return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
            }
          },
        );
      },
    );
  }
}
