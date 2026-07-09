import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routes/route_names.dart';
import '../../providers/mr_request_provider.dart';
import 'widgets/mr_request_card.dart';

/// Material Request listing screen with search, filters, and ERP-style cards.
class MaterialRequestScreen extends StatefulWidget {
  const MaterialRequestScreen({super.key});

  @override
  State<MaterialRequestScreen> createState() => _MaterialRequestScreenState();
}

class _MaterialRequestScreenState extends State<MaterialRequestScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Date filter state ──────────────────────────────────────────────
  bool _filterExpanded = false;
  /// 'single' | 'range'
  String _dateFilterMode = 'single';
  DateTime? _singleDate;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
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
    _expandController.dispose();
    super.dispose();
  }

  // ── Date helpers ────────────────────────────────────────────────────
  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<DateTime?> _pickDate(BuildContext ctx, {DateTime? initial}) async {
    final now = DateTime.now();
    return showDatePicker(
      context: ctx,
      initialDate: initial ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
  }

  bool get _hasActiveFilter =>
      _singleDate != null || _dateFrom != null || _dateTo != null;

  void _toggleExpand() {
    setState(() => _filterExpanded = !_filterExpanded);
    if (_filterExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  Future<void> _applyFilter() async {
    final provider = context.read<MrRequestProvider>();
    if (_dateFilterMode == 'single' && _singleDate != null) {
      await provider.applyDateFilter(date: _formatDate(_singleDate!));
    } else if (_dateFilterMode == 'range') {
      await provider.applyDateFilter(
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
      );
    } else {
      await provider.clearDateFilter();
    }
    // Collapse panel after applying
    setState(() => _filterExpanded = false);
    _expandController.reverse();
  }

  Future<void> _clearFilter() async {
    setState(() {
      _singleDate = null;
      _dateFrom = null;
      _dateTo = null;
    });
    await context.read<MrRequestProvider>().clearDateFilter();
  }

  // ── Build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.materialRequestTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.manageRequisitions,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
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
                      '${p.total} ${l10n.items}',
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
              _buildSearchAndFilter(context),
              _buildDateFilterPanel(context),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search bar + filter toggle button ──────────────────────────────
  Widget _buildSearchAndFilter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: AppSearchBar(
        controller: _searchController,
        hintText: l10n.searchByRequestNumber,
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
            // Date filter toggle button
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: _toggleExpand,
                  tooltip: l10n.dateFilterTooltip,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _filterExpanded
                          ? Icons.filter_list_off_rounded
                          : Icons.filter_list_rounded,
                      key: ValueKey(_filterExpanded),
                      size: 22,
                      color: _filterExpanded || _hasActiveFilter
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (_hasActiveFilter)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Collapsible date filter panel ───────────────────────────────────
  Widget _buildDateFilterPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizeTransition(
      sizeFactor: _expandAnimation,
      axisAlignment: -1.0, // Tương đương với việc mở rộng từ trên xuống (top)
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasActiveFilter
                ? AppColors.primaryBorder
                : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                const Icon(Icons.date_range_rounded,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.dateFilterTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_hasActiveFilter)
                  GestureDetector(
                    onTap: _clearFilter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.close_rounded,
                              size: 12, color: AppColors.error),
                          const SizedBox(width: 3),
                          Text(
                            l10n.clear,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Mode selector chips
            Row(
              children: [
                _ModeChip(
                  label: l10n.specificDate,
                  icon: Icons.today_rounded,
                  selected: _dateFilterMode == 'single',
                  onTap: () => setState(() {
                    _dateFilterMode = 'single';
                    _dateFrom = null;
                    _dateTo = null;
                  }),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: l10n.dateRange,
                  icon: Icons.date_range_rounded,
                  selected: _dateFilterMode == 'range',
                  onTap: () => setState(() {
                    _dateFilterMode = 'range';
                    _singleDate = null;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date pickers
            if (_dateFilterMode == 'single') ...[
              _DatePickerField(
                label: l10n.date,
                value: _singleDate != null ? _displayDate(_singleDate!) : null,
                placeholder: l10n.selectDate,
                onTap: () async {
                  final d = await _pickDate(context, initial: _singleDate);
                  if (d != null) setState(() => _singleDate = d);
                },
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: l10n.fromDate,
                      value:
                          _dateFrom != null ? _displayDate(_dateFrom!) : null,
                      placeholder: l10n.selectDate,
                      onTap: () async {
                        final d =
                            await _pickDate(context, initial: _dateFrom);
                        if (d != null) setState(() => _dateFrom = d);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DatePickerField(
                      label: l10n.toDate,
                      value: _dateTo != null ? _displayDate(_dateTo!) : null,
                      placeholder: l10n.selectDate,
                      onTap: () async {
                        final d = await _pickDate(context, initial: _dateTo);
                        if (d != null) setState(() => _dateTo = d);
                      },
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _applyFilter,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: Text(
                  l10n.apply,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<MrRequestProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
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
                Text(
                  l10n.noRequestsFound,
                  style: const TextStyle(color: AppColors.textSecondary),
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
                id: item.id,
                mrNo: item.mrNo,
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

// ── Small reusable sub-widgets ──────────────────────────────────────────────

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: hasValue ? AppColors.primarySurface : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasValue ? AppColors.primaryBorder : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: hasValue ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value ?? placeholder,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasValue
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: hasValue ? AppColors.primary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
