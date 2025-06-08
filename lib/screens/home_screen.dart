import 'package:farm_booking_app/models/farm_house.dart';
import 'package:farm_booking_app/provider/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenProvider viewModel;
  @override
  void initState() {
    viewModel = Provider.of<HomeScreenProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        viewModel.fetchFarmHouses();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Booking App'),
      ),
      body: Selector<HomeScreenProvider, bool>(
        builder: (context, value, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.farmHouses.isEmpty) {
            return const Center(child: Text('No farm houses available'));
          }
          return Selector<HomeScreenProvider, FarmHouse?>(
            builder: (context, value, child) {
              return Center(
                child: Column(
                  children: [
                    DropdownButton<FarmHouse>(
                      value: viewModel.selectedFarmHouse,
                      onChanged: (FarmHouse? value) {
                        viewModel.setSelectedFarmHouse(value);
                      },
                      items: viewModel.farmHouses
                          .map<DropdownMenuItem<FarmHouse>>((value) {
                        return DropdownMenuItem<FarmHouse>(
                            value: value, child: Text(value.title));
                      }).toList(),
                    ),
                    TableCalendar(
                      firstDay: DateTime(2000),
                      lastDay: DateTime.now(),
                      focusedDay: DateTime.now(),
                      // selectedDayPredicate: (day) =>
                      //     isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {},
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            selector: (p0, p1) => p1.selectedFarmHouse,
          );
        },
        selector: (p0, p1) => p1.isLoading,
      ),
    );
  }
}
