import 'package:flutter/material.dart';
import '../../../domain/entities/mr_request_entity.dart';
import '../../screens/shared/base_workflow_screen.dart';
import '../../mixins/workflow_form_mixin.dart';
import '../../../core/localization/localization_extensions.dart';

class PreparerScreen extends StatefulWidget {
  final MrRequestEntity? request;

  const PreparerScreen({super.key, this.request});

  @override
  State<PreparerScreen> createState() => _PreparerScreenState();
}

class _PreparerScreenState extends State<PreparerScreen>
    with WorkflowFormMixin {
  @override
  String get workflowStep => 'preparer';

  @override
  Widget build(BuildContext context) {
    return BaseWorkflowScreen(
      title: context.l10n.preparer,
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
  }
}
