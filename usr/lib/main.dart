import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const RobertoApp());
}

class RobertoApp extends StatelessWidget {
  const RobertoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roberto: Come & Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _activityLog = [];
  bool _isHere = false;

  void _handleAction(bool isComing) {
    setState(() {
      _isHere = isComing;
      _activityLog.insert(0, {
        'action': isComing ? 'Arrived' : 'Departed',
        'timestamp': DateTime.now(),
        'isComing': isComing,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roberto: Come & Go'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _activityLog.clear();
                _isHere = false;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Status Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: _isHere
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            child: Column(
              children: [
                Icon(
                  _isHere ? Icons.location_on : Icons.location_off,
                  size: 48,
                  color: _isHere ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                Text(
                  _isHere ? 'CURRENTLY HERE' : 'CURRENTLY AWAY',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _isHere ? Colors.green[800] : Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isHere ? null : () => _handleAction(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('COME', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !_isHere ? null : () => _handleAction(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('GO', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          // Activity Log
          Expanded(
            child: _activityLog.isEmpty
                ? Center(
                    child: Text(
                      'No activity recorded yet',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _activityLog.length,
                    itemBuilder: (context, index) {
                      final log = _activityLog[index];
                      final isComing = log['isComing'] as bool;
                      final time = DateFormat('h:mm a').format(log['timestamp']);
                      final date = DateFormat('MMM d, y').format(log['timestamp']);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isComing
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          child: Icon(
                            isComing ? Icons.arrow_forward : Icons.arrow_back,
                            color: isComing ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(
                          log['action'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(date),
                        trailing: Text(
                          time,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
