import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/desktop_layout_provider.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import 'package:pulse/core/utils/error_mapper.dart';

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key});

  @override
  ConsumerState<CommunicationScreen> createState() =>
      _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  late final Stream<QuerySnapshot> _adminStream;
  late final Stream<QuerySnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _adminStream = FirebaseFirestore.instance
        .collection('support_channels')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();

    final userId = ref.read(authProvider).user?.uid ?? '';
    _userStream = FirebaseFirestore.instance
        .collection('support_messages')
        .where(
          Filter.or(
            Filter('userId', isEqualTo: userId),
            Filter('isAnnouncement', isEqualTo: true),
          ),
        )
        .orderBy('timestamp', descending: false)
        .snapshots();

    Future.microtask(_cleanUpOldMessages);
  }

  Future<void> _cleanUpOldMessages() async {
    final user = ref.read(authProvider).user;
    if (user == null || user.email != 'ashutoshpathakab@gmail.com') return;

    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      final oldMessages = await FirebaseFirestore.instance
          .collection('support_messages')
          .where('timestamp', isLessThan: Timestamp.fromDate(thirtyDaysAgo))
          .get();

      if (oldMessages.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();
      int count = 0;

      for (var msg in oldMessages.docs) {
        batch.delete(msg.reference);
        count++;
        if (count == 490) {
          await batch.commit();
          count = 0;
        }
      }

      if (count > 0) {
        await batch.commit();
      }
      debugPrint('[Cleanup] Deleted ${oldMessages.docs.length} old messages.');
    } catch (e) {
      debugPrint('[Cleanup] Failed to clean up old messages: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    final now =
        DateTime.now().millisecondsSinceEpoch +
        60000; // +1 min buffer for clock skew
    try {
      ref.read(unreadBadgeTimeProvider.notifier).state = now;
    } catch (_) {}
    
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('lastOpenedSupportTime', now);
    });

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

  // ── Regular User: Send Feedback ──
  Future<void> _sendFeedback(String text) async {
    if (text.trim().isEmpty) return;

    final auth = ref.read(authProvider);
    final user = auth.user;
    if (user == null) return;

    final messageText = text.trim();
    _messageController.clear();

    try {
      final batch = FirebaseFirestore.instance.batch();

      // 1. Add message
      final msgRef = FirebaseFirestore.instance
          .collection('support_messages')
          .doc();
      batch.set(msgRef, {
        'id': msgRef.id,
        'senderId': user.uid,
        'senderEmail': user.email ?? '',
        'senderName': auth.displayName ?? 'Pulse User',
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'isAnnouncement': false,
        'userId': user.uid,
      });

      // 2. Update channel metadata
      final channelRef = FirebaseFirestore.instance
          .collection('support_channels')
          .doc(user.uid);
      batch.set(channelRef, {
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'userName': auth.displayName ?? 'Pulse User',
        'userPhotoURL': auth.photoURL ?? '',
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadByAdmin': true,
        'unreadByUser': false,
      }, SetOptions(merge: true));

      await batch.commit();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ToastUtils.show(
          context,
          AppLocalizations.of(
            context,
          )!.commFailedToSend(ErrorMapper.getLocalizedError(context, e)),
        );
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
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
                  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) ...[
                    IconButton(
                      onPressed: () {
                        if (Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isMacOS) {
                          ref.read(desktopRightPaneProvider.notifier).state =
                              DesktopRightPane.shell;
                        } else {
                          context.pop();
                        }
                      },
                      icon: const Icon(LucideIcons.arrowLeft, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (auth.isAdmin)
                    Text(
                      AppLocalizations.of(context)!.commAdminDashboard,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/avatars/Admin.Avatar.jpeg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.commAdminSupport,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.commAlwaysHere,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: auth.isAdmin
                  ? _buildAdminBody(accent)
                  : _buildUserBody(auth.user?.uid ?? '', accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedWelcomeMessage(Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/avatars/Admin.Avatar.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.commWelcomeTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.commWelcomeSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.commWelcomeBody1,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                  '🎵',
                  AppLocalizations.of(context)!.commBullet1,
                ),
                _buildBulletPoint(
                  '🐞',
                  AppLocalizations.of(context)!.commBullet2,
                ),
                _buildBulletPoint(
                  '💡',
                  AppLocalizations.of(context)!.commBullet3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.commWelcomeBody2,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── USER INTERFACE (Unified Chat) ──
  Widget _buildUserBody(String userId, Color accent) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.commError(
                      ErrorMapper.getLocalizedError(context, snapshot.error),
                    ),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data?.docs ?? [];

              if (messages.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 48,
                          color: accent.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.commNoMessages,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.commNoMessagesDesc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottom(),
              );

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildPinnedWelcomeMessage(accent);
                  }

                  final msgIndex = index - 1;
                  final data =
                      messages[msgIndex].data() as Map<String, dynamic>;
                  final isMe = data['senderId'] == userId;
                  final text = data['text'] ?? '';
                  final time =
                      (data['timestamp'] as Timestamp?)?.toDate() ??
                      DateTime.now();
                  final isAnnouncement = data['isAnnouncement'] == true;

                  final senderName = isAnnouncement
                      ? 'Ashutosh pathak'
                      : (isMe ? 'You' : 'Ashutosh pathak');

                  Widget bubble = Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
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
                            : Border.all(
                                color: isAnnouncement
                                    ? accent.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.08),
                                width: 1,
                              ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isAnnouncement) ...[
                                  Icon(
                                    LucideIcons.megaphone,
                                    size: 10,
                                    color: accent,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  senderName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isAnnouncement
                                        ? accent
                                        : AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          if (!isMe) const SizedBox(height: 3),
                          Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1),
                                child: Text(
                                  DateFormatter.formatTime(time),
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : AppColors.textSecondary,
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
                  if (msgIndex == 0) {
                    showDivider = true;
                  } else {
                    final prevData =
                        messages[msgIndex - 1].data() as Map<String, dynamic>;
                    final prevTime =
                        (prevData['timestamp'] as Timestamp?)?.toDate() ??
                        DateTime.now();
                    if (prevTime.year != time.year ||
                        prevTime.month != time.month ||
                        prevTime.day != time.day) {
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                DateFormatter.formatChatListDate(time),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
        _buildInputBar(
          controller: _messageController,
          hint: AppLocalizations.of(context)!.commMessageSupportHint,
          onSend: _sendFeedback,
        ),
      ],
    );
  }

  // ── ADMIN INTERFACE (WhatsApp Style) ──
  Widget _buildAdminBody(Color accent) {
    return StreamBuilder<QuerySnapshot>(
      stream: _adminStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.commError(
                ErrorMapper.getLocalizedError(context, snapshot.error),
              ),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final channels = snapshot.data?.docs ?? [];

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: channels.length + 1,
          itemBuilder: (context, index) {
            // First item is always Global Broadcast
            if (index == 0) {
              return ListTile(
                onTap: () {
                  if (Platform.isWindows ||
                      Platform.isLinux ||
                      Platform.isMacOS) {
                    ref.read(desktopRightPaneProvider.notifier).state =
                        DesktopRightPane.broadcastChat;
                  } else {
                    context.push('/communication/broadcast');
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: accent.withValues(alpha: 0.2),
                  foregroundColor: accent,
                  child: const Icon(LucideIcons.megaphone, size: 24),
                ),
                title: Text(
                  AppLocalizations.of(context)!.commGlobalAnnouncements,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.commSendMessagesToAll,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              );
            }

            final data = channels[index - 1].data() as Map<String, dynamic>;
            final uid = (data['userId'] as String?) ?? '';
            final email = (data['userEmail'] as String?) ?? 'No Email';
            final name = (data['userName'] as String?) ?? 'Unknown User';
            final lastMsg = (data['lastMessage'] as String?) ?? '';
            final time =
                (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                DateTime.now();
            final unread = data['unreadByAdmin'] == true;

            String photoUrl = (data['userPhotoURL'] as String?) ?? '';
            if (photoUrl.isEmpty) photoUrl = 'assets/avatars/4.jpeg';

            final initials = name
                .split(' ')
                .where((String w) => w.isNotEmpty)
                .map((String w) => w[0])
                .take(2)
                .join()
                .toUpperCase();

            Widget leadingAvatar;
            if (photoUrl.isNotEmpty && photoUrl.startsWith('assets/')) {
              leadingAvatar = Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              leadingAvatar = Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            return ListTile(
              onTap: () {
                if (Platform.isWindows ||
                    Platform.isLinux ||
                    Platform.isMacOS) {
                  ref.read(desktopChatUserIdProvider.notifier).state = uid;
                  ref.read(desktopChatUserNameProvider.notifier).state = name;
                  ref.read(desktopChatUserEmailProvider.notifier).state = email;
                  ref.read(desktopChatUserPhotoProvider.notifier).state =
                      photoUrl;
                  ref.read(desktopRightPaneProvider.notifier).state =
                      DesktopRightPane.adminChat;
                } else {
                  context.push(
                    '/communication/chat/$uid?name=${Uri.encodeComponent(name)}&email=${Uri.encodeComponent(email)}&photo=${Uri.encodeComponent(photoUrl)}',
                  );
                }
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: leadingAvatar,
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormatter.formatChatListDate(time),
                    style: TextStyle(
                      color: unread ? accent : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: unread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lastMsg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: unread
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: unread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Universal Input Bar Widget ──
  Widget _buildInputBar({
    required TextEditingController controller,
    required String hint,
    required Function(String) onSend,
  }) {
    final accent = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: accent,
            radius: 20,
            child: IconButton(
              icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
              onPressed: () => onSend(controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
