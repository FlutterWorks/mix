import 'package:flutter/material.dart';

import '../../core/styled_widget.dart';
import 'text_spec.dart';

/// [StyledText] - A styled widget for displaying text with a mix of styles.
///
/// This widget extends [StyledWidget] and provides a way to display text with
/// styles defined in a `Style`. It is ideal for creating text elements in your
/// UI where the text styling needs to be dynamic and controlled through a styling system.
///
/// The [StyledText] is particularly useful when you need text elements that adapt
/// their styles based on different conditions or states, providing a more flexible
/// and maintainable approach compared to static styling.
///
/// Parameters:
///   - [text]: The text string to display.
///   - [semanticsLabel]: An optional semantics label for the text, used by screen readers.
///   - [style]: The [Style] to be applied to the text. Inherits from [StyledWidget].
///   - [key]: The key for the widget. Inherits from [StyledWidget].
///   - [inherit]: Determines whether the [StyledText] should inherit styles from its ancestors.
///     Default is `true`. Inherits from [StyledWidget].
///   - [locale]: The locale used for the text, affecting how it is displayed.
///
/// Example usage:
/// ```dart
/// StyledText(
///   'content',
///   style: myStyle,
/// )
/// ```
///
/// This example shows a `StyledText` widget displaying the string 'content'
/// with the styles defined in `myStyle`.
class StyledText extends StyledWidget {
  const StyledText(
    this.text, {
    this.semanticsLabel,
    super.style,
    super.key,
    super.inherit = true,
    this.locale,
    super.orderOfDecorators = const [],
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return withMix(context, (mix) {
      final spec = TextSpec.of(mix);

      return mix.isAnimated
          ? AnimatedMixedText(
              text: text,
              spec: spec,
              semanticsLabel: semanticsLabel,
              locale: locale,
              duration: mix.animation!.duration,
              curve: mix.animation!.curve,
            )
          : MixedText(
              text: text,
              spec: spec,
              semanticsLabel: semanticsLabel,
              locale: locale,
            );
    });
  }
}

class MixedText extends StatelessWidget {
  const MixedText({
    required this.text,
    required this.spec,
    this.semanticsLabel,
    this.locale,
    super.key,
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;
  final TextSpec spec;

  @override
  Widget build(BuildContext context) {
    // The Text widget is used here, applying the resolved styles and properties from TextSpec.
    return Text(
      spec.directive?.apply(text) ?? text,
      style: spec.style,
      strutStyle: spec.strutStyle,
      textAlign: spec.textAlign,
      textDirection: spec.textDirection,
      locale: locale,
      softWrap: spec.softWrap,
      overflow: spec.overflow,
      textScaleFactor: spec.textScaleFactor,
      maxLines: spec.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: spec.textHeightBehavior,
    );
  }
}

class AnimatedMixedText extends ImplicitlyAnimatedWidget {
  const AnimatedMixedText({
    required this.text,
    required this.spec,
    this.semanticsLabel,
    this.locale,
    super.key,
    required super.duration,
    super.curve = Curves.linear,
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;
  final TextSpec spec;

  @override
  AnimatedWidgetBaseState<AnimatedMixedText> createState() =>
      _AnimatedMixedTextState();
}

class _AnimatedMixedTextState
    extends AnimatedWidgetBaseState<AnimatedMixedText> {
  TextSpecTween? _textSpecTween;

  @override
  // ignore: avoid-dynamic
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _textSpecTween = visitor(
      _textSpecTween,
      widget.spec,
      // ignore: avoid-dynamic
      (dynamic value) => TextSpecTween(begin: value as TextSpec),
    ) as TextSpecTween?;
  }

  @override
  Widget build(BuildContext context) {
    final spec = _textSpecTween!.evaluate(animation);

    return Text(
      spec.directive?.apply(widget.text) ?? widget.text,
      style: spec.style,
      strutStyle: spec.strutStyle,
      textAlign: spec.textAlign,
      textDirection: spec.textDirection,
      locale: widget.locale,
      softWrap: spec.softWrap,
      overflow: spec.overflow,
      textScaleFactor: spec.textScaleFactor,
      maxLines: spec.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: spec.textHeightBehavior,
    );
  }
}
