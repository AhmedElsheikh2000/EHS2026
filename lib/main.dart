import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/conferences/features/badge_screen.dart';
import 'screens/conferences/features/ai_bot_screen.dart';
import 'screens/conferences/features/certificate_screen.dart';
import 'screens/conferences/features/ask_vote_screen.dart';
import 'screens/conferences/features/bookmarks_screen.dart';
import 'screens/conferences/ehs_training_village_screen.dart';
import 'screens/conferences/features/workshops_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const EHSConferenceApp());
}

class EHSConferenceApp extends StatelessWidget {
  const EHSConferenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EHS Conferences',
      debugShowCheckedModeBanner: false,
      theme: EHSTheme.getAppTheme(),
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());
      
      case '/onboarding':
        return _createRoute(const OnboardingScreen());
      
      case '/login':
        return _createRoute(const LoginScreen());
      
      case '/register':
        return _createRoute(const RegisterScreen());
      
      case '/home':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(
          HomeScreen(
            userName: args?['userName'] ?? "Guest",
            phoneNumber: args?['phoneNumber'] ?? "",
            email: args?['email'] ?? "",
          ),
        );

      case '/profile':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(
          ProfileScreen(
            userName: args?['userName'] ?? "Guest User",
            email: args?['email'] ?? "guest@example.com",
            phoneNumber: args?['phoneNumber'] ?? "+971000000000",
          ),
        );
      
      case '/badge':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(
          BadgeScreen(
            attendeeName: args?['attendeeName'] ?? '',
            phoneNumber: args?['phoneNumber'] ?? '',
            email: args?['email'] ?? '',
            organization: args?['organization'] ?? '',
            role: args?['role'] ?? '',
            conferenceId: args?['conferenceId'] ?? '',
          ),
        );
      
      case '/certificate':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(
          CertificateScreen(
            attendeeName: args?['attendeeName'] ?? 'Guest',
          ),
        );
      
      case '/ask-vote':
        return _createRoute(const AskVoteScreen());

      case '/ai-bot':
        return _createRoute(const AIBotScreen());
      
      case '/bookmarks':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(
          BookmarksScreen(
            bookmarkedItems: args?['bookmarkedItems'] ?? <String>{},
            onToggleBookmark: args?['onToggleBookmark'] ?? (String id) {},
          ),
        );

      case '/training-village':
        return _createRoute(const EHSTrainingVillageScreen());
        case '/workshops':
  return _createRoute(const WorkshopsScreen());
    
      default:
        return _createRoute(const SplashScreen());
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}