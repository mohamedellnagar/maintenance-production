/// رسالة في مساعد الأوامر الذكي (Rule-Based).
class ChatMessage {
  ChatMessage({
    this.id,
    required this.role, // 'user' | 'assistant'
    required this.text,
    this.intent,
    this.actionApplied = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String role;
  final String text;
  final String? intent; // النية المكتشفة (buy_asset, update_salary...)
  final bool actionApplied;
  final DateTime createdAt;

  bool get isUser => role == 'user';

  factory ChatMessage.fromMap(Map<String, dynamic> m) => ChatMessage(
        id: m['id'] as int?,
        role: m['role'] as String,
        text: m['text'] as String,
        intent: m['intent'] as String?,
        actionApplied: (m['action_applied'] as int? ?? 0) == 1,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'role': role,
        'text': text,
        'intent': intent,
        'action_applied': actionApplied ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };
}
