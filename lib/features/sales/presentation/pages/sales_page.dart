import 'package:compareitr/features/sales/presentation/pages/sale_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart'; // Importing the collection package
import 'package:compareitr/features/sales/presentation/bloc/salecard_bloc.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to get sales when the page is initialized
    context.read<SalecardBloc>().add(GetAllSaleCardEvent());
  }

  int calculateDaysLeft(DateTime? endDate) {
    if (endDate == null) return 0; // If endDate is null, return 0 days left
    final currentDate = DateTime.now();
    return endDate.difference(currentDate).inDays;
  }

  // Helper function to check if the date range overlaps
  bool checkDateOverlap(DateTime productStart, DateTime productEnd, DateTime widgetStart, DateTime widgetEnd) {
    // Overlap occurs when:
    // 1. Product's start date is before or same as widget's end date.
    // 2. Product's end date is after or same as widget's start date.
    return (productStart.isBefore(widgetEnd) || productStart.isAtSameMomentAs(widgetEnd)) && 
           (productEnd.isAfter(widgetStart) || productEnd.isAtSameMomentAs(widgetStart));
  }

  Widget buildSaleItem(
      DateTime? startDate, DateTime? endDate, String? storeName) {
    if (startDate == null || endDate == null) {
      return const Center(child: Text("Invalid Sale Dates"));
    }

    final daysLeft = calculateDaysLeft(endDate);

    // Assuming you already have the widget's startDate and endDate (perhaps selected from a filter)
    DateTime widgetStartDate = DateTime(2024, 12, 16); // Replace with actual value
    DateTime widgetEndDate = DateTime(2024, 12, 30);  // Replace with actual value

    // The product start and end dates are used in the print statements
    print('Checking product: $storeName');
    print('Checking overlap: Product startDate = ${DateFormat('yyyy-MM-dd').format(startDate)}, '
          'product endDate = ${DateFormat('yyyy-MM-dd').format(endDate)}, '
          'Widget startDate = ${DateFormat('yyyy-MM-dd').format(widgetStartDate)}, '
          'Widget endDate = ${DateFormat('yyyy-MM-dd').format(widgetEndDate)}');

    // Check if the product's dates overlap with the widget's date range
    if (!checkDateOverlap(startDate!, endDate!, widgetStartDate, widgetEndDate)) {
      print('Product date range does not overlap with widget date range');
      return const SizedBox.shrink();  // No product is shown if dates do not overlap
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaleDetailsPage(
              storeName: storeName,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Starts: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
            Text('Ends: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
            Text('Days left: $daysLeft'),
          ],
        ),
      ),
    );
  }

  Widget buildStoreSection(
      String? storeName, List<Map<String, DateTime?>> sales) {
    final displayStoreName = storeName ?? "Unknown Store";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            displayStoreName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: sales.length,
          itemBuilder: (context, index) {
            return buildSaleItem(
              sales[index]['startDate'],
              sales[index]['endDate'],
              storeName,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Page'),
      ),
      body: BlocBuilder<SalecardBloc, SalecardState>(builder: (context, state) {
        if (state is SalecardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalecardSuccess) {
          final groupedSales =
              groupBy(state.saleCard, (sale) => sale.storeName);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedSales.entries.map((entry) {
                final storeName = entry.key;
                final sales = entry.value.map((sale) {
                  return {
                    'startDate': sale.startDate,
                    'endDate': sale.endDate,
                  };
                }).toList();

                return buildStoreSection(storeName, sales);
              }).toList(),
            ),
          );
        } else if (state is SalecardFailure) {
          return Center(
            child: Text(
              'Error loading sales: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('No sales available.'));
      }),
    );
  }
}
