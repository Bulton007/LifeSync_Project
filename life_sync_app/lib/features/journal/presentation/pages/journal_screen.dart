import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';

final class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

final class _JournalScreenState extends State<JournalScreen> {
  late final JournalController _controller;
  final _searchController = TextEditingController();
  bool _searching = false;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<JournalController>();
    _searchController.addListener(
      () => _controller.searchQuery.value = _searchController.text,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) _controller.selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _controller.load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _RoundButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: Get.back<void>,
                          ),
                          const Spacer(),
                          Obx(() {
                            final date = _controller.selectedDate.value;
                            return Column(
                              children: [
                                Text(
                                  '${date.year}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _months[date.month - 1],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            );
                          }),
                          const Spacer(),
                          _RoundButton(
                            icon: _searching ? Icons.close : Icons.search,
                            outlined: true,
                            onTap: () => setState(() {
                              _searching = !_searching;
                              if (!_searching) _searchController.clear();
                            }),
                          ),
                          const SizedBox(width: 8),
                          _RoundButton(
                            icon: Icons.calendar_month_outlined,
                            outlined: true,
                            onTap: _pickDate,
                          ),
                        ],
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: _searching
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  textInputAction: TextInputAction.search,
                                  decoration: const InputDecoration(
                                    hintText: 'Search title, notes, or tags',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => _WeekStrip(
                          selected: _controller.selectedDate.value,
                          onSelected: _controller.selectDate,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Journal',
                          style: TextStyle(
                            color: colors.primaryBlue,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (_controller.isLoading.value &&
                    _controller.entries.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final error = _controller.errorMessage.value;
                if (error != null && _controller.entries.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(error, textAlign: TextAlign.center),
                            TextButton(
                              onPressed: _controller.load,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final entries = _controller.visibleEntries;
                if (entries.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _JournalEmpty(
                      searching: _searchController.text.isNotEmpty,
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 104),
                  sliver: SliverList.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 18),
                    itemBuilder: (context, index) => _TimelineEntry(
                      entry: entries[index],
                      onTap: () => Get.toNamed<void>(
                        AppRoutes.journalEditor,
                        arguments: entries[index],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Write journal entry',
        onPressed: () => Get.toNamed<void>(AppRoutes.journalEditor),
        child: SvgPicture.asset(
          LifeSyncSvgAssets.taskEdit,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}

final class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.selected, required this.onSelected});

  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final monday = selected.subtract(Duration(days: selected.weekday - 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final date = monday.add(Duration(days: index));
        final active =
            date.year == selected.year &&
            date.month == selected.month &&
            date.day == selected.day;
        return InkWell(
          onTap: () => onSelected(date),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 38,
            child: Column(
              children: [
                Text(
                  _JournalScreenState._weekdays[index],
                  style: TextStyle(
                    color: active ? colors.primaryBlue : colors.secondaryText,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? colors.primaryBlue : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: active ? Colors.white : colors.primaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

final class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.entry, required this.onTap});

  final JournalEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final hour = entry.createdAt.hour % 12 == 0
        ? 12
        : entry.createdAt.hour % 12;
    final minute = entry.createdAt.minute.toString().padLeft(2, '0');
    final suffix = entry.createdAt.hour >= 12 ? 'PM' : 'AM';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
              Container(width: 1, height: 118, color: colors.border),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$hour:$minute $suffix',
                  style: TextStyle(color: colors.primaryBlue, fontSize: 10),
                ),
                const SizedBox(height: 6),
                Text(entry.title, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                Text(
                  entry.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                if (entry.attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: entry.attachments.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.memory(
                          base64Decode(entry.attachments[index]),
                          width: 60,
                          height: 46,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _JournalEmpty extends StatelessWidget {
  const _JournalEmpty({required this.searching});
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: .92, end: 1),
            duration: const Duration(milliseconds: 300),
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: searching
                ? Icon(
                    Icons.search_off_rounded,
                    size: 92,
                    color: colors.secondaryText,
                  )
                : SvgPicture.asset(
                    LifeSyncSvgAssets.taskEdit,
                    width: 72,
                    height: 72,
                    colorFilter: ColorFilter.mode(
                      colors.primaryBlue.withValues(alpha: 0.6),
                      BlendMode.srcIn,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            searching
                ? 'No matching memories'
                : 'What’s worth remembering today?',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

final class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.outlined = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Material(
      color: outlined ? Colors.transparent : colors.navigationSelected,
      shape: CircleBorder(
        side: outlined ? BorderSide(color: colors.border) : BorderSide.none,
      ),
      child: IconButton(onPressed: onTap, icon: Icon(icon, size: 21)),
    );
  }
}
