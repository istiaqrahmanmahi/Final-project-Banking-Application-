import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:'https://rcfhubmriybezcmjpezd.supabase.co' ,
    anonKey:'sb_publishable_obElG9M-JZ0G8XjsQLbYgQ_Q_qwSn4o',
  );
  
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F80ED),
          primary: const Color(0xFF2F80ED),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      
      home: const LoginScreen(),
    );
  }
}
