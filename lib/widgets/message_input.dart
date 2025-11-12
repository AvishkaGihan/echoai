import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/extensions.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onVoicePressed;
  final bool isRecording;
  final bool isStreaming;
  final double? volumeLevel;

  const MessageInput({
    super.key,
    required this.onSendMessage,
    this.onVoicePressed,
    this.isRecording = false,
    this.isStreaming = false,
    this.volumeLevel,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.spaceMd,
        right: AppConstants.spaceMd,
        top: AppConstants.spaceSm,
        bottom: context.safeArea.bottom + AppConstants.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppConstants.neutralSurface,
        border: Border(
          top: BorderSide(
            color: AppConstants.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: widget.isRecording ? _buildRecordingView() : _buildInputView(),
    );
  }

  Widget _buildInputView() {
    return Row(
      children: [
        // Voice button
        if (widget.onVoicePressed != null)
          Container(
            margin: const EdgeInsets.only(right: AppConstants.spaceSm),
            child: IconButton(
              onPressed: widget.isStreaming ? null : widget.onVoicePressed,
              icon: const Icon(Icons.mic_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppConstants.accentCyan.withValues(alpha: 0.1),
                foregroundColor: AppConstants.accentCyan,
              ),
            ),
          ),

        // Text input field
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: !widget.isStreaming,
            maxLines: 4,
            minLines: 1,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _handleSend(),
            decoration: InputDecoration(
              hintText:
                  widget.isStreaming
                      ? 'AI is responding...'
                      : AppConstants.emptyMessagesHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: BorderSide(
                  color: AppConstants.borderColor.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: BorderSide(
                  color: AppConstants.borderColor.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: const BorderSide(
                  color: AppConstants.accentCyan,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppConstants.neutralBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMd,
                vertical: AppConstants.spaceSm,
              ),
            ),
          ),
        ),

        // Send button
        Container(
          margin: const EdgeInsets.only(left: AppConstants.spaceSm),
          child: IconButton(
            onPressed: (_hasText && !widget.isStreaming) ? _handleSend : null,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor:
                  (_hasText && !widget.isStreaming)
                      ? AppConstants.primaryPurple
                      : AppConstants.neutralSurface,
              foregroundColor:
                  (_hasText && !widget.isStreaming)
                      ? AppConstants.neutralBackground
                      : AppConstants.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingView() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      decoration: BoxDecoration(
        color: AppConstants.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: AppConstants.accentCyan.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Recording icon
          Container(
            padding: const EdgeInsets.all(AppConstants.spaceSm),
            decoration: const BoxDecoration(
              color: AppConstants.errorColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 20),
          ),

          const SizedBox(width: AppConstants.spaceMd),

          // Waveform visualization
          Expanded(child: _buildWaveform()),

          const SizedBox(width: AppConstants.spaceMd),

          // Stop button
          IconButton(
            onPressed: widget.onVoicePressed,
            icon: const Icon(Icons.stop),
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    final level = widget.volumeLevel ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(8, (index) {
        // Simulate waveform with varying heights based on volume
        final height = 4.0 + (level * 20.0 * (0.5 + (index % 3) * 0.3));

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 3,
          height: height,
          decoration: BoxDecoration(
            color: AppConstants.accentCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
