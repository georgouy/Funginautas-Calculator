import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculation_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_segment_widget.dart';

class CalculationHistory extends StatefulWidget {
  const CalculationHistory({super.key});

  @override
  State<CalculationHistory> createState() => _CalculationHistoryState();
}

class _CalculationHistoryState extends State<CalculationHistory>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearching = false;

  // Mock calculation data
  final List<Map<String, dynamic>> _allCalculations = [
    {
      "id": 1,
      "type": "CVG",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "inputs": {
        "cocoCoir": 500.0,
        "water": 1250.0,
        "vermiculite": 250.0,
        "gypsum": 25.0,
      },
      "results": {
        "totalVolume": 2025.0,
        "ratio": "2:5:1:0.05",
      }
    },
    {
      "id": 2,
      "type": "LC",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "inputs": {
        "water": 1000.0,
        "extractType": "Honey",
        "ratio": "2%",
      },
      "results": {
        "extractAmount": 20.0,
        "finalVolume": 1020.0,
      }
    },
    {
      "id": 3,
      "type": "CVG",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "inputs": {
        "cocoCoir": 750.0,
        "water": 1875.0,
        "vermiculite": 375.0,
        "gypsum": 37.5,
      },
      "results": {
        "totalVolume": 3037.5,
        "ratio": "2:5:1:0.05",
      }
    },
    {
      "id": 4,
      "type": "LC",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "inputs": {
        "water": 500.0,
        "extractType": "Malt Extract",
        "ratio": "4%",
      },
      "results": {
        "extractAmount": 20.0,
        "finalVolume": 520.0,
      }
    },
    {
      "id": 5,
      "type": "CVG",
      "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      "inputs": {
        "cocoCoir": 1000.0,
        "water": 2500.0,
        "vermiculite": 500.0,
        "gypsum": 50.0,
      },
      "results": {
        "totalVolume": 4050.0,
        "ratio": "2:5:1:0.05",
      }
    },
  ];

  List<Map<String, dynamic>> get _filteredCalculations {
    List<Map<String, dynamic>> filtered = _allCalculations;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered =
          filtered.where((calc) => calc['type'] == _selectedFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((calc) {
        final type = calc['type'].toString().toLowerCase();
        final extractType =
            calc['inputs']['extractType']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return type.contains(query) || extractType.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _clearAllCalculations() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear All History',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete all calculation history? This action cannot be undone.',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _allCalculations.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All calculations cleared'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorWarm,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _onCalculationAction(String action, Map<String, dynamic> calculation) {
    switch (action) {
      case 'reuse':
        _reuseCalculation(calculation);
        break;
      case 'share':
        _shareCalculation(calculation);
        break;
      case 'duplicate':
        _duplicateCalculation(calculation);
        break;
      case 'delete':
        _deleteCalculation(calculation);
        break;
    }
  }

  void _reuseCalculation(Map<String, dynamic> calculation) {
    final String route =
        calculation['type'] == 'CVG' ? '/cvg-calculator' : '/lc-calculator';

    Navigator.pushNamed(context, route);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Values loaded into ${calculation['type']} calculator'),
      ),
    );
  }

  void _shareCalculation(Map<String, dynamic> calculation) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculation shared successfully'),
      ),
    );
  }

  void _duplicateCalculation(Map<String, dynamic> calculation) {
    final newCalculation = Map<String, dynamic>.from(calculation);
    newCalculation['id'] = _allCalculations.length + 1;
    newCalculation['timestamp'] = DateTime.now();

    setState(() {
      _allCalculations.insert(0, newCalculation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculation duplicated'),
      ),
    );
  }

  void _deleteCalculation(Map<String, dynamic> calculation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Calculation',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this calculation?',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _allCalculations
                      .removeWhere((calc) => calc['id'] == calculation['id']);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calculation deleted'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorWarm,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // Simulate refresh by updating timestamps
      for (var calc in _allCalculations) {
        calc['timestamp'] = DateTime.now().subtract(
          Duration(hours: _allCalculations.indexOf(calc) * 2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 24,
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search calculations...',
                  hintStyle: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text(
                'Calculation History',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                ),
              ),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: AppTheme.onSurfacePrimary,
              size: 24,
            ),
          ),
          if (!_isSearching && _allCalculations.isNotEmpty)
            PopupMenuButton<String>(
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.onSurfacePrimary,
                size: 24,
              ),
              onSelected: (value) {
                if (value == 'clear_all') {
                  _clearAllCalculations();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear All'),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter segment
          if (!_isSearching)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: FilterSegmentWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: _onFilterChanged,
              ),
            ),

          // Main content
          Expanded(
            child: _filteredCalculations.isEmpty
                ? EmptyStateWidget(
                    hasCalculations: _allCalculations.isNotEmpty,
                    isFiltered:
                        _selectedFilter != 'All' || _searchQuery.isNotEmpty,
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.secondaryGold,
                    backgroundColor: AppTheme.surfaceElevated,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _filteredCalculations.length,
                      itemBuilder: (context, index) {
                        final calculation = _filteredCalculations[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: CalculationCardWidget(
                            calculation: calculation,
                            onAction: _onCalculationAction,
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