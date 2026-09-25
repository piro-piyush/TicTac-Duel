import 'package:tictac_duel/lib.dart';

class SectionTitleAndOptionsWidget extends StatelessWidget {
  final String title;
  final IconData? titleIcon;
  final List<Widget> children;

  const SectionTitleAndOptionsWidget({
    super.key,
    required this.title,
    this.titleIcon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.ten,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: title),
        Card(
          color: Themes.surface,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(
              children.length * 2 - 1,
              (index) =>
                  index.isOdd ? const DividerWidget() : children[index ~/ 2],
            ),
          ),
        ),
      ],
    );
  }
}
