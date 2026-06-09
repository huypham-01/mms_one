import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/localization_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../domain/entities/storage_area_entity.dart';
import '../../providers/storage_area_provider.dart';
import 'widgets/storage_area_item.dart';

class StorageAreaScreen extends StatefulWidget {
  const StorageAreaScreen({super.key});

  @override
  State<StorageAreaScreen> createState() => _StorageAreaScreenState();
}

class _StorageAreaScreenState extends State<StorageAreaScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
            _buildSearchAndFilter(),
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

                  var filteredGroups = <StorageAreaGroupEntity>[];
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    for (final group in provider.groups) {
                      final matchingMrs = group.mrs.where((mr) {
                        return mr.requestNumber.toLowerCase().contains(query) ||
                            mr.pcn.toLowerCase().contains(query) ||
                            mr.materialPn.toLowerCase().contains(query) ||
                            // Attempt to match Work Order if it's hidden in lastConsumeToWhere
                            mr.lastConsumeToWhere.toLowerCase().contains(query);
                      }).toList();

                      if (matchingMrs.isNotEmpty) {
                        filteredGroups.add(
                          StorageAreaGroupEntity(
                            pcn: group.pcn,
                            mrCount: matchingMrs.length,
                            mrs: matchingMrs,
                          ),
                        );
                      }
                    }
                  } else {
                    filteredGroups = provider.groups;
                  }

                  if (filteredGroups.isEmpty) {
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
                          filteredGroups.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredGroups.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        final group = filteredGroups[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.folder_open_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${context.l10n.pcn}: ${group.pcn}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
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
                                      '${group.mrCount}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...group.mrs.map((mr) => StorageAreaItem(mr: mr)),
                            const SizedBox(height: 10),
                          ],
                        );
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

  Widget _buildSearchAndFilter() {
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
}
