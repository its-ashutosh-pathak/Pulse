import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';

class AdminChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhotoUrl;

  const AdminChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl = '',
  });

  @override
  ConsumerState<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends ConsumerState<AdminChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  late final Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = FirebaseFirestore.instance
        .collection('support_messages')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('timestamp', descending: false)
        .snapshots();
    _markAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _markAsRead() async {
    try {
      await FirebaseFirestore.instance
          .collection('support_channels')
          .doc(widget.userId)
          .update({'unreadByAdmin': false});
    } catch (e) {
      debugPrint('[AdminChat] Failed to mark as read: $e');
    }
  }

  Future<void> _sendReply(String text) async {
    if (text.trim().isEmpty) return;
    setState(() => _isSending = true);

    final auth = ref.read(authProvider);
    final adminUser = auth.user;
    if (adminUser == null) return;

    final replyText = text.trim();
    _messageController.clear();

    try {
      final batch = FirebaseFirestore.instance.batch();

      // 1. Add message
      final msgRef = FirebaseFirestore.instance.collection('support_messages').doc();
      batch.set(msgRef, {
        'id': msgRef.id,
        'senderId': adminUser.uid,
        'senderEmail': adminUser.email ?? '',
        'senderName': 'Ashutosh pathak',
        'text': replyText,
        'timestamp': FieldValue.serverTimestamp(),
        'isAnnouncement': false,
        'userId': widget.userId,
      });

      // 2. Update channel
      final channelRef = FirebaseFirestore.instance.collection('support_channels').doc(widget.userId);
      batch.set(channelRef, {
        'lastMessage': replyText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadByAdmin': false,
        'unreadByUser': true,
      }, SetOptions(merge: true));

      await batch.commit();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reply: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(LucideIcons.arrowLeft, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  if (widget.userPhotoUrl.isNotEmpty && widget.userPhotoUrl.startsWith('assets/'))
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: AssetImage(widget.userPhotoUrl), fit: BoxFit.cover),
                      ),
                    )
                  else
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(image: AssetImage('assets/avatars/4.jpeg'), fit: BoxFit.cover),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName.isEmpty ? 'Support Chat' : widget.userName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.userEmail,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Message stream
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No conversation history.', style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                // Scroll to bottom after frame
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] != widget.userId; // Sent by admin/support
                    final text = data['text'] ?? '';
                    final time = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

                    Widget bubble = Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? accent : AppColors.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(isMe ? 14 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 14),
                          ),
                          border: isMe
                              ? null
                              : Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe ? 'Support (You)' : widget.userName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white70 : accent,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  text,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: Text(
                                    DateFormatter.formatTime(time),
                                    style: TextStyle(
                                      color: isMe ? Colors.white70 : AppColors.textSecondary,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                    bool showDivider = false;
                    if (index == 0) {
                      showDivider = true;
                    } else {
                      final prevData = messages[index - 1].data() as Map<String, dynamic>;
                      final prevTime = (prevData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                      if (prevTime.year != time.year || prevTime.month != time.month || prevTime.day != time.day) {
                        showDivider = true;
                      }
                    }

                    if (showDivider) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  DateFormatter.formatChatListDate(time),
                                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          bubble,
                        ],
                      );
                    }

                    return bubble;
                  },
                );
              },
            ),
          ),

          // Message Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type your reply...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: accent.withValues(alpha: 0.5), width: 1.5),
                      ),
                    ),
                    onSubmitted: (val) => _sendReply(val),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: accent,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
                    onPressed: () => _sendReply(_messageController.text),
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
}
