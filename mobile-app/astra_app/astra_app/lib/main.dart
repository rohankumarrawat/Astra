
// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const AstraApp());
// }

// // --- UI COMPONENTS ---
// class GlassCard extends StatelessWidget {
//   final Widget child;
//   final double height;

//   const GlassCard({required this.child, this.height = 150, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           height: height,
//           width: double.infinity,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// class AstraApp extends StatelessWidget {
//   const AstraApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF0F172A),
//       ),
//       home: const DashboardScreen(),
//     );
//   }
// }

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   // Connection State
//   bool isConnected = false;
//   String connectedDeviceName = "None";
//   String status = "Disconnected";
  
//   // Data State
//   String pm25 = "0.00";
//   String roadLabel = "Scanning...";
//   String dustLabel = "Scanning...";
//   int potholesDetected = 0;
//   List<FlSpot> vibrationData = [];
//   double timeX = 0;
//   Timer? _dataTimer;

//   // --- API LOGIC ---
  
//   // Replace with your actual deployed URL
//   final String apiUrl = "https://voidpanel.com/api/get-latest-esp/";

//   void _fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
      
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonData = jsonDecode(response.body);
//         final data = jsonData['data'];

//         setState(() {
//           // Update values from CSV
//           pm25 = data['dust'].toStringAsFixed(2);
//           String newRoadLabel = data['road_condition'];
//           dustLabel = data['dust_condition'];
          
//           // Increment pothole count if detected in this frame
//           if (newRoadLabel == "Pothole Detected" && roadLabel != "Pothole Detected") {
//             potholesDetected++;
//           }
//           roadLabel = newRoadLabel;

//           // Update Chart: Using AZ (Vertical Acceleration)
//           // Normalizing: raw value / 16384 typically equals 1G
//           double azNormalized = (data['az'] / 16384.0).toDouble();
          
//           vibrationData.add(FlSpot(timeX, azNormalized));
//           timeX += 1.0;

//           // Keep chart scrolling
//           if (vibrationData.length > 25) vibrationData.removeAt(0);
//         });
//       }
//     } catch (e) {
//       debugPrint("Fetch Error: $e");
//       setState(() => status = "Bridge Error");
//     }
//   }

//   void _startLiveStreaming() {
//     _dataTimer?.cancel();
//     _dataTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
//       if (!mounted || !isConnected) {
//         timer.cancel();
//         return;
//       }
//       _fetchData();
//     });
//   }

//   // --- UI ACTIONS ---

