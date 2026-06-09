import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../routes/route_names.dart';
import '../../providers/mr_request_provider.dart';
import 'widgets/mr_request_card.dart';

/// Material Request listing screen with search, filters, and ERP-style cards.
class MaterialRequestScreen extends StatefulWidget {
  const MaterialRequestScreen({super.key});

  @override
  State<MaterialRequestScreen> createState() => _MaterialRequestScreenState();
}

class _MaterialRequestScreenState extends State<MaterialRequestScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  static const _filters = ['All', 'In Use', 'Open', 'In Progress', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MrRequestProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => context.go(RouteNames.homePath),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),

          titleSpacing: 0,

          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Material Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Manage material requisitions',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Consumer<MrRequestProvider>(
                  builder: (_, p, __) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: Text(
                      '${p.total} items',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Column(
            children: [
              _buildSearchAndFilter(),
              // _buildFilterChips(),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      child: AppSearchBar(
        controller: _searchController,
        hintText: 'Search request number, material...',
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_searchQuery.isNotEmpty)
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _filters[i] == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.cardBorder,
                ),
              ),
              child: Center(
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return Consumer<MrRequestProvider>(
      builder: (context, provider, _) {
        var filteredList = provider.requests;

        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          filteredList = filteredList.where((item) {
            return item.requestNumber.toLowerCase().contains(query) ||
                item.workOrder.toLowerCase().contains(query) ||
                item.materialPn.toLowerCase().contains(query) ||
                item.pcn.toLowerCase().contains(query);
          }).toList();
        }

        if (_selectedFilter != 'All') {
          filteredList = filteredList.where((item) {
            return item.requestStatus.toLowerCase() ==
                    _selectedFilter.toLowerCase() ||
                item.currentStatus.toLowerCase() ==
                    _selectedFilter.toLowerCase();
          }).toList();
        }

        if (provider.isLoading && filteredList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (filteredList.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: AppColors.textTertiary.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No requests found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: provider.refresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
            itemCount: filteredList.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= filteredList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }

              final item = filteredList[index];
              return MrRequestCard(
                requestNumber: item.requestNumber,
                workOrder: item.workOrder,
                demandWk: item.demandWk,
                pcn: item.pcn,
                finishGoodCtn: item.finishGoodCtn,
                materialPn: item.materialPn,
                materialName: item.materialName,
                requestQuantity: item.requestQuantity,
                unit: item.unit,
                currentStatus: item.currentStatus,
                currentStep: item.currentStep,
                requestDate: item.requestDate,
                // onTap: () => context.pushNamed(RouteNames.materialRequestDetail, extra: item),
              );
            },
          ),
        );
      },
    );
  }
}
