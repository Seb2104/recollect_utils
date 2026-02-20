/// A collection of dropdown menu and suggestion widgets with keyboard navigation.
///
/// The menus module provides three powerful menu widgets for different use cases:
///
/// ## Available Widgets
///
/// ### [FilteredMenu]
/// A searchable dropdown menu with live filtering. Users can type to search through
/// options, with automatic highlighting of matching items. Perfect for large lists
/// where users need to quickly find specific options.
///
/// **Use when:**
/// - You have many options (20+ items)
/// - Users need to search for specific items
/// - Quick filtering improves user experience
///
/// **Example:**
/// ```dart
/// FilteredMenu<String>(
///   items: [
///     MenuItem(label: 'Apple', value: 'apple'),
///     MenuItem(label: 'Banana', value: 'banana'),
///     MenuItem(label: 'Cherry', value: 'cherry'),
///   ],
///   setStateCallback: () => setState(() {}),
///   label: 'Select Fruit',
///   onSelected: (value) => print(value),
/// )
/// ```
///
/// ### [SimpleMenu]
/// A lightweight dropdown menu without search functionality. Clean and simple,
/// ideal for shorter lists where users can easily scan all options.
///
/// **Use when:**
/// - You have a small list (< 20 items)
/// - Users can easily scan the entire list
/// - You don't need search/filter functionality
/// - You want a minimal dropdown interface
///
/// **Example:**
/// ```dart
/// SimpleMenu<String>(
///   items: [
///     MenuItem(label: 'Small', value: 's'),
///     MenuItem(label: 'Medium', value: 'm'),
///     MenuItem(label: 'Large', value: 'l'),
///   ],
///   setStateCallback: () => setState(() {}),
///   onSelected: (value) => print(value),
/// )
/// ```
///
/// ### [SuggestionField]
/// A text input field with an attached dropdown menu. Users can either type
/// custom input or select from predefined suggestions.
///
/// **Use when:**
/// - You want to allow both custom input and predefined options
/// - Common values should be easily selectable
/// - Users might need to enter variations of standard options
/// - Example use cases: units (px, em, %), tags, categories
///
/// **Example:**
/// ```dart
/// SuggestionField(
///   items: ['px', 'em', 'rem', '%'],
///   height: 30,
///   width: 120,
///   onSelected: (unit) => print(unit),
/// )
/// ```
///
/// ## Common Features
///
/// All menu widgets support:
/// - **Keyboard Navigation**: Arrow keys to navigate, Enter to select, Escape to close
/// - **Visual Feedback**: Highlighted selection and keyboard focus states
/// - **Customizable Sizing**: Adjustable height and width
/// - **Generic Types**: Type-safe value handling with `<T>`
///
/// ## Architecture
///
/// ```
/// menus/
/// ├── menus.dart              ← This library file
/// ├── src/
/// │   ├── filtered_menu.dart  ← Searchable dropdown with text field
/// │   ├── simple_menu.dart    ← Basic dropdown without search
/// │   ├── suggestion_field.dart ← Text field + dropdown combo
/// │   └── common/
/// │       ├── menu_item.dart  ← Data structure for menu items
/// │       └── menu_dropdown.dart ← Internal dropdown component
/// ```
///
/// ## Choosing the Right Menu
///
/// | Need | Use |
/// |------|-----|
/// | Large list, need search | [FilteredMenu] |
/// | Small list, simple dropdown | [SimpleMenu] |
/// | Custom input + suggestions | [SuggestionField] |
/// | Pure text input, no suggestions | Use Flutter's TextField |
///
/// ## See Also
///
/// - [MenuItem] - Data structure representing individual menu items
/// - [AlignType] - Enum for dropdown alignment options
library menus;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recollect_utils/recollect_utils.dart';

part 'src/common/menu_dropdown.dart';
part 'src/common/menu_item.dart';
part 'src/filtered_menu.dart';
part 'src/simple_menu.dart';
part 'src/suggestion_field.dart';
