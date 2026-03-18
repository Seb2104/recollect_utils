part of '../../../recollect_utils.dart';

class Format {
  BuildContext context;
  sp.Editor editor;
  sp.MutableDocumentComposer composer;
  sp.MutableDocument document;
  VoidCallback? onDocumentModified;

  Format({
    required this.context,
    required this.editor,
    required this.composer,
    required this.document,
    this.onDocumentModified,
  });

  Set get selectedAttributions =>
      document.getAllAttributions(composer.selection!);

  Set<sp.Attribution> getAllAttributions() {
    final selection = composer.selection;
    if (selection == null) return {};

    if (selection.isCollapsed) {
      return composer.preferences.currentAttributions;
    }

    return document.getAllAttributions(selection);
  }

  bool hasAttribution(Attributions attribution) {
    return selectedAttributions.contains(sp.NamedAttribution(attribution.name));
  }

  void _toggleAttribution(sp.Attribution attribution) {
    final selection = composer.selection;
    if (selection == null) {
      return;
    }

    if (selection.isCollapsed) {
      // Handle collapsed selection (cursor position)
      if (composer.preferences.currentAttributions.contains(attribution)) {
        composer.preferences.removeStyle(attribution);
      } else {
        composer.preferences.addStyle(attribution);
      }
      onDocumentModified?.call();
      return;
    }

    // Handle text selection
    editor.execute([
      sp.ToggleTextAttributionsRequest(
        documentRange: selection,
        attributions: {attribution},
      ),
    ]);
    onDocumentModified?.call();
  }

  void changeHeading(Attributions heading) {
    final selection = composer.selection;
    if (selection == null) {
      context.notify('Please select text first');
      return;
    }

    sp.Attribution toLevel = switch (heading) {
      Attributions.header1 => sp.header1Attribution,
      Attributions.header2 => sp.header2Attribution,
      Attributions.header3 => sp.header3Attribution,
      Attributions.header4 => sp.header4Attribution,
      Attributions.header5 => sp.header5Attribution,
      Attributions.header6 => sp.header6Attribution,
      Attributions.paragraph => sp.paragraphAttribution,
      _ => sp.paragraphAttribution,
    };

    editor.execute([
      sp.ChangeParagraphBlockTypeRequest(
        nodeId: composer.selection!.start.nodeId,
        blockType: toLevel,
      ),
    ]);
    onDocumentModified?.call();
  }

  void changeFontFamily(Font font) {
    final selection = composer.selection;
    if (selection == null) {
      context.notify('Please select text first');
      return;
    }

    editor.execute([
      sp.AddTextAttributionsRequest(
        documentRange: selection,
        attributions: {sp.FontFamilyAttribution(font)},
      ),
    ]);
    onDocumentModified?.call();
  }

  void changeFontSize(double fontSize) {
    final selection = composer.selection;
    if (selection == null) {
      context.notify('Please select text first');
      return;
    }

    editor.execute([
      sp.AddTextAttributionsRequest(
        documentRange: selection,
        attributions: {sp.FontSizeAttribution(fontSize.toDouble())},
      ),
    ]);
    onDocumentModified?.call();
  }

  void toggleBold() {
    _toggleAttribution(sp.boldAttribution);
  }

  void toggleItalic() {
    _toggleAttribution(sp.italicsAttribution);
  }

  void toggleUnderline() {
    _toggleAttribution(sp.underlineAttribution);
  }

  void toggleStrikethrough() {
    _toggleAttribution(sp.strikethroughAttribution);
  }

  void toggleSuperscript() {
    _toggleAttribution(sp.superscriptAttribution);
  }

  void toggleSubscript() {
    _toggleAttribution(sp.subscriptAttribution);
  }
}
