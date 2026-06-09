import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_extensions.dart';
import '../shared/base_workflow_screen.dart';
import '../../mixins/workflow_form_mixin.dart';
import '../../../providers/app_providers.dart';

class ToProductionScreen extends StatefulWidget {
  const ToProductionScreen({super.key});

  @override
  State<ToProductionScreen> createState() => _ToProductionScreenState();
}

class _ToProductionScreenState extends State<ToProductionScreen>
    with WorkflowFormMixin {
  @override
  String get workflowStep => 'production';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AppProviders.createWorkflowProvider(context, 'production')..fetch(),
      child: Builder(
        builder: (context) {
          return BaseWorkflowScreen(
            title: context.l10n.toProduction,
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