//   void _showScanDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1E293B),
//         title: Text("Active Bridges", style: GoogleFonts.orbitron(fontSize: 18)),
//         content: SizedBox(
//           width: double.maxFinite,
//           height: 100,
//           child: ListTile(
//             leading: const Icon(Icons.cloud_sync, color: Colors.cyanAccent),
//             title: const Text("Python Data Bridge"),
//             subtitle: const Text("voidpanel.com/api"),
//             onTap: () {
//               Navigator.pop(context);
//               _connect("ASTRA_CLOUD_RELAY");
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _connect(String name) {
//     setState(() => status = "Connecting...");
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         isConnected = true;
//         connectedDeviceName = name;
//         status = "Connected";
//       });
//       _startLiveStreaming();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // HEADER
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(status, 
//                           style: TextStyle(
//                             color: isConnected ? Colors.greenAccent : Colors.grey, 
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold
//                           )
//                         ),
//                         Text(connectedDeviceName, 
//                           style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold), 
//                           overflow: TextOverflow.ellipsis
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isConnected ? Colors.red.withOpacity(0.2) : Colors.cyan.withOpacity(0.2),
//                     ),
//                     onPressed: isConnected ? () {
//                       setState(() {
//                         isConnected = false;
//                         status = "Disconnected";
//                         connectedDeviceName = "None";
//                       });
//                     } : _showScanDialog,
//                     child: Text(isConnected ? "Stop" : "Sync"),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
              
//               // AIR QUALITY SECTION
//               Text("Environmental Data", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white70)),
//               const SizedBox(height: 10),
//               GlassCard(
//                 height: 140,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStat("PM 2.5", pm25, dustLabel == "High Pollution" ? Colors.redAccent : Colors.greenAccent),
//                     _buildStat("Air Quality", dustLabel.split(' ').first, Colors.orangeAccent),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 30),

//               // ROAD ANALYSIS SECTION
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Vibration Analysis", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white70)),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: roadLabel == "Pothole Detected" ? Colors.red : Colors.cyan.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8)
//                     ),
//                     child: Text("Potholes: $potholesDetected", style: const TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               GlassCard(
//                 height: 200,
//                 child: isConnected 
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: LineChart(
//                             LineChartData(
//                               gridData: const FlGridData(show: false),
//                               titlesData: const FlTitlesData(show: false),
//                               borderData: FlBorderData(show: false),
//                               lineBarsData: [
//                                 LineChartBarData(
//                                   spots: vibrationData,
//                                   isCurved: true,
//                                   color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.cyanAccent,
//                                   barWidth: 3,
//                                   isStrokeCapRound: true,
//                                   dotData: const FlDotData(show: false),
//                                   belowBarData: BarAreaData(
//                                     show: true,
//                                     color: (roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.cyanAccent).withOpacity(0.1)
//                                   ),
//                                 ),
//                               ],
//                               minY: -2, maxY: 4, 
//                               minX: vibrationData.isNotEmpty ? vibrationData.first.x : 0, 
//                               maxX: vibrationData.isNotEmpty ? vibrationData.last.x : 10,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(roadLabel, style: TextStyle(
//                           color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.greenAccent,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.2
//                         ))
//                       ],
//                     )
//                   : const Center(child: Text("Start Bridge Sync to see live road data")),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String value, Color color) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(value, style: GoogleFonts.oswald(fontSize: 28, color: color, fontWeight: FontWeight.bold)),
//         Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, letterSpacing: 1)),
//       ],
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:geolocator/geolocator.dart';

// void main() {
//   runApp(const AstraApp());
// }

// // --- SMTP CONFIGURATION ---
// // Replace with your real company SMTP details
// const String smtpHost = 'mail.comtranse.in';
// const int smtpPort = 587; 
// const String smtpUser = 'rohan@comtranse.in';
// const String smtpPass = 'r8=y0!!kU)'; 
// const String adminEmail = 'rohanfreakymg@gmail.com';

// final companySmtp = SmtpServer(
//   smtpHost,
//   port: smtpPort,
//   username: smtpUser,
//   password: smtpPass,
// );

// class AstraApp extends StatelessWidget {
//   const AstraApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF0F172A),
//       ),
//       home: const DashboardScreen(),
//     );
//   }
// }

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool isConnected = false;
//   String status = "Disconnected";
//   String connectedDevice = "None";
  
//   // Data State
//   String pm25 = "0.00";
//   String roadLabel = "Scanning...";
//   String dustLabel = "Normal";
//   int potholeCount = 0;
//   List<FlSpot> vibrationPoints = [];
//   double timeIdx = 0;
  
//   Timer? _pollingTimer;
//   DateTime? _lastAlertTime;

//   // 1. LOCATION PERMISSION HANDLER
//   Future<Position?> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return null;

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return null;
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   // 2. EMAIL ALERT LOGIC
//   Future<void> _sendEmailAlert(int rawAz) async {
//     Position? pos = await _getCurrentLocation();
//     String googleMapsUrl = (pos != null) 
//         ? "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}"
//         : "Location Unavailable";

//     final message = Message()
//       ..from = Address(smtpUser, 'ASTRA System')
//       ..recipients.add(adminEmail)
//       ..subject = '⚠️ POTHOLE DETECTED - ASTRA ALERT'
//       ..html = """
//         <div style="font-family: Arial; padding: 20px; border: 2px solid #ff4444; border-radius: 10px;">
//           <h2 style="color: #ff4444;">Pothole Detection Event</h2>
//           <p><strong>Impact Force:</strong> ${(rawAz / 16384.0).toStringAsFixed(2)}G</p>
//           <p><strong>Time:</strong> ${DateTime.now().toLocal()}</p>
//           <p><strong>Location:</strong> <a href="$googleMapsUrl">Click to view on Google Maps</a></p>
//         </div>
//       """;

//     try {
//       await send(message, companySmtp);
//       debugPrint("📧 Email Sent Successfully");
//     } catch (e) {
//       debugPrint("📧 Mail Error: $e");
//     }
//   }

//   // 3. API POLLING LOGIC
//   void _fetchLatestData() async {
//     final url = Uri.parse("https://voidpanel.com/api/get-latest-esp/");
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body)['data'];
        
//         setState(() {
//           pm25 = data['dust'].toStringAsFixed(2);
//           dustLabel = data['dust_condition'];
//           String currentRoad = data['road_condition'];

//           // Detection Logic
//           if (currentRoad == "Pothole Detected") {
//             if (roadLabel != "Pothole Detected") {
//               potholeCount++;
//               // Cooldown: 2 minutes between emails
//               if (_lastAlertTime == null || DateTime.now().difference(_lastAlertTime!).inMinutes >= 2) {
//                 _lastAlertTime = DateTime.now();
//                 _sendEmailAlert(data['az']);
//               }
//             }
//           }
//           roadLabel = currentRoad;

//           // Chart Logic
//           double gForce = (data['az'] / 16384.0).toDouble();
//           vibrationPoints.add(FlSpot(timeIdx, gForce));
//           timeIdx++;
//           if (vibrationPoints.length > 30) vibrationPoints.removeAt(0);
//         });
//       }
//     } catch (e) {
//       debugPrint("API Error: $e");
//     }
//   }

//   void _startSync() {
//     setState(() {
//       isConnected = true;
//       status = "Connected";
//       connectedDevice = "ASTRA_CLOUD_RELAY";
//     });
//     _pollingTimer = Timer.periodic(const Duration(milliseconds: 900), (t) => _fetchLatestData());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // HEADER
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(status, style: TextStyle(color: isConnected ? Colors.greenAccent : Colors.grey, fontSize: 12)),
//                       Text(connectedDevice, style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   ElevatedButton(
//                     onPressed: isConnected ? () => setState(() { isConnected = false; _pollingTimer?.cancel(); }) : _startSync,
//                     child: Text(isConnected ? "Stop" : "Sync"),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // AIR QUALITY
//               Text("ENVIRONMENTAL", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white38)),
//               const SizedBox(height: 10),
//               GlassCard(
//                 height: 120,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatBlock("PM 2.5", pm25, Colors.cyanAccent),
//                     _buildStatBlock("STATUS", dustLabel, Colors.orangeAccent),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // ROAD VIBRATION
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("VIBRATION (G)", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white38)),
//                   Text("Potholes: $potholeCount", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               GlassCard(
//                 height: 220,
//                 child: isConnected 
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: LineChart(
//                             LineChartData(
//                               gridData: const FlGridData(show: false),
//                               titlesData: const FlTitlesData(show: false),
//                               borderData: FlBorderData(show: false),
//                               lineBarsData: [
//                                 LineChartBarData(
//                                   spots: vibrationPoints,
//                                   isCurved: true,
//                                   color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.cyanAccent,
//                                   barWidth: 3,
//                                   dotData: const FlDotData(show: false),
//                                   belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.05)),
//                                 ),
//                               ],
//                               minY: -1, maxY: 3,
//                               minX: vibrationPoints.isNotEmpty ? vibrationPoints.first.x : 0,
//                               maxX: vibrationPoints.isNotEmpty ? vibrationPoints.last.x : 10,
//                             ),
//                           ),
//                         ),
//                         Text(roadLabel, style: GoogleFonts.orbitron(color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.greenAccent, fontSize: 16)),
//                       ],
//                     )
//                   : const Center(child: Text("Sync to view road data")),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatBlock(String label, String value, Color color) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center, // Fixed: This was your error line!
//       children: [
//         Text(value, style: GoogleFonts.oswald(fontSize: 26, color: color, fontWeight: FontWeight.bold)),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
//       ],
//     );
//   }
// }

// // --- GLASS CARD COMPONENT ---
// class GlassCard extends StatelessWidget {
//   final Widget child;
//   final double height;
//   const GlassCard({required this.child, required this.height, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: child,
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const AstraApp());
}

