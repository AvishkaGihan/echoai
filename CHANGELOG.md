# Changelog

All notable changes to EchoAI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-11

### 🎉 Initial Release

#### Added

**Authentication**

- Email/password authentication with validation
- Google Sign-In integration
- Password reset flow
- Session persistence across app restarts
- Automatic logout on token expiration

**Chat Features**

- Real-time streaming AI responses with Gemini 2.5 Flash
- Text input with auto-growing text field
- Voice input with speech-to-text transcription
- Automatic silence detection (2-second threshold)
- Message reactions (👍👎❤️🔥🎉)
- Copy message to clipboard
- Text-to-speech for AI responses
- Typing indicators during AI response generation
- Message timestamps

**Assistant Modes**

- Productivity Mode (task-focused, action-oriented)
- Learning Mode (educational, patient explanations)
- Casual Mode (friendly, conversational)
- Seamless mode switching mid-conversation

**Chat History**

- SQLite local storage for all conversations
- Search conversations by content
- View conversation previews
- Delete individual conversations
- Delete all conversations with confirmation
- Auto-generated conversation titles
- Sort by date (most recent first)

**Settings & Customization**

- Four accent color options (Purple, Pink, Cyan, Lime)
- Dark mode native design
- Text-to-speech toggle
- Adjustable voice speed (0.5x - 2.0x)
- Notification preferences
- Assistant mode selection

**Technical Features**

- MVVM architecture with Provider state management
- Result type for uniform error handling
- Rate limiting (15 requests/minute)
- Offline-first data persistence
- Comprehensive error messages
- Loading states throughout the app
- 60 FPS animations
- Material Design 3 components

#### Performance

- Average AI response latency: <2 seconds
- Chat history load time: <1 second for 100+ messages
- Voice transcription latency: <500ms
- App startup time: <3 seconds (cold start)
- Smooth 60 FPS scrolling and animations

#### Accessibility

- WCAG 2.1 Level AA compliant color contrast
- 48pt minimum touch targets
- Screen reader support
- Keyboard navigation
- Focus indicators on all interactive elements

#### Platform Support

- iOS 14.0+
- Android 5.0+ (API 21+)
- Responsive design for phones and tablets
- Portrait and landscape orientations

### Developer Experience

- Complete documentation (PRD, Architecture, UX Design)
- Comprehensive code comments
- Test structure in place
- CI/CD ready (GitHub Actions template included)
- Clean project structure following Flutter best practices

---

## [Unreleased]

### Planned for 1.1.0

- Cloud sync for conversations
- Export conversations to PDF
- Multi-language UI support
- Light theme option
- Advanced search filters (by date, mode, sentiment)

### Planned for 2.0.0

- Image generation with Gemini
- Conversation sharing via deep links
- Conversation folders/organization
- Desktop versions (Windows, macOS, Linux)
- Web version
- Plugin system

---

## Version History

- **1.0.0** (2025-11-11) - Initial production release
- **0.1.0** (2025-11-01) - Alpha release for testing

---

## Migration Guides

### Migrating from 0.x to 1.0

If you were using the alpha version (0.x), please note:

1. **Database Schema Changes**

   - Backup your conversations before updating
   - First launch will migrate data automatically

2. **API Changes**

   - `google_generative_ai` replaced with `firebase_vertexai`
   - Update Firebase configuration with new credentials

3. **Breaking Changes**
   - None for end users
   - Developers: Check `CONTRIBUTING.md` for new code standards

---

## Support

For issues, questions, or feedback:

- GitHub Issues: https://github.com/AvishkaGihan/echoai/issues
- Discussions: https://github.com/AvishkaGihan/echoai/discussions
- Email: support@echoai.com

---

**Legend:**

- 🎉 Major release
- ✨ New feature
- 🐛 Bug fix
- 🔧 Technical improvement
- 📚 Documentation
- 🎨 UI/UX enhancement
- ⚡ Performance improvement
- 🔒 Security fix
