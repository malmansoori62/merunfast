import '../core/constants.dart';
import '../core/enums.dart';
import '../models/items/base_item.dart';
import '../models/items/equipment.dart';
import '../models/items/consumable.dart';

class InventoryManager {
  final List<BaseItem> _items = [];

  List<BaseItem> get items => List.unmodifiable(_items);

  List<Equipment> get equipment =>
      _items.whereType<Equipment>().toList();

  List<Consumable> get consumables =>
      _items.whereType<Consumable>().toList();

  bool get isFull => _items.length >= GameConstants.maxInventorySize;
  int get count => _items.length;

  // ── Adding items ──────────────────────────────────────────────────────────

  bool addItem(BaseItem item) {
    if (item.isStackable) {
      final existing = _items.whereType<Consumable>().cast<BaseItem?>().firstWhere(
            (e) => e!.id == item.id,
            orElse: () => null,
          );
      if (existing != null) {
        final cons = existing as Consumable;
        if (cons.quantity < cons.maxStack) {
          cons.quantity++;
          return true;
        }
      }
    }
    if (isFull) return false;
    _items.add(item);
    return true;
  }

  bool addItems(List<BaseItem> items) {
    bool allAdded = true;
    for (final item in items) {
      if (!addItem(item)) allAdded = false;
    }
    return allAdded;
  }

  // ── Removing items ────────────────────────────────────────────────────────

  bool removeItem(String itemId) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return false;
    final item = _items[idx];
    if (item is Consumable && item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeAt(idx);
    }
    return true;
  }

  bool removeItemByRef(BaseItem item) {
    if (item is Consumable && item.quantity > 1) {
      item.quantity--;
      return true;
    }
    return _items.remove(item);
  }

  // ── Sorting & filtering ───────────────────────────────────────────────────

  List<BaseItem> sortByRarity({bool descending = true}) {
    final sorted = [..._items];
    sorted.sort((a, b) => descending
        ? b.rarity.index.compareTo(a.rarity.index)
        : a.rarity.index.compareTo(b.rarity.index));
    return sorted;
  }

  List<BaseItem> filterByType(ItemType type) =>
      _items.where((i) => i.type == type).toList();

  List<Equipment> filterBySlot(EquipmentSlot slot) =>
      _items.whereType<Equipment>().where((e) => e.slot == slot).toList();

  // ── Economy ───────────────────────────────────────────────────────────────

  int getTotalValue() =>
      _items.fold(0, (sum, item) => sum + item.sellPrice * item.quantity);

  BaseItem? findById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  bool hasItem(String id) => _items.any((i) => i.id == id);

  int countById(String id) {
    final item = findById(id);
    if (item == null) return 0;
    return item.quantity;
  }

  void clear() => _items.clear();

  void loadItems(List<dynamic> savedItems) {
    _items.clear();
    for (final item in savedItems) {
      if (item != null) _items.add(item as BaseItem);
    }
  }
}