// --- SMTP CONFIGURATION ---
const String smtpHost = 'mail.comtranse.in';
const int smtpPort = 587; 
const String smtpUser = 'rohan@comtranse.in';
const String smtpPass = 'r8=y0!!kU)'; 
const String adminEmail = 'rohanfreakymg@gmail.com';

final companySmtp = SmtpServer(
  smtpHost,
  port: smtpPort,
  username: smtpUser,
  password: smtpPass,
);

class AstraApp extends StatelessWidget {
  const AstraApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isConnected = false;
  String status = "Disconnected";
  String connectedDevice = "None";
  
  String pm25 = "0.00";
  String roadLabel = "Scanning...";
  String dustLabel = "Normal";
  int potholeCount = 0;
  List<FlSpot> vibrationPoints = [];
  double timeIdx = 0;
  
  Timer? _pollingTimer;
  DateTime? _lastAlertTime;

  // FIXED: Changed greenDeep to Colors.green
  void _showNotification(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint("Location Error: $e");
      return null;
    }
  }

  Future<void> _sendEmailAlert(int rawAz) async {
    Position? pos = await _getCurrentLocation();
    // Corrected String interpolation for URL
    String googleMapsUrl = (pos != null) 
        ? "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}"
        : "Location Unavailable";

    final message = Message()
      ..from = Address(smtpUser, 'ASTRA System')
      ..recipients.add(adminEmail)
      ..subject = '⚠️ POTHOLE DETECTED - ASTRA ALERT'
      ..html = """
        <div style="font-family: Arial; padding: 20px; border: 2px solid #ff4444; border-radius: 10px;">
          <h2 style="color: #ff4444;">Pothole Detection Event</h2>
          <p><strong>Impact Force:</strong> ${(rawAz / 16384.0).toStringAsFixed(2)}G</p>
          <p><strong>Time:</strong> ${DateTime.now().toLocal()}</p>
          <p><strong>Location:</strong> <a href="$googleMapsUrl">Click to view on Google Maps</a></p>
        </div>
      """;

    try {
      await send(message, companySmtp);
      _showNotification("Email alert sent to Admin", false);
    } catch (e) {
      debugPrint("📧 Mail Error: $e");
      _showNotification("Failed to send Email Alert", true);
    }
  }

  void _fetchLatestData() async {
    final url = Uri.parse("https://voidpanel.com/api/get-latest-esp/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        
        setState(() {
          pm25 = data['dust'].toStringAsFixed(2);
          dustLabel = data['dust_condition'];
          String currentRoad = data['road_condition'];

          if (currentRoad == "Pothole Detected") {
            if (roadLabel != "Pothole Detected") {
              potholeCount++;
              if (_lastAlertTime == null || DateTime.now().difference(_lastAlertTime!).inMinutes >= 2) {
                _lastAlertTime = DateTime.now();
                _sendEmailAlert(data['az']);
              }
            }
          }
          roadLabel = currentRoad;

          double gForce = (data['az'] / 16384.0).toDouble();
          vibrationPoints.add(FlSpot(timeIdx, gForce));
          timeIdx++;
          if (vibrationPoints.length > 30) vibrationPoints.removeAt(0);
        });
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
  }

  void _startSync() {
    setState(() {
      isConnected = true;
      status = "Connected";
      connectedDevice = "ASTRA_CLOUD_RELAY";
    });
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 900), (t) => _fetchLatestData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status, style: TextStyle(color: isConnected ? Colors.greenAccent : Colors.grey, fontSize: 12)),
                      Text(connectedDevice, style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isConnected ? () => setState(() { isConnected = false; _pollingTimer?.cancel(); }) : _startSync,
                    child: Text(isConnected ? "Stop" : "Sync"),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Text("ENVIRONMENTAL", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white38)),
              const SizedBox(height: 10),
              GlassCard(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBlock("PM 2.5", pm25, Colors.cyanAccent),
                    _buildStatBlock("STATUS", dustLabel, Colors.orangeAccent),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("VIBRATION (G)", style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white38)),
                  Text("Potholes: $potholeCount", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              GlassCard(
                height: 220,
                child: isConnected 
                  ? Column(
                      children: [
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: vibrationPoints,
                                  isCurved: true,
                                  color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.cyanAccent,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.05)),
                                ),
                              ],
                              minY: -1, maxY: 3,
                              minX: vibrationPoints.isNotEmpty ? vibrationPoints.first.x : 0,
                              maxX: vibrationPoints.isNotEmpty ? vibrationPoints.last.x : 10,
                            ),
                          ),
                        ),
                        Text(roadLabel, style: GoogleFonts.orbitron(color: roadLabel == "Pothole Detected" ? Colors.redAccent : Colors.greenAccent, fontSize: 16)),
                      ],
                    )
                  : const Center(child: Text("Sync to view road data")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBlock(String label, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: GoogleFonts.oswald(fontSize: 26, color: color, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double height;
  const GlassCard({required this.child, required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}