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
    const radius = BorderRadius.all(Radius.circular(14));
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: title),
        Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              color: Themes.surface,
              borderRadius: radius,
              border: Border.all(color: Themes.border),
            ),
            child: Column(
              children: List.generate(children.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return const DividerWidget();
                }

                return children[index ~/ 2];
              }),
            ),
          ),
        ),
      ],
    );
  }
}
