part of "../../recollect_utils.dart";

class xtxDocument {
  late final Format format;
  final BuildContext context;
  final xtxFile file;
  late final sp.MutableDocument document;
  late final sp.MutableDocumentComposer composer;
  late final sp.Editor editor;

  xtxDocument({required this.context, required this.file}) {
    final nodes = <sp.DocumentNode>[];

    if (file.nodes.isEmpty) {
      nodes.add(
        sp.ParagraphNode(
          id: Moment.now().millisecondsSinceEpoch.toString(),
          text: sp.AttributedText(),
        ),
      );
    } else {
      for (final xtxNode in file.nodes) {
        if (xtxNode.nodeType == NodeType.text) {
          final text = utf8.decode(xtxNode.content);
          final attributedText = sp.AttributedText(text);

          if (xtxNode.metadata.containsKey(MetadataKeys.bold)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.bold]!,
              sp.boldAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.italic)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.italic]!,
              sp.italicsAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.underline)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.underline]!,
              sp.underlineAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.strikethrough)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.strikethrough]!,
              sp.strikethroughAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.superscript)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.superscript]!,
              sp.superscriptAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.subscript)) {
            applyFormattingFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.subscript]!,
              sp.subscriptAttribution,
            );
          }
          if (xtxNode.metadata.containsKey(MetadataKeys.fontSize)) {
            applyFontSizeFromMetadata(
              attributedText,
              xtxNode.metadata[MetadataKeys.fontSize]!,
            );
          }

          sp.Attribution blockType = sp.paragraphAttribution;
          if (xtxNode.metadata.containsKey(MetadataKeys.blockType)) {
            final blockTypeStr = xtxNode.metadata[MetadataKeys.blockType]!;
            blockType = parseBlockType(blockTypeStr);
          }

          nodes.add(
            sp.ParagraphNode(
              id: xtxNode.id.toString(),
              text: attributedText,
              metadata: {'blockType': blockType},
            ),
          );
        }
      }
    }

    if (nodes.isEmpty) {
      nodes.add(
        sp.ParagraphNode(
          id: Moment.now().millisecondsSinceEpoch.toString(),
          text: sp.AttributedText(),
        ),
      );
    }

    document = sp.MutableDocument(nodes: nodes);
    composer = sp.MutableDocumentComposer();
    editor = sp.createDefaultDocumentEditor(
      document: document,
      composer: composer,
    );
    format = Format(
      context: context,
      editor: editor,
      composer: composer,
      document: document,
    );
  }

  void applyFormattingFromMetadata(
    sp.AttributedText text,
    String ranges,
    sp.Attribution attribution,
  ) {
    final rangeParts = ranges.split(',');
    for (final rangePart in rangeParts) {
      final parts = rangePart.split('-');
      if (parts.length == 2) {
        final start = int.tryParse(parts[0].trim());
        final end = int.tryParse(parts[1].trim());
        if (start != null && end != null && start <= end && end < text.length) {
          text.addAttribution(attribution, sp.SpanRange(start, end));
        }
      }
    }
  }

  /// Parses fontSize metadata in the format "30.0:0-5;12.0:10-15"
  /// Each entry is "size:start-end", separated by semicolons.
  void applyFontSizeFromMetadata(sp.AttributedText text, String value) {
    final entries = value.split(';');
    for (final entry in entries) {
      final colonIndex = entry.indexOf(':');
      if (colonIndex < 0) continue;
      final sizeStr = entry.substring(0, colonIndex).trim();
      final rangesStr = entry.substring(colonIndex + 1).trim();
      final size = double.tryParse(sizeStr);
      if (size == null) continue;
      final rangeParts = rangesStr.split(',');
      for (final rangePart in rangeParts) {
        final parts = rangePart.split('-');
        if (parts.length == 2) {
          final start = int.tryParse(parts[0].trim());
          final end = int.tryParse(parts[1].trim());
          if (start != null &&
              end != null &&
              start <= end &&
              end < text.length) {
            text.addAttribution(
              sp.FontSizeAttribution(size),
              sp.SpanRange(start, end),
            );
          }
        }
      }
    }
  }

  sp.Attribution parseBlockType(String blockTypeStr) {
    switch (blockTypeStr) {
      case MetadataKeys.header1:
        return sp.header1Attribution;
      case MetadataKeys.header2:
        return sp.header2Attribution;
      case MetadataKeys.header3:
        return sp.header3Attribution;
      case MetadataKeys.header4:
        return sp.header4Attribution;
      case MetadataKeys.header5:
        return sp.header5Attribution;
      case MetadataKeys.header6:
        return sp.header6Attribution;
      case MetadataKeys.paragraph:
      default:
        return sp.paragraphAttribution;
    }
  }

  List<_Range> findAttributionRanges(
    sp.AttributedText text,
    sp.Attribution attribution,
  ) {
    final ranges = <_Range>[];
    int? rangeStart;

    for (int i = 0; i <= text.length; i++) {
      final hasAttribution =
          i < text.length &&
          text.spans.hasAttributionAt(i, attribution: attribution);

      if (hasAttribution && rangeStart == null) {
        rangeStart = i;
      } else if (!hasAttribution && rangeStart != null) {
        ranges.add(_Range(start: rangeStart, end: i));
        rangeStart = null;
      }
    }

    if (rangeStart != null) {
      ranges.add(_Range(start: rangeStart, end: text.length));
    }

    return ranges;
  }

  /// Extracts FontSizeAttribution spans and groups them by size.
  Map<double, List<_Range>> findFontSizeRanges(sp.AttributedText text) {
    final result = <double, List<_Range>>{};
    final spans = text.getAttributionSpansByFilter(
      (attr) => attr is sp.FontSizeAttribution,
    );
    for (final span in spans) {
      final fontSize = (span.attribution as sp.FontSizeAttribution).fontSize;
      result
          .putIfAbsent(fontSize, () => [])
          .add(_Range(start: span.start, end: span.end + 1));
    }
    return result;
  }

  String? extractBlockType(sp.ParagraphNode node) {
    final nodeMetadata = node.metadata;
    if (nodeMetadata.containsKey(MetadataKeys.blockType)) {
      final attribution = nodeMetadata[MetadataKeys.blockType];

      if (attribution == sp.header1Attribution) {
        return MetadataKeys.header1;
      } else if (attribution == sp.header2Attribution) {
        return MetadataKeys.header2;
      } else if (attribution == sp.header3Attribution) {
        return MetadataKeys.header3;
      } else if (attribution == sp.header4Attribution) {
        return MetadataKeys.header4;
      } else if (attribution == sp.header5Attribution) {
        return MetadataKeys.header5;
      } else if (attribution == sp.header6Attribution) {
        return MetadataKeys.header6;
      } else if (attribution == sp.paragraphAttribution) {
        return MetadataKeys.paragraph;
      }
    }

    return MetadataKeys.paragraph;
  }

  Future<void> save() async {
    final nodes = <Node>[];
    int nodeId = 1;

    for (int i = 0; i < document.nodeCount; i++) {
      final docNode = document.getNodeAt(i);
      if (docNode is sp.ParagraphNode) {
        final text = docNode.text.toPlainText();
        final content = Uint8List.fromList(utf8.encode(text));

        final metadata = <String, String>{};

        final boldRanges = findAttributionRanges(
          docNode.text,
          sp.boldAttribution,
        );
        if (boldRanges.isNotEmpty) {
          metadata[MetadataKeys.bold] = boldRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final italicRanges = findAttributionRanges(
          docNode.text,
          sp.italicsAttribution,
        );
        if (italicRanges.isNotEmpty) {
          metadata[MetadataKeys.italic] = italicRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final underlineRanges = findAttributionRanges(
          docNode.text,
          sp.underlineAttribution,
        );
        if (underlineRanges.isNotEmpty) {
          metadata[MetadataKeys.underline] = underlineRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final strikethroughRanges = findAttributionRanges(
          docNode.text,
          sp.strikethroughAttribution,
        );
        if (strikethroughRanges.isNotEmpty) {
          metadata[MetadataKeys.strikethrough] = strikethroughRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final superscriptRanges = findAttributionRanges(
          docNode.text,
          sp.superscriptAttribution,
        );
        if (superscriptRanges.isNotEmpty) {
          metadata[MetadataKeys.superscript] = superscriptRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final subscriptRanges = findAttributionRanges(
          docNode.text,
          sp.subscriptAttribution,
        );
        if (subscriptRanges.isNotEmpty) {
          metadata[MetadataKeys.subscript] = subscriptRanges
              .map((r) => '${r.start}-${r.end - 1}')
              .join(',');
        }

        final fontSizeRanges = findFontSizeRanges(docNode.text);
        if (fontSizeRanges.isNotEmpty) {
          metadata[MetadataKeys.fontSize] = fontSizeRanges.entries
              .map(
                (entry) =>
                    '${entry.key}:${entry.value.map((r) => '${r.start}-${r.end - 1}').join(',')}',
              )
              .join(';');
        }

        final blockType = extractBlockType(docNode);
        if (blockType != null) {
          metadata[MetadataKeys.blockType] = blockType;
        }

        var node = Node.create(NodeType.text, nodeId++);
        node = node.nodeSetContent(content: content);
        for (final entry in metadata.entries) {
          node = node.nodeAddMetadata(key: entry.key, value: entry.value);
        }
        nodes.add(node);
      }
    }

    final now = Moment.now().dateTime.millisecondsSinceEpoch ~/ 1000;
    final updatedHeader = file.header.copyWith(modified: now);
    var updatedFile = file.copyWith(header: updatedHeader, nodes: nodes);

    await updatedFile.write();
  }
}

class _Range {
  final int start;
  final int end;

  _Range({required this.start, required this.end});
}
