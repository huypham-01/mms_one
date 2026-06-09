import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_extensions.dart';
import '../shared/base_workflow_screen.dart';
import '../../mixins/workflow_form_mixin.dart';
import '../../../providers/app_providers.dart';

class MaterialReceiverScreen extends StatefulWidget {
  const MaterialReceiverScreen({super.key});

  @override
  State<MaterialReceiverScreen> createState() => _MaterialReceiverScreenState();
}

class _MaterialReceiverScreenState extends State<MaterialReceiverScreen>
    with WorkflowFormMixin {
  @override
  String get workflowStep => 'receiver';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AppProviders.createWorkflowProvider(context, 'receiver')..fetch(),
      child: Builder(
        builder: (context) {
          return BaseWorkflowScreen(
            title: context.l10n.materialReceiver,
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
