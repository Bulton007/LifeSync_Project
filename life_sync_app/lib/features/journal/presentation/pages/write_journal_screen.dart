import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WriteJournalScreen extends StatefulWidget {
  const WriteJournalScreen({super.key});

  @override
  State<WriteJournalScreen> createState() => _WriteJournalScreenState();
}

class _WriteJournalScreenState extends State<WriteJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar with Back Button and Done Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.black87,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          icon: const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date & Tags Meta Bar
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Wednesday | Jan 04, 2025',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.unfold_more,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.label_outline,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add Tag',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Timestamp Label
                    Text(
                      '6:54 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title Header Label
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Journal Card Container with Inputs & Formatting Toolbar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content Body Input Area
                          TextField(
                            controller: _contentController,
                            maxLines: 6,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Write your story here',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.mic_none,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Color(0xFFF0F2F5)),
                          const SizedBox(height: 12),

                          // Text Formatting Toolbar
                          Row(
                            children: [
                              Icon(
                                Icons.format_list_bulleted,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.format_list_numbered,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'B',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Persistent Simulated Software Keyboard Bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Suggestions bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          '"The"',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          'the',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          'to',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Keyboard Rows
                  _buildKeyboardRow([
                    'q',
                    'w',
                    'e',
                    'r',
                    't',
                    'y',
                    'u',
                    'i',
                    'o',
                    'p',
                  ]),
                  const SizedBox(height: 6),
                  _buildKeyboardRow([
                    'a',
                    's',
                    'd',
                    'f',
                    'g',
                    'h',
                    'j',
                    'k',
                    'l',
                  ]),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildKeyButton(
                        child: const Icon(Icons.arrow_upward, size: 16),
                        flex: 1,
                      ),
                      ...[
                        'z',
                        'x',
                        'c',
                        'v',
                        'b',
                        'n',
                        'm',
                      ].map((e) => _buildKeyButton(text: e)),
                      _buildKeyButton(
                        child: const Icon(Icons.backspace_outlined, size: 16),
                        flex: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildKeyButton(text: 'ABC', flex: 1),
                      _buildKeyButton(text: 'space', flex: 3),
                      _buildKeyButton(text: 'Done', isBlue: true, flex: 1),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20,
                          color: Colors.black87,
                        ),
                        Icon(Icons.mic_none, size: 20, color: Colors.black87),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) => _buildKeyButton(text: letter)).toList(),
    );
  }

  Widget _buildKeyButton({
    String? text,
    Widget? child,
    bool isBlue = false,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 38,
        decoration: BoxDecoration(
          color: isBlue ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child:
            child ??
            Text(
              text ?? '',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isBlue ? Colors.white : Colors.black87,
              ),
            ),
      ),
    );
  }
}
