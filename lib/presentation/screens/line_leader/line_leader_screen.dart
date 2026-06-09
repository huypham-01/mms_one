import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_extensions.dart';
import '../shared/base_workflow_screen.dart';
import '../../mixins/workflow_form_mixin.dart';
import '../../../providers/app_providers.dart';

class LineLeaderScreen extends StatefulWidget {
  const LineLeaderScreen({super.key});

  @override
  State<LineLeaderScreen> createState() => _LineLeaderScreenState();
}

class _LineLeaderScreenState extends State<LineLeaderScreen>
    with WorkflowFormMixin {
  @override
  String get workflowStep => 'line_leader';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AppProviders.createWorkflowProvider(context, 'line_leader')..fetch(),
      child: Builder(
        builder: (context) {
          return BaseWorkflowScreen(
            title:  context.l10n.lineLeader,
            status:  context.l10n.inProgress,
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
