import 'package:flutter/material.dart';
import 'package:calorie_checker_ai/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: l10n.privacyPolicyIntroTitle,
              content: l10n.privacyPolicyIntroContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataCollectionTitle,
              content: l10n.privacyPolicyDataCollectionContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataUsageTitle,
              content: l10n.privacyPolicyDataUsageContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataStorageTitle,
              content: l10n.privacyPolicyDataStorageContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataSharingTitle,
              content: l10n.privacyPolicyDataSharingContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyUserRightsTitle,
              content: l10n.privacyPolicyUserRightsContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicySecurityTitle,
              content: l10n.privacyPolicySecurityContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyChangesTitle,
              content: l10n.privacyPolicyChangesContent,
              theme: theme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyContactTitle,
              content: l10n.privacyPolicyContactContent,
              theme: theme,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                l10n.privacyPolicyLastUpdated,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }
}