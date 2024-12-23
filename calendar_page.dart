import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
          titleMedium: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Map<DateTime, List<String>> _events = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _events[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Calendar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPage(
                      events: _events,
                      onUpdate: (updatedEvents) {
                        setState(() {
                          _events.clear();
                          _events.addAll(updatedEvents);
                        });
                      }),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2024, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _isAnimating = true;
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {
                  _isAnimating = false;
                });
              });
            },
            eventLoader: (day) => _events[day] ?? [],
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Colors.black),
              weekendTextStyle: const TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isAnimating
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    )
                  : selectedEvents.isEmpty
                      ? Center(
                          child: Text(
                            'No events for this day.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          key: ValueKey(_selectedDay),
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: 1.0,
                              child: Card(
                                color: Colors.grey[900],
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.event,
                                      color: Colors.teal),
                                  title: Text(
                                    selectedEvents[index],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminPage extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  final Function(Map<DateTime, List<String>>) onUpdate;

  const AdminPage({super.key, required this.events, required this.onUpdate});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _eventController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final String _adminPassword = "admin123";
  bool _isAuthenticated = false;

  void _authenticate(String password) {
    if (password == _adminPassword) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Assign Events'),
        centerTitle: true,
      ),
      body: _isAuthenticated
          ? Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(2024, 1, 1),
                  lastDay: DateTime(2024, 12, 31),
                  focusedDay: _selectedDate,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_eventController.text.isNotEmpty) {
                      setState(() {
                        if (widget.events[_selectedDate] == null) {
                          widget.events[_selectedDate] = [];
                        }
                        widget.events[_selectedDate]
                            ?.add(_eventController.text);
                        widget.onUpdate(widget.events);
                      });
                      _eventController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Event added successfully!')),
                      );
                    }
                  },
                  child: const Text('Add Event'),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter Admin Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _authenticate,
                  ),
                ],
              ),
            ),
    );
  }
}
