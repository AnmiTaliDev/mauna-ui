import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaFormSection extends StatelessWidget {
  const MaunaFormSection({
    super.key,
    required this.children,
    this.title,
    this.footer,
  });

  final List<Widget> children;

  final String? title;

  final String? footer;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.xs,
      children: <Widget>[
        if (title case final String text)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            child: Text(
              text,
              style: theme.uiStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.bgCard,
            borderRadius: BorderRadius.circular(theme.radiusLg),
            border: Border.all(
              color: theme.line,
              width: theme.metrics.borderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0)
                  Container(
                    height: theme.metrics.borderWidth,
                    margin: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                    color: theme.line,
                  ),
                children[i],
              ],
            ],
          ),
        ),
        if (footer case final String text)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            child: Text(text, style: theme.captionStyle),
          ),
      ],
    );
  }
}

class MaunaFormRow extends StatelessWidget {
  const MaunaFormRow({
    super.key,
    required this.label,
    this.description,
    this.control,
    this.below,
  });

  final String label;

  final String? description;

  final Widget? control;

  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: theme.spacing.sm,
        children: <Widget>[
          Row(
            spacing: theme.spacing.lg,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: theme.metrics.listItemGap * 2,
                  children: <Widget>[
                    Text(label, style: theme.uiStyle),
                    if (description case final String text)
                      Text(text, style: theme.captionStyle),
                  ],
                ),
              ),
              ?control,
            ],
          ),
          ?below,
        ],
      ),
    );
  }
}
