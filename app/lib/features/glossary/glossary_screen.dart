import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import 'glossary_data.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final terms = searchGlossary(_query);
    final hasQuery = _query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Glosario')),
      body: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxxl,
        ),
        children: [
          Text(
            'Palabras de tu recibo, sin jerga',
            style: textTheme.headlineMedium?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Cada término con una definición breve y un ejemplo.',
            style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xxl),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            style: textTheme.bodyLarge?.copyWith(color: palette.ink),
            decoration: const InputDecoration(
              hintText: 'Buscar término…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (terms.isEmpty)
            Text(
              hasQuery
                  ? 'No encontramos "$_query". Prueba con "UMA", "ISR" o "IVA".'
                  : 'Aún no hay términos para mostrar.',
              style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
            )
          else
            for (var i = 0; i < terms.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              _GlossaryCard(term: terms[i]),
            ],
        ],
      ),
    );
  }
}

class _GlossaryCard extends StatelessWidget {
  const _GlossaryCard({required this.term});

  final GlossaryTerm term;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            term.term,
            style: textTheme.titleMedium?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            term.definition,
            style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 14,
                color: palette.accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  term.example,
                  style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
