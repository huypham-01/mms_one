import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_extensions.dart';
import '../shared/base_workflow_screen.dart';
import '../../mixins/workflow_form_mixin.dart';
import '../../../providers/app_providers.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen>
    with WorkflowFormMixin {
  @override
  String get workflowStep => 'warehouse';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AppProviders.createWorkflowProvider(context, 'warehouse')..fetch(),
      child: Builder(
        builder: (context) {
          return BaseWorkflowScreen(
            title: context.l10n.warehouse,
            status: context.l10n.inProgress,
            isLoading: isSubmitting,
            onPrimaryButtonPressed: onSubmitPressed,
            onRejectPressed: onRejectPressed,
            children: [
              buildMaterialRequestCard(context),
              const SizedBox(height: 16),
              buildLotInformationCard(context),
              const SizedBox(height: 16),
              buildVerificationCard(context),
              const SizedBox(height: 16),
              buildSpecPictureCard(context),
            ],
          );
        },
      ),
    );
  }
}
