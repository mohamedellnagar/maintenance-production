import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/chat_message.dart';
import '../../../providers/providers.dart';

/// شاشة المساعد الذكي (Rule-Based) — أوامر بلغة طبيعية بسيطة.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  bool _busy = false;

  static const _suggestions = [
    'كم ثروتي؟',
    'هل وضعي المالي جيد؟',
    'راتبي أصبح 22000',
    'اشتريت سيارة بـ 80000 كاش',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final msgs = await ref.read(chatRepoProvider).all();
    setState(() => _messages = msgs);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty || _busy) return;
    _input.clear();
    setState(() => _busy = true);

    final chatRepo = ref.read(chatRepoProvider);
    final userMsg = ChatMessage(role: 'user', text: text);
    await chatRepo.add(userMsg);
    setState(() => _messages = [..._messages, userMsg]);
    _scrollToBottom();

    final result = await ref.read(chatCommandServiceProvider).handle(text);
    final botMsg = ChatMessage(
      role: 'assistant',
      text: result.reply,
      intent: result.intent,
      actionApplied: result.applied,
    );
    await chatRepo.add(botMsg);
    if (result.applied) bumpRefreshFromWidget(ref);

    setState(() {
      _messages = [..._messages, botMsg];
      _busy = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(S.chat),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'مسح المحادثة',
            onPressed: () async {
              await ref.read(chatRepoProvider).clear();
              setState(() => _messages = []);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _intro()
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _Bubble(message: _messages[i]),
                  ),
          ),
          if (_busy) const LinearProgressIndicator(minHeight: 2),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _intro() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.smart_toy_outlined,
              size: 72, color: AppColors.primary.withValues(alpha: 0.8)),
          const SizedBox(height: 16),
          const Text('اكتب أمرًا ماليًا بلغتك',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('يعمل دون إنترنت — يحلّل جملتك ويحدّث بياناتك.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final s in _suggestions)
                ActionChip(label: Text(s), onPressed: () => _send(s)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'اكتب أمرًا... مثل: دفعت 5000 من القسط',
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _send(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isUser ? null : Border.all(color: const Color(0xFFE3E8EA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimary),
            ),
            if (message.actionApplied) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      size: 14,
                      color: isUser ? Colors.white70 : AppColors.positive),
                  const SizedBox(width: 4),
                  Text('تم التطبيق',
                      style: TextStyle(
                          fontSize: 11,
                          color:
                              isUser ? Colors.white70 : AppColors.positive)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
