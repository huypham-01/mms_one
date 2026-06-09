import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../mixins/workflow_report_mixin.dart';
import '../../providers/mr_workflow_provider.dart';

class WorkflowReportDetailScreen extends StatefulWidget {
  final String itemId;
  final String step;
  final String title;

  const WorkflowReportDetailScreen({
    super.key,
    required this.itemId,
    required this.step,
    required this.title,
  });

  @override
  State<WorkflowReportDetailScreen> createState() =>
      _WorkflowReportDetailScreenState();
}

class _WorkflowReportDetailScreenState extends State<WorkflowReportDetailScreen>
    with WorkflowReportMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MrWorkflowProvider>().loadReportDetail(
        widget.itemId,
        widget.step,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Consumer<MrWorkflowProvider>(
            builder: (context, provider, child) {
              final report = provider.reportDetail;
              if (report == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      context.push('/log-history/${report.requestId}');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Log History',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<MrWorkflowProvider>(
        builder: (context, provider, child) {
          if (provider.isDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.detailError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.detailError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            );
          }

          if (provider.isDetailEmpty || provider.reportDetail == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: AppColors.textTertiary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Report Data',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No workflow report data available for this step.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          final report = provider.reportDetail!;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildWorkflowInformation(context, report),
                  const SizedBox(height: 16),
                  buildMaterialRequestInformation(context, report),
                  const SizedBox(height: 16),
                  buildVerification(context, report),
                  const SizedBox(height: 16),
                  buildQuantityInformation(context, report),
                  const SizedBox(height: 16),
                  buildLotInformation(context, report),
                  const SizedBox(height: 16),
                  buildPictures(context, report),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
