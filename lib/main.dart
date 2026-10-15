import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'state/auth_store.dart';
import 'state/inventory_store.dart';

void main() {
  inventory.load(); // fetch products from the API
  runApp(const MiniStoreApp());
}

class MiniStoreApp extends StatefulWidget {
  const MiniStoreApp({super.key});

  @override
  State<MiniStoreApp> createState() => _MiniStoreAppState();
}

class _MiniStoreAppState extends State<MiniStoreApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0F4C5C);
    const ink = Color(0xFF16282D);
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;
    final colors = ColorScheme.fromSeed(
      seedColor: teal,
      secondary: const Color(0xFFF0B429),
      brightness: brightness,
    );
    return MaterialApp(
      title: 'Mini Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: _isDarkMode
            ? const Color(0xFF101A1D)
            : const Color(0xFFF2F6F5),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: colors.surface,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isDarkMode
                  ? const Color(0xFF26363A)
                  : const Color(0xFFE1EAE8),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colors.surface,
          indicatorColor: Color(0x66F0B429),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF0B429),
          foregroundColor: ink,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // Shows the login screen until the user signs in
      home: ListenableBuilder(
        listenable: auth,
        builder: (context, _) => auth.isLoggedIn
            ? HomeShell(
                isDarkMode: _isDarkMode,
                onDarkModeChanged: (value) =>
                    setState(() => _isDarkMode = value),
              )
            : const LoginScreen(),
      ),
    );
  }
}
