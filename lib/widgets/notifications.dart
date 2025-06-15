import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {
  final DateTime eventDate;

  const NotificationsWidget({Key? key, required this.eventDate})
      : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  bool _notificationsEnabled = false;
  String _selectedInterval = '1 día antes';

  final List<Map<String, dynamic>> _intervalOptions = [
    {'label': '1 día antes', 'days': 1},
    {'label': '2 días antes', 'days': 2},
    {'label': '3 días antes', 'days': 3},
    {'label': '1 semana antes', 'days': 7},
  ];

  List<String> get _filteredOptions {
    final now = DateTime.now();
    final difference = widget.eventDate.difference(now).inDays;
    return _intervalOptions
        .where((option) => option['days'] <= difference)
        .map((option) => option['label'] as String)
        .toList();
  }

  void _onToggle(bool value) async {
    if (value) {
      final options = _filteredOptions;
      if (options.isEmpty) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.notifications_off,
                    size: 48, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text(
                  'Notificaciones no disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No hay intervalos de notificación disponibles para esta fecha.',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }
      String? selected = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.notifications_active, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Elige cuándo notificarte',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: option == _selectedInterval
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                  leading: Icon(
                    Icons.schedule,
                    color: Colors.blueAccent,
                  ),
                  title: Text(option),
                  onTap: () => Navigator.pop(context, option),
                ),
              ),
            )
                .toList(),
          ),
        ),
      );
      if (selected != null) {
        setState(() {
          _notificationsEnabled = true;
          _selectedInterval = selected;
        });
      }
    } else {
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(1),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _notificationsEnabled
                        ? 'Notificaciones Activadas'
                        : 'Notificaciones Desactivadas',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: _onToggle,
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.grey,
                  activeTrackColor: Colors.blue.withOpacity(0.5),
                  inactiveTrackColor: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
            if (_notificationsEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Notificar: $_selectedInterval',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final options = _filteredOptions;
                        if (options.isEmpty) return;
                        String? selected = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              children: const [
                                Icon(Icons.notifications_active, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'Elige cuándo notificarte',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: options
                                  .map(
                                    (option) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    tileColor: option == _selectedInterval
                                        ? Colors.blue.withOpacity(0.1)
                                        : null,
                                    leading: Icon(
                                      Icons.schedule,
                                      color: Colors.blueAccent,
                                    ),
                                    title: Text(option),
                                    onTap: () => Navigator.pop(context, option),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                        );
                        if (selected != null) {
                          setState(() {
                            _selectedInterval = selected;
                          });
                        }
                      },
                      child: const Text(
                        'Cambiar',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
