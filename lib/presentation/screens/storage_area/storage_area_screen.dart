import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/localization_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../domain/entities/storage_area_entity.dart';
import '../../providers/storage_area_provider.dart';
import 'widgets/storage_area_item.dart';

// ---------------------------------------------------------------------------
// GroupBy mode
// ---------------------------------------------------------------------------
enum _GroupBy { none, pcn, materialPn }

class StorageAreaScreen extends StatefulWidget {
  const StorageAreaScreen({super.key});

  @override
  State<StorageAreaScreen> createState() => _StorageAreaScreenState();
}

class _StorageAreaScreenState extends State<StorageAreaScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _GroupBy _groupBy = _GroupBy.pcn;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StorageAreaProvider>().loadStorageAreas();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<StorageAreaProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Flatten all MRs from provider groups ──────────────────────────────────
  List<StorageAreaMrEntity> _getAllMrs(List<StorageAreaGroupEntity> groups) {
    return groups.expand((g) => g.mrs).toList();
  }

  // ── Apply search on flat list ──────────────────────────────────────────────
  List<StorageAreaMrEntity> _applyFilters(List<StorageAreaMrEntity> all) {
    var result = all;
    // The API handles status filtering directly via `?status=...`.
    // We only need to apply local search filtering.
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((mr) {
        return mr.requestNumber.toLowerCase().contains(q) ||
            mr.pcn.toLowerCase().contains(q) ||
            mr.materialPn.toLowerCase().contains(q) ||
            mr.materialName.toLowerCase().contains(q) ||
            mr.lastConsumeToWhere.toLowerCase().contains(q);
      }).toList();
    }
    return result;
  }

  // ── Build display items: either flat or grouped ───────────────────────────
  List<dynamic> _buildDisplayItems(List<StorageAreaMrEntity> filtered) {
    if (_groupBy == _GroupBy.none) return filtered;

    final Map<String, List<StorageAreaMrEntity>> map = {};
    for (final mr in filtered) {
      final key = _groupBy == _GroupBy.pcn
          ? (mr.pcn.isEmpty ? 'N/A' : mr.pcn)
          : (mr.materialPn.isEmpty ? 'N/A' : mr.materialPn);
      map.putIfAbsent(key, () => []).add(mr);
    }

    final keys = map.keys.toList()..sort();
    final List<dynamic> items = [];
    for (final key in keys) {
      items.add(key); // group header
      items.addAll(map[key]!);
    }
    return items;
  }

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
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.pdStorageArea,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                context.l10n.storageAreaSubtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildGroupAndFilterBar(),
            Expanded(
              child: Consumer<StorageAreaProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.groups.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.error != null && provider.groups.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.loadStorageAreas(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                            ),
                            child: Text(context.l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  final allMrs = _getAllMrs(provider.groups);
                  final filtered = _applyFilters(allMrs);
                  final displayItems = _buildDisplayItems(filtered);

                  if (displayItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: AppColors.textTertiary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.noStorageAreaData,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: provider.refresh,
                    color: AppColors.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      itemCount:
                          displayItems.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Load-more footer
                        if (index == displayItems.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        final item = displayItems[index];

                        // Group header
                        if (item is String) {
                          final label = _groupBy == _GroupBy.pcn
                              ? '${context.l10n.pcn}: $item'
                              : 'Material PN: $item';
                          // Count items in this group
                          int count = 0;
                          for (
                            int j = index + 1;
                            j < displayItems.length;
                            j++
                          ) {
                            if (displayItems[j] is StorageAreaMrEntity) {
                              count++;
                            } else {
                              break;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.folder_open_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // MR item
                        final mr = item as StorageAreaMrEntity;
                        return StorageAreaItem(mr: mr);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: AppSearchBar(
        controller: _searchController,
        hintText: context.l10n.searchStorageAreaHint,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        trailing: _searchQuery.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
              )
            : null,
      ),
    );
  }

  // ── Group & Filter bar ─────────────────────────────────────────────────────
  Widget _buildGroupAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ── Group by dropdown ────────────────────────────────────────────
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<_GroupBy>(
                  value: _groupBy,
                  isDense: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: _GroupBy.none,
                      child: Text('No Grouping'),
                    ),
            
                    DropdownMenuItem(
                      value: _GroupBy.pcn,
                      child: Text('Group by PCN'),
                    ),
                    DropdownMenuItem(
                      value: _GroupBy.materialPn,
                      child: Text('Group by Material PN'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _groupBy = val);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // ── Filter by status dropdown ─────────────────────────────────────
            Consumer<StorageAreaProvider>(
              builder: (context, provider, _) {
                final statuses = [
                  'All',
                  'in_progress',
                  'in_use',
                  'pending_confirm',
                  'rejected',
                  'closed',
                ];

                final currentValue = statuses.contains(_filterStatus)
                    ? _filterStatus
                    : 'All';

                String getStatusLabel(String status) {
                  switch (status) {
                    case 'All':
                      return 'All Statuses';
                    case 'in_progress':
                      return 'In Progress';
                    case 'in_use':
                      return 'In Use';
                    case 'pending_confirm':
                      return 'Pending Confirm';
                    case 'rejected':
                      return 'Rejected';
                    case 'closed':
                      return 'Closed';
                    default:
                      return status;
                  }
                }

                return Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: currentValue != 'All'
                        ? AppColors.primarySurface
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(18),
                    border: currentValue != 'All'
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                          )
                        : null,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentValue,
                      isDense: true,
                      icon: Icon(
                        Icons.filter_list,
                        size: 18,
                        color: currentValue != 'All'
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: currentValue != 'All'
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                      items: statuses.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(getStatusLabel(s)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null && val != _filterStatus) {
                          setState(() => _filterStatus = val);
                          context.read<StorageAreaProvider>().loadStorageAreas(
                            status: val,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
