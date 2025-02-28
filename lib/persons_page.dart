import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'provider/provider.dart';
import 'person_detail.dart';

/// Displays a list of persons and handles infinite scrolling and data fetching.

class PersonsPage extends StatefulWidget {
  const PersonsPage({Key? key}) : super(key: key);

  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  int fetchAttempts = 0;
  bool hasMoreData = true;
  bool isFetching = false;
  bool canShowSnackbar = false;
  double lastScrollPosition = 0; // Tracks user scroll direction

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PersonProvider>(context, listen: false).fetchPersons(10);
    });
  }

  /// Loads additional persons when scrolling and ensures that data fetching stops after 4 attempts.
  void _loadMoreData() async {
    final provider = Provider.of<PersonProvider>(context, listen: false);
    if (isFetching || !hasMoreData) return;

    setState(() {
      isFetching = true;
    });

    if (fetchAttempts < 3) {
      await provider.fetchPersons(20);
      fetchAttempts++;
    }

    if (fetchAttempts >= 3) {
      setState(() {
        hasMoreData = false;
        canShowSnackbar = true;
      });
    }

    setState(() {
      isFetching = false;
    });
  }

  /// Detects when the user reaches the bottom of the list and handles snackbar visibility.
  void _checkIfAtBottom(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels > lastScrollPosition) {

      if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
        if (!hasMoreData && canShowSnackbar) {
          canShowSnackbar = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more data available'),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              canShowSnackbar = true;
            });
          });
        }
      }
    }
    lastScrollPosition = scrollInfo.metrics.pixels; // Update last scroll position
  }

  /// Refreshes the list and resets fetching state.
  Future<void> _refreshData() async {
    setState(() {
      fetchAttempts = 0;
      hasMoreData = true;
      canShowSnackbar = false;
    });
    Provider.of<PersonProvider>(context, listen: false).refreshPersons();
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = false;
    try {
      isWeb = !Platform.isAndroid && !Platform.isIOS;
    } catch (e) {
      isWeb = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons List'),
        actions: isWeb
            ? [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ]
            : null,
      ),
      backgroundColor: Colors.black,
      body: Consumer<PersonProvider>(
        builder: (context, provider, child) {

          if (provider.isLoading && provider.persons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                _loadMoreData();
              }
              _checkIfAtBottom(scrollInfo);
              return false;
            },
            child: isWeb
                ? _buildPersonList(provider, withRefresh: false) // No pull-to-refresh for web
                : RefreshIndicator(
              onRefresh: _refreshData,
              child: _buildPersonList(provider, withRefresh: true),
            ),
          );
        },
      ),
    );
  }

  /// Builds the list of persons with optional loading indicators.
  Widget _buildPersonList(PersonProvider provider, {required bool withRefresh}) {
    return ListView.builder(
      physics: withRefresh ? const AlwaysScrollableScrollPhysics() : null,
      itemCount: provider.persons.length + (isFetching ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.persons.length && isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        final person = provider.persons[index];
        return ListTile(
          leading: const Icon(Icons.account_circle, size: 50, color: Colors.white),
          title: Text(
            '${person.firstname} ${person.lastname}',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(person.email, style: const TextStyle(color: Colors.white70)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetailPage(
                  name: '${person.firstname} ${person.lastname}',
                  email: person.email,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
