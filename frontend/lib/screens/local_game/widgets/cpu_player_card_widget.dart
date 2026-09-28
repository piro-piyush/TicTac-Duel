import 'package:tictac_duel/lib.dart';

class CpuPlayerCardWidget extends StatelessWidget {
  const CpuPlayerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets16,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: Dimens.radius16,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        spacing: Dimens.eight,
        children: [
          const Icon(Icons.smart_toy_rounded, color: AppColors.neonPink),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CPU', style: Theme.of(context).textTheme.titleMedium),
              Text(
                'Computer opponent',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
