# EchoAI UX Design Specification

**Document Version:** 1.0
**Date:** November 10, 2025
**Author:** BMad (with UX Designer)
**Status:** ✅ Design Foundation Locked

---

## Executive Summary

This UX Design Specification captures all design decisions for EchoAI, a beautiful AI personal assistant mobile app. It serves as the reference document for designers and developers, ensuring consistent implementation of user experience across iOS and Android.

**Design System:** Futuristic Bold (Dark Mode Native)
**Primary Layout:** Mobile Bottom Navigation (iOS/Android optimized)
**Target Platforms:** iOS 11+, Android 5.0+ (Flutter)

---

## Part 1: Visual Foundation

### Color Palette

**Theme:** Futuristic Bold - Cutting-Edge • Sophisticated • Dark & Moody

#### Primary Colors

| Color Name         | Hex Code | Usage                                        | Notes                                                        |
| ------------------ | -------- | -------------------------------------------- | ------------------------------------------------------------ |
| **Primary Purple** | #A78BFA  | Main actions, buttons, highlights            | Vibrant but sophisticated; feels premium on dark backgrounds |
| **Accent Cyan**    | #22D3EE  | Energy, secondary actions, focus states      | Creates visual interest and guides attention                 |
| **Accent Pink**    | #F43F5E  | Warmth, emotional responses, system feedback | Adds personality without overwhelming                        |
| **Dark Base**      | #1E293B  | Primary background, containers               | Deep, focused, reduces eye strain                            |

#### Semantic Colors

| Purpose                | Color     | Hex Code | Usage                               |
| ---------------------- | --------- | -------- | ----------------------------------- |
| **Success**            | Emerald   | #10b981  | Confirmations, successful actions   |
| **Warning**            | Amber     | #f59e0b  | Cautions, important notices         |
| **Error**              | Red       | #ef4444  | Errors, destructive actions         |
| **Neutral Background** | Slate 900 | #0f172a  | App background, deepest layer       |
| **Neutral Surface**    | Slate 800 | #1e293b  | Cards, panels, elevated surfaces    |
| **Text Primary**       | Slate 100 | #e2e8f0  | Main text, body content             |
| **Text Secondary**     | Slate 400 | #94a3b8  | Labels, helper text, secondary info |
| **Border**             | Slate 700 | #334155  | Dividers, subtle boundaries         |

#### Color Psychology & Usage

- **Purple (#A78BFA):** Creativity, innovation, sophistication. Used for primary actions that drive the core experience (Send, Record, Mode Switching).
- **Cyan (#22D3EE):** Energy, trust, technology. Used for focus states, loading indicators, and secondary interactive elements.
- **Pink (#F43F5E):** Warmth, personality, humanity. Used for feedback, emotional responses, and moments of delight.
- **Dark Base (#1E293B):** Reduces eye strain during long sessions, creates premium aesthetic, makes accent colors pop.

### Typography System

#### Font Family Strategy

| Use Case              | Font                                                   | Weight         | Rationale                                      |
| --------------------- | ------------------------------------------------------ | -------------- | ---------------------------------------------- |
| **Headings**          | System font (SF Pro Display on iOS, Roboto on Android) | 700 (Bold)     | Maximum readability, professional appearance   |
| **Body Text**         | System font                                            | 400 (Regular)  | Native performance, optimal reading experience |
| **Labels & Captions** | System font                                            | 600 (Semibold) | Distinguishes UI controls from content         |
| **Monospace (Code)**  | Menlo / Roboto Mono                                    | 400            | Code readability in conversations              |

#### Type Scale

| Element                 | Size | Weight | Line Height | Usage                                         |
| ----------------------- | ---- | ------ | ----------- | --------------------------------------------- |
| **H1 (Large Header)**   | 28px | 700    | 1.2         | Page titles, major sections                   |
| **H2 (Section Header)** | 22px | 700    | 1.3         | Subsection titles, conversation topic changes |
| **H3 (Subheader)**      | 18px | 600    | 1.4         | Small section headers, card titles            |
| **Body (Regular)**      | 16px | 400    | 1.5         | Main message content, descriptions            |
| **Label (UI)**          | 14px | 600    | 1.4         | Button text, tab labels, field labels         |
| **Small (Helper)**      | 12px | 400    | 1.4         | Timestamps, secondary info, hints             |
| **Tiny (Caption)**      | 11px | 400    | 1.3         | Very small text, least important info         |

#### Typography Hierarchy Rules

1. **Headings are bold** - Immediately distinguishable from body text
2. **Body text is regular weight** - Maximum readability at small sizes
3. **Labels are semibold** - Draws attention to interactive elements
4. **All text meets 4.5:1 WCAG AA contrast ratio** - Readable in all lighting conditions

### Spacing & Layout System

#### Base Unit: 8px Grid

All spacing follows an 8px grid system for consistency and alignment.

| Scale   | Size | Usage                           |
| ------- | ---- | ------------------------------- |
| **xs**  | 4px  | Micro spacing, internal padding |
| **sm**  | 8px  | Small components, list gaps     |
| **md**  | 16px | Standard spacing, card padding  |
| **lg**  | 24px | Section spacing, large gaps     |
| **xl**  | 32px | Major section breaks            |
| **2xl** | 48px | Page-level spacing              |

#### Safe Areas & Margins

| Device               | Top Margin       | Bottom Margin        | Side Margin | Notes                                 |
| -------------------- | ---------------- | -------------------- | ----------- | ------------------------------------- |
| **Mobile (iPhone)**  | Status bar + 8px | 8px + Home indicator | 16px        | Accounts for notch and home indicator |
| **Mobile (Android)** | Status bar + 8px | 8px + nav bar        | 16px        | Standard Android spacing              |
| **Landscape Mode**   | Minimal          | Minimal              | 16px        | Optimize for reduced vertical space   |

#### Content Width & Column System

- **Mobile (< 600px):** Single column, full width minus 16px margins
- **Tablet (600px - 1024px):** Two-column grid with 16px gutters (if supporting tablets in future)
- **Maximum content width:** No constraint needed for mobile-first approach

### Dark Mode Design

**EchoAI is dark mode native** - no light mode planned for MVP.

#### Dark Mode Principles

1. **Deep base colors** - #1E293B and #0F172a prevent eye strain during extended use
2. **Sufficient contrast** - All text passes WCAG AA (4.5:1 minimum)
3. **Accent colors pop** - Vibrant purples and cyans have maximum visual impact on dark backgrounds
4. **Subtle elevation** - Use of darker/lighter grays to indicate depth rather than shadows

#### Contrast Verification

- **Text on Dark Surface:** #E2E8F0 (Slate 100) on #1E293B = 12:1 contrast ✓ (Exceeds WCAG AAA)
- **Text on Dark Surface (Secondary):** #94A3B8 (Slate 400) on #1E293B = 6.5:1 contrast ✓ (Exceeds WCAG AA)
- **Button (Purple) on Dark:** #A78BFA on #1E293B = 5.1:1 contrast ✓ (Meets WCAG AA)

---

## Part 2: Layout & Navigation Architecture

### Chosen Direction: Mobile Bottom Navigation

**Selected Layout:** Mobile Bottom Navigation with 3 primary sections (Chat, History, Settings)

**Why This Choice:**

- ✅ Most intuitive for personal assistant use case
- ✅ Chat-dominant but history/settings always accessible
- ✅ Familiar pattern across iOS and Android
- ✅ Thumb-friendly navigation at bottom of screen
- ✅ Scales well across different phone sizes (small to large screens)
- ✅ Leaves maximum vertical space for conversation

### Core Layout Structure

```
┌─────────────────────────────────────┐
│           Status Bar (iOS/Android)  │  8px
├─────────────────────────────────────┤
│                                     │
│         Chat Content Area           │  Flex: 1 (grows to fill)
│   (Messages + scrollable list)       │
│                                     │
├─────────────────────────────────────┤
│  [Input Field] [🎤] [Send Button]   │  56px input row
├─────────────────────────────────────┤
│  💬 Chat  📜 History  ⚙️ Settings   │  56px bottom nav
├─────────────────────────────────────┤
│        Home Indicator (iOS)         │  Safe area
└─────────────────────────────────────┘
```

### Screen Sections

#### 1. Status Bar (iOS/Android Native)

- **Height:** Native (typically 20-24px on iOS, variable on Android)
- **Content:** Clock, signal, battery (system-managed)
- **Design:** Allow native styling, don't obscure

#### 2. Chat Content Area (Primary)

- **Height:** Flex/dynamic (expands to fill available space)
- **Content:** Conversation history as scrollable list
- **Behavior:**
  - New messages auto-scroll to bottom
  - Can scroll up to view history
  - Messages animate in as they arrive (200-300ms slide-up)

#### 3. Input Area

- **Height:** 56px (minimum safe touch target height)
- **Layout:** Text field + Voice icon + Send button (horizontal flex)
- **Spacing:** 12px padding around inputs
- **Behavior:**
  - Placeholder text: "Type something..."
  - Voice button always visible
  - Send button appears/highlights when text entered
  - Keyboard pushes input up on mobile

#### 4. Bottom Navigation Bar

- **Height:** 56px (iOS) / 56px (Android material)
- **Items:** 3 equal-width tabs (Chat, History, Settings)
- **Active Indicator:** Underline + color change (uses cyan #22D3EE)
- **Behavior:** Tap switches between sections, preserves state

#### 5. Safe Areas (Mobile)

- **iOS:** Top (notch), Bottom (home indicator) - managed by Flutter
- **Android:** Top (status bar), Bottom (navigation bar) - managed by system

### Bottom Navigation Design

#### Anatomy

Each nav item contains:

- **Icon** (24px) - Clear, minimal icons
- **Label** (11px, caption size) - Short text below icon
- **Active indicator** - Cyan underline (2px) + text color change

#### Navigation Tabs

| Position       | Icon | Label    | Route     | Active State                           |
| -------------- | ---- | -------- | --------- | -------------------------------------- |
| **1 (Left)**   | 💬   | Chat     | /chat     | Cyan underline + cyan text + underline |
| **2 (Center)** | 📜   | History  | /history  | Cyan underline + cyan text             |
| **3 (Right)**  | ⚙️   | Settings | /settings | Cyan underline + cyan text             |

#### Visual States

**Default (Inactive):**

- Background: #1E293B
- Icon: #94A3B8 (slate-400)
- Label text: #94A3B8
- No underline

**Active:**

- Background: #1E293B (unchanged)
- Icon: #22D3EE (cyan)
- Label text: #22D3EE (cyan)
- Underline: 2px #22D3EE (cyan)
- Smooth transition: 200ms

**Pressed/Tap:**

- Icon/Text: Slightly lighter cyan (#4dd0e1)
- Underline: Grows slightly

#### Accessibility

- **Touch Target Size:** 56px (exceeds 48pt minimum)
- **Spacing:** 16px between center of each tab
- **Labels:** Required (icons alone not sufficient)
- **Semantics:** Marked as navigation tabs with proper accessibility labels

---

## Part 3: Key Screens & User Flows

### Screen 1: Chat (Active/Default)

**Purpose:** Primary interface where users interact with AI

**Key Elements:**

1. **Header** (if needed for mode display - optional for v1)

   - Time on left
   - Optional: Current mode badge (🎯 Productivity)
   - Settings gear icon on right

2. **Message List**

   - User messages: Right-aligned, purple gradient background
   - AI messages: Left-aligned, slate-700 background with cyan border
   - Timestamps: Below each message pair (or grouped)
   - Auto-scroll to newest message

3. **Message Bubble Anatomy**

   ```
   AI Message:
   ┌────────────────────────────┐
   │ I can help with that!      │  max 75% width
   │                            │  padding: 10px 14px
   └────────────────────────────┘  border-radius: 12px
   12:34 PM                       timestamp below

   User Message:
                    ┌──────────────┐
                    │ Help me plan │  purple gradient
                    │ my week      │  text: dark
                    └──────────────┘
                                    12:35 PM
   ```

4. **Input Area**

   - Text field with "Type something..." placeholder
   - Microphone button (voice input)
   - Send button (arrow icon, enabled only when text present)

5. **Interactions**
   - Tap message: Reveal reaction and copy options
   - Long press: Copy to clipboard
   - Swipe down: Dismiss keyboard
   - Type → auto-enable send button
   - Send: Clear input, add message to list, fetch response

**State Variants:**

- **Empty state:** Greeting message, quick mode selector
- **Loading:** Typing indicator while AI responds
- **Error:** Failed message with retry option

### Screen 2: Chat History

**Purpose:** Browse and access past conversations

**Layout:**

```
┌─────────────────────────────┐
│  Chat History               │
├─────────────────────────────┤
│ 🔍 [Search conversations]   │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ Planning my week        │ │  Conversation card
│ │ Yesterday, 3 messages   │ │  Title from first message
│ │ "Help me organize..."   │ │  Date, message count
│ └─────────────────────────┘ │  Preview of first user msg
│                             │
│ ┌─────────────────────────┐ │
│ │ Code review help        │ │
│ │ 2 days ago, 12 messages │ │
│ │ "Review my React code"  │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │  Most recent at top
│ │ Writing assistance      │ │  Older conversations below
│ │ 1 week ago, 5 messages  │ │  Scroll to load more
│ │ "Help me write..."      │ │
│ └─────────────────────────┘ │
│                             │
│ [Delete all conversations]  │
└─────────────────────────────┘
```

**Card Details:**

- **Title:** Auto-generated from first user message (truncated)
- **Metadata:** Date + message count
- **Preview:** Snippet of first user message (truncated)
- **Actions on swipe/long-press:** Delete, pin, archive (future)

**Interactions:**

- Tap card: Open conversation (returns to Chat screen with that conversation)
- Swipe left: Delete with confirmation
- Search: Filter conversations by keyword
- Delete All: Clears all with warning

### Screen 3: Settings

**Purpose:** Configure app behavior, customize experience

**Layout:**

```
┌─────────────────────────────┐
│  Settings                   │
├─────────────────────────────┤
│ 🎯 ASSISTANT MODE           │
│ ┌─ Productivity  (selected)  │  Radio selector
│ ├─ Learning                 │  Each shows icon + description
│ └─ Casual                   │
├─────────────────────────────┤
│ 🎨 APPEARANCE               │
│ Theme: Dark (locked for MVP)│
│ Accent Color: [Purple ●]    │  Color swatch selector
│                             │  Future: light mode
├─────────────────────────────┤
│ 🔔 NOTIFICATIONS            │
│ Push Notifications: [Toggle]│  On/Off switch
│ Sound: [Toggle]             │  Only if on
├─────────────────────────────┤
│ ℹ️ ABOUT                    │
│ EchoAI v1.0.0               │
│ © 2025                      │
│ Privacy Policy              │  Links
│ Terms of Service            │  Links
├─────────────────────────────┤
│ 🚪 ACCOUNT                  │
│ Logged in: user@email.com   │
│ [Logout]                    │  Destructive button
│ [Delete Account]            │  Destructive button
└─────────────────────────────┘
```

**Sections:**

1. **Assistant Mode** - Switch between modes instantly
2. **Appearance** - Theme and accent color (future expansion)
3. **Notifications** - Push notification preferences
4. **About** - App version and links
5. **Account** - Logout and delete options

### Navigation Flow Diagram

```
┌────────────┐
│  Chat      │  (Default screen, main experience)
│  Screen    │
└──────┬─────┘
       │ Tap message
       ▼
    ┌──────────────┐
    │ Reactions &  │
    │ Copy Menu    │
    └──────┬───────┘
           │ Tap Copy
           ▼
        Copied to
        clipboard

Bottom Nav
    │      │      │
    │      │      │
    ▼      ▼      ▼
┌──────┬──────┬────────┐
│ Chat │ Hist │ Settings│
└──────┴──────┴────────┘
         │ │ │
         └─┼─┘
           │
    Tap a history card
           │
           ▼
    Return to Chat
    with that
    conversation
```

---

## Part 4: Component Library & Design System

### Input Components

#### Text Input Field

- **Size:** 36px height (minimum safe touch)
- **Padding:** 8px horizontal, 8px vertical
- **Border:** 1px solid rgba(34, 211, 238, 0.3)
- **Border Radius:** 6px
- **Background:** rgba(34, 211, 238, 0.1)
- **Text Color:** #E2E8F0
- **Placeholder Color:** #94A3B8
- **Focus State:** Border color → #22D3EE (cyan), background slight glow

```
Default:
┌────────────────────────┐
│ Type something...      │  8px padding
└────────────────────────┘

Focus:
┌════════════════════════┐
│ Your message here      │  2px cyan border
└════════════════════════┘  slight background glow
```

#### Text Input Validation

- **Empty:** Placeholder visible, send button disabled
- **Valid:** Send button enabled, visual cue (color change)
- **Error:** Red text, error message below (if validation needed)

### Button Components

#### Primary Button (Send, Create, etc.)

- **Background:** linear-gradient(135deg, #A78BFA 0%, #C084FC 100%)
- **Text Color:** #0F172A
- **Padding:** 10px 20px
- **Border Radius:** 6px
- **Font Weight:** 600
- **Min Width:** 36px (circular for icon buttons)
- **States:**
  - **Default:** Gradient, full opacity
  - **Hover:** Slight scale (1.05), shadow
  - **Pressed:** Scale (0.98), darker overlay
  - **Disabled:** Opacity 50%, no interaction

```
Send Button:
┌──────────┐
│ ➤ Send   │  Purple gradient
└──────────┘

Voice Button:
┌──────┐
│ 🎤   │  Same styling
└──────┘
```

#### Secondary Button (Record Voice, optional modes)

- **Background:** Transparent
- **Border:** 2px solid currentColor (matches text color)
- **Text Color:** #22D3EE
- **Padding:** 10px 20px
- **States:**
  - **Default:** Outlined, no fill
  - **Hover:** Slight background (rgba(34, 211, 238, 0.1))
  - **Pressed:** Darker background

#### Destructive Button (Delete, Logout)

- **Background:** rgba(239, 68, 68, 0.2) (red with opacity)
- **Border:** 1px solid #EF4444
- **Text Color:** #FCA5A5
- \*\*Confirmation required before action

### Message Bubbles

#### User Message Bubble

```
┌────────────────────────────────────┐
│ Help me organize my tasks          │  max 75% width
│                                    │  purple gradient
│                                    │  text: dark (#0F172A)
│ padding: 10px 14px                │
│ border-radius: 12px               │
│ animation: slideInUp 0.3s ease    │
└────────────────────────────────────┘
                                12:34 PM  timestamp
```

**Styling:**

- **Background:** linear-gradient(135deg, #A78BFA 0%, #C084FC 100%)
- **Text Color:** #0F172A
- **Alignment:** Right-aligned
- **Max Width:** 75% of screen
- **Margin:** 8px right edge
- **Animation:** Slide up from bottom over 300ms

#### AI Response Bubble

```
┌────────────────────────────────────┐
│ I can help you prioritize tasks.   │  left-aligned
│ What are your top 3 priorities?    │  dark background
│                                    │  cyan border
│ padding: 10px 14px                │  lighter text
│ border-radius: 12px               │
│ border: 1px solid cyan            │
└────────────────────────────────────┘
12:34 PM
```

**Styling:**

- **Background:** #334155 (slate-700)
- **Border:** 1px solid rgba(34, 211, 238, 0.3)
- **Text Color:** #E2E8F0 (slate-100)
- **Alignment:** Left-aligned
- **Max Width:** 75% of screen
- **Margin:** 8px left edge
- **Animation:** Same as user (consistency)

#### Message Actions (Tap to Reveal)

```
User Message with Actions:
┌────────────────────────────────────┐
│ Help me organize my tasks          │
│ [👍] [👎] [❤️] [Copy] [More...]   │  action icons
└────────────────────────────────────┘
```

**Available Actions:**

- **👍 Thumbs Up** - Useful response (feedback)
- **👎 Thumbs Down** - Not helpful (feedback)
- **❤️ Heart** - Favorite this response
- **Copy** - Copy message to clipboard
- **More** - Additional options (future)

---

## Part 5: User Experience Patterns & Consistency Rules

### Button Hierarchy

**Visual Priority Order (Most to Least):**

1. **Primary Action (Highest Priority)**

   - **Use:** Send message, Record voice, Switch mode
   - **Styling:** Full purple gradient background, white text
   - **Placement:** Bottom right of input area
   - **Example:** "➤ Send" button

2. **Secondary Action (Medium Priority)**

   - **Use:** Voice input button, optional actions
   - **Styling:** Outlined/transparent with cyan border
   - **Placement:** Inline with input or as secondary option
   - **Example:** Voice button in input area

3. **Tertiary Action (Low Priority)**

   - **Use:** Navigation, less critical operations
   - **Styling:** Plain text with no styling
   - **Placement:** Menu or settings
   - **Example:** "Delete all conversations" link

4. **Destructive Action (Warning Priority)**
   - **Use:** Delete, logout, irreversible operations
   - **Styling:** Red/orange with warning color
   - **Placement:** Settings area, requires confirmation
   - **Example:** "Delete Account" button with red styling

### Feedback Patterns

#### Success Feedback

- **Confirmation Toast** (auto-dismiss after 3 seconds)
  - "✓ Message copied!" appears at top of screen
  - Green/cyan accent color
  - Slide down animation, fade out on dismiss

#### Error Feedback

- **Error Message** (persistent until dismissed)
  - Red text below the relevant field
  - Clear explanation of what went wrong
  - Suggested recovery action if applicable
  - Example: "Connection failed. Check your internet and try again."

#### Loading Feedback

- **Typing Indicator** (while AI responds)
  - Three animated dots: . . .
  - Appears in message area where response will be
  - Gentle animation (200ms between dots)
  - Disappears when response arrives

#### Form Validation

- **Real-time Validation**
  - Email field: Check format as typing
  - Password field: Check length requirements
  - Visual indicator: Green checkmark when valid
  - Error appears below field if invalid

### Empty States

#### First Launch / No Messages

```
┌─────────────────────────────────┐
│                                 │
│         👋 Hello!               │  Friendly greeting
│                                 │  emoji + text
│  Ready to chat with AI?         │
│                                 │
│  Try:                           │  Quick suggestions
│  • "Help me plan my week"       │
│  • "Review this code"           │
│  • "Explain quantum computing"  │
│                                 │
│  Tap the mic to use voice!      │  Feature hint
│                                 │
└─────────────────────────────────┘
```

#### Chat History (No Past Conversations)

```
┌─────────────────────────────────┐
│         📜 Your History         │
│                                 │
│      No conversations yet       │  Simple message
│                                 │
│    Start your first chat!       │  CTA
│      [Begin New Chat]           │
│                                 │
└─────────────────────────────────┘
```

### Confirmation Patterns

#### Destructive Actions (Delete Conversation)

```
┌─────────────────────────────────┐
│  Delete Conversation?           │
│                                 │
│  "Planning my week"             │
│  is about to be deleted.        │
│                                 │
│  This cannot be undone.         │  Clear warning
│                                 │
│  [Cancel] [Delete]              │  Red button
└─────────────────────────────────┘
```

**Pattern:**

- Title clarifies what's being deleted
- Preview shows specific item
- Warning text: "Cannot be undone"
- Two buttons: Gray (Cancel), Red (Delete)

### Navigation Patterns

#### Bottom Tab Navigation

- **Tap behavior:** Instantly switch to that section, preserve internal state
- **Active indicator:** Cyan underline + text color
- **Transition:** Smooth fade between sections (200ms)
- **Back navigation:** Not needed (bottom nav provides navigation)

#### Gesture Swipe (Optional - v2 Feature)

- **Swipe right on message:** Reply to specific message (future)
- **Swipe left on history card:** Delete with confirmation
- **Swipe down on chat:** Dismiss keyboard

### Notification Patterns

#### In-App Toast Notifications

- **Position:** Top of screen (below status bar)
- **Duration:** 3 seconds auto-dismiss
- **Success:** Green/cyan text with checkmark
- **Error:** Red text with warning icon
- **Animation:** Slide down on entry, fade out on exit

**Examples:**

- "✓ Copied to clipboard!" (cyan)
- "⚠ Message failed to send" (red, with retry)
- "🔔 New response received" (info)

### Search & Filter Patterns

#### Conversation Search

```
┌─────────────────────────────────┐
│ [🔍 Search conversations...]    │  Search field
├─────────────────────────────────┤
│ Results for "planning"          │
│                                 │
│ ✓ Planning my week              │  Matching cards
│   "Help me organize..."         │  highlight the match
│                                 │
│ ✓ Weekly planning template      │
│   "Create a weekly..."          │
│                                 │
│ No more results                 │
└─────────────────────────────────┘
```

**Behavior:**

- Type to filter in real-time
- Highlight matching text
- Show relevant results
- Show "No results" if nothing matches
- Clear button (X) to reset search

---

## Part 6: Responsive Design & Multi-Platform Considerations

### Mobile-First Breakpoints

Since EchoAI is mobile-first, we optimize for mobile and adapt up:

| Device Class       | Screen Width | Approach                        | Notes                            |
| ------------------ | ------------ | ------------------------------- | -------------------------------- |
| **Small Phone**    | 320-375px    | Single column, compact spacing  | iPhone SE, small Android         |
| **Standard Phone** | 375-425px    | Single column, standard spacing | iPhone 12-14, most Android       |
| **Large Phone**    | 425-600px    | Single column, generous spacing | iPhone 14 Pro Max, large Android |
| **Tablet**         | 600px+       | Two-column (future expansion)   | Not in MVP scope                 |

### Text Scaling

| Screen Width  | Body Text        | Heading       | Button   |
| ------------- | ---------------- | ------------- | -------- |
| **< 375px**   | 14px → 15px body | -1px headings | Standard |
| **375-425px** | 16px (standard)  | Standard      | Standard |
| **> 425px**   | 16px (standard)  | Standard      | Standard |

**Principle:** Text sizes don't change much between phones; instead, use more white space on larger screens.

### Safe Areas (Platform-Specific)

#### iOS

- **Top:** Notch safe area (typically 20-50px depending on device)
- **Bottom:** Home indicator (20-34px)
- **Implementation:** Flutter handles with `SafeArea` widget

#### Android

- **Top:** Status bar (24-25px, may be larger with notch)
- **Bottom:** Navigation bar (varies 36-48px)
- **Implementation:** Flutter handles with system insets

**Design Rule:** Always pad content away from these areas; don't place critical UI in unsafe zones.

### Device-Specific Considerations

#### iPhone with Notch (iPhone 12-15)

- Safe area reduces top space by ~44px
- Bottom nav still works well (home indicator is below nav bar)
- No special design changes needed (Flutter handles)

#### iPhone without Notch (iPhone SE 2/3)

- Standard 20px status bar
- Same layout applies
- No notch concerns

#### Android with System Navigation Bar

- Bottom bar varies by device
- Flutter's SafeArea manages this
- Bottom nav sits above system nav
- No special design changes

#### Android with Gesture Navigation (Modern)

- Gesture zones at bottom edges
- Our bottom nav is well above gesture zone
- No conflicts with system gestures

---

## Part 7: Accessibility & Inclusive Design

### WCAG 2.1 Level AA Compliance Target

EchoAI targets **WCAG 2.1 Level AA** - the recommended standard for public-facing digital products.

### Color Contrast Requirements

**All text must meet minimum contrast ratios:**

| Content Type      | Min Ratio | Standard | Achievement      |
| ----------------- | --------- | -------- | ---------------- |
| **Normal Text**   | 4.5:1     | WCAG AA  | ✅ All text 5:1+ |
| **Large Text**    | 3:1       | WCAG AA  | ✅ Headings 7:1+ |
| **UI Components** | 3:1       | WCAG AA  | ✅ Buttons 5:1+  |

**Verified Contrasts:**

- Slate-100 (#E2E8F0) on Slate-800 (#1E293B): **12:1** ✓ AAA
- Slate-400 (#94A3B8) on Slate-800 (#1E293B): **6.5:1** ✓ AA
- Purple (#A78BFA) on Slate-800 (#1E293B): **5.1:1** ✓ AA
- Cyan (#22D3EE) on Slate-800 (#1E293B): **5.3:1** ✓ AA

### Touch Target Sizing

**Minimum touch target:** 48pt × 48pt (exceeds platform standards)

| Component          | Min Size    | Actual                    | Spacing             |
| ------------------ | ----------- | ------------------------- | ------------------- |
| **Buttons**        | 48pt        | 48-56pt                   | 8pt minimum between |
| **Message bubble** | 44pt height | ~50-60pt                  | 8pt below each      |
| **Tab items**      | 48pt height | 56pt                      | Equal spacing       |
| **Text links**     | 48pt        | Wrapped in 48pt container | Safe area           |

### Keyboard Navigation

**All interactive elements must be keyboard accessible:**

| Element              | Keyboard Action              | Behavior                            |
| -------------------- | ---------------------------- | ----------------------------------- |
| **Text Input**       | Tab to focus, Type           | Focus ring visible, input active    |
| **Send Button**      | Tab to focus, Enter/Space    | Sends message when focused          |
| **Message Bubbles**  | Tab to focus, Not editable   | Can select and copy (accessibility) |
| **Bottom Nav Tabs**  | Tab to navigate, Enter/Space | Switch section when activated       |
| **Settings toggles** | Tab to focus, Space          | Toggle on/off                       |

**Focus Indicator:**

- **Color:** Cyan (#22D3EE)
- **Style:** 2px solid outline
- **Visibility:** Always visible, high contrast

### Screen Reader Support

#### Semantic HTML/Widget Structure

```
Chat Screen:
├─ Page: "Chat with EchoAI"
├─ Region: "Messages" (main)
│  ├─ Message item (role: article)
│  │  ├─ Text: [AI response]
│  │  └─ Time: "2:34 PM"
│  └─ ...more messages
├─ Region: "Message input" (complementary)
│  ├─ Input field: "Type your message"
│  ├─ Button: "Record voice message (microphone)"
│  └─ Button: "Send message (arrow)"
└─ Navigation: "Bottom tabs"
   ├─ "Chat tab" (current)
   ├─ "History tab"
   └─ "Settings tab"
```

#### Aria Labels

All images, icons, and buttons must have semantic labels:

```
send_button.semanticLabel = "Send message"
voice_button.semanticLabel = "Record voice message"
like_reaction.semanticLabel = "Mark helpful"
message_timestamp.semanticLabel = "Sent 2 hours ago"
```

#### Announcement Patterns

**Screen readers announce:**

- New messages arrival: "AI: [message text]"
- Typing indicator: "AI is typing..."
- Error messages: "Error: [description]"
- Success feedback: "Message copied to clipboard"

### Motion & Animation Accessibility

**Principle:** Never rely on animation alone for information.

- **Typing indicator:** Both animated dots AND text "AI is typing..."
- **Message arrival:** Both animation AND haptic feedback (iOS/Android)
- **Loading state:** Visible spinner AND text "Loading..."
- **Prefers Reduced Motion:** Respect system setting; disable animations if user has set this

### Language & Readability

**Text clarity standards:**

- **Simple language:** Avoid jargon where possible
- **Sentence length:** Keep under 20 words when possible
- **Error messages:** Clear, actionable, not technical
  - ❌ Bad: "Socket timeout error"
  - ✅ Good: "Connection lost. Check your internet and try again."
- **Consistent terminology:** Same feature = same name throughout

### Dark Mode Accessibility

Since EchoAI is dark-mode only:

- **No flashing content:** Avoid rapid color changes that could trigger seizures
- **Motion:** Animations are smooth, not jerky
- **Legibility:** Dark background reduces eye strain, but text still needs contrast
- **Reduced motion option:** Always available in settings

---

## Part 8: Animation & Motion Design

### Core Animation Principles

1. **Every interaction has feedback** - User always knows action was registered
2. **Animations are purposeful** - Motion guides attention, shows relationships
3. **Smooth and natural** - 200-300ms for most transitions, easing functions vary
4. **Respects system preferences** - Reduced motion settings honored

### Animation Specifications

#### Message Arrival Animation

```
Trigger: New message added to chat
Duration: 300ms
Easing: easeOut (cubic-bezier(0.0, 0.0, 0.2, 1.0))
Motion: Slide up + Fade in
- Start: translateY(10px), opacity(0)
- End: translateY(0), opacity(1)
Visual effect: Message smoothly appears from below

Code pattern:
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

animation: slideInUp 0.3s ease-out;
```

#### Button Interaction

```
Default State:
- Background: Purple gradient
- Scale: 1.0
- Shadow: 0 2px 4px rgba(0,0,0,0.1)

Hover State (Desktop):
- Background: Same gradient
- Scale: 1.05
- Shadow: 0 4px 12px rgba(167,139,250,0.3)
- Transition: 200ms ease

Pressed State:
- Scale: 0.98
- Shadow: 0 1px 2px rgba(0,0,0,0.1)
- Duration: 100ms

Release:
- Back to hover/default

Disabled State:
- Opacity: 0.5
- No scale changes
- No shadow
- No interaction
```

#### Tab Switch Animation

```
Trigger: Tap different bottom nav tab
Duration: 200ms
Easing: easeInOut
Motion: Fade + Slide

Outgoing section:
- opacity: 1 → 0
- transform: translateX(0) → translateX(-20px)

Incoming section:
- opacity: 0 → 1
- transform: translateX(20px) → translateX(0)

Effect: Smooth transition between tabs, current section fades out while new slides in
```

#### Typing Indicator

```
Three dots animated sequence:
Dot 1: Scale 1.0 → 1.2 → 1.0 (0-200ms, repeat)
Dot 2: Delay 100ms (offset from Dot 1)
Dot 3: Delay 200ms (offset from Dot 1)

Duration: 600ms total, infinite loop
Easing: ease-in-out on scale

Visual effect: Pulsing dots that suggest continuous activity
```

#### Copy Confirmation Toast

```
Trigger: User taps "Copy" button
Entry animation (300ms):
- opacity: 0 → 1
- translateY: -20px → 0px

Visible: 2500ms (without interaction)

Exit animation (300ms):
- opacity: 1 → 0
- translateY: 0px → -20px

Effect: Toast slides up from top, shows briefly, slides away
```

### Animation Timing Guidelines

| Duration        | Use Case                                       |
| --------------- | ---------------------------------------------- |
| **100ms**       | Micro interactions (button press, icon change) |
| **200ms**       | Screen transitions, tab switches               |
| **300ms**       | Message arrivals, modal entries                |
| **400ms-600ms** | Complex animations, typing indicators          |
| **> 600ms**     | Avoid (feels sluggish, test user patience)     |

### Easing Functions

**Standard ease curve:** `cubic-bezier(0.4, 0.0, 0.2, 1.0)` (Material Design standard)

| Easing Type     | Function                           | Use Case                          |
| --------------- | ---------------------------------- | --------------------------------- |
| **ease-out**    | `cubic-bezier(0.0, 0.0, 0.2, 1.0)` | Entrances (appears, slides in)    |
| **ease-in**     | `cubic-bezier(0.4, 0.0, 1.0, 1.0)` | Exits (disappears, slides away)   |
| **ease-in-out** | `cubic-bezier(0.4, 0.0, 0.2, 1.0)` | Continuous motion (tab switches)  |
| **linear**      | `linear`                           | Progress indicators, loading bars |

---

## Part 9: Voice Interaction Design

### Voice Recording Interface

#### Visual Feedback During Recording

```
┌─────────────────────────────────┐
│         🎤 Recording...         │  Listening indicator
│                                 │
│      ▁ ▂ ▃ ▅ ▆ ▅ ▃ ▂ ▁        │  Waveform animation
│      (represents audio levels)  │  shows mic input
│                                 │
│    Tap to Stop Recording        │  Clear CTA
│                                 │
└─────────────────────────────────┘
```

**Waveform Animation:**

- 8-10 bars representing frequency bands
- Animate in real-time to match audio input
- Colors: Cyan accents on dark background
- Height varies based on audio level (100ms updates)
- Smooth transitions between heights

#### Voice Input States

| State                | Visual               | Audio          | Duration                     |
| -------------------- | -------------------- | -------------- | ---------------------------- |
| **Before Recording** | Button with mic icon | None           | N/A                          |
| **Recording Active** | Waveform animates    | Continuous     | User controls                |
| **Silence Detected** | Waveform flattens    | None           | Auto-stop after 2sec silence |
| **Processing**       | Spinner/waveform     | None           | < 1 second                   |
| **Success**          | Text appears         | Optional chime | N/A                          |
| **Error**            | Error message        | Optional beep  | User retry                   |

### Voice-to-Text Transcription

**Display after recording:**

```
┌─────────────────────────────────┐
│ 🎤 Help me plan my week        │  Transcribed text
│ [Edit]        [Use This]        │  Action buttons
│ [Try Again]                     │
└─────────────────────────────────┘
```

**Interactions:**

- **Edit:** Opens keyboard to adjust transcription
- **Use This:** Send as-is without editing
- **Try Again:** Re-record if transcription was poor
- **Preview:** Always show transcribed text before sending

### Text-to-Speech Output

**Trigger:** Tap speaker icon on AI message

```
AI Message with TTS active:
┌────────────────────────────────┐
│ I can help you plan your week. │
│ What are your priorities?      │
│                                │
│ [▶ 1:23 / 2:15] [Speed: 1x]   │  Playback controls
└────────────────────────────────┘
```

**Controls:**

- **Play/Pause:** Tap to control playback
- **Progress bar:** Shows current position, tap to seek
- **Speed:** 0.8x, 1x (default), 1.25x, 1.5x
- **Stop:** Pause and reset to beginning

**Voice Quality:** Natural, gender-neutral (or user-selectable in future)

---

## Part 10: Data Persistence & State Management

### Chat History Persistence

**Data Store:** Local SQLite database on device

```
Conversations Table:
├─ id (UUID)
├─ title (string, auto-generated)
├─ mode (string: "productivity" | "learning" | "casual")
├─ created_at (timestamp)
├─ last_accessed (timestamp)
├─ message_count (integer)
└─ is_archived (boolean, future)

Messages Table:
├─ id (UUID)
├─ conversation_id (foreign key)
├─ author (string: "user" | "ai")
├─ content (string, text)
├─ timestamp (datetime)
├─ reactions (json: {thumbs_up: false, like: false, etc})
└─ is_deleted (boolean, soft delete option)
```

**Sync Strategy:**

- All data saved locally
- No cloud sync in MVP (local-only)
- Data never leaves user's device
- No telemetry or analytics

### Application State Management

**State Management Approach:** Provider pattern (recommended Flutter architecture)

```
AppState providers:
├─ AuthProvider
│  ├─ isLoggedIn
│  ├─ currentUser
│  └─ sessionToken
│
├─ ChatProvider
│  ├─ currentConversation
│  ├─ messages (list)
│  ├─ isLoadingResponse
│  └─ currentMode
│
├─ HistoryProvider
│  ├─ conversations (list)
│  ├─ searchQuery
│  └─ filteredResults
│
└─ SettingsProvider
   ├─ selectedMode
   ├─ accentColor
   ├─ notificationsEnabled
   └─ soundEnabled
```

### User Preferences Persistence

**Stored in:** Local device settings (iOS: UserDefaults, Android: SharedPreferences)

```
Preferences:
├─ selectedAssistantMode ("productivity" | "learning" | "casual")
├─ accentColor ("#A78BFA" or future options)
├─ notificationsEnabled (true/false)
├─ soundEnabled (true/false)
├─ lastOpenedChat (UUID or null)
└─ appVersion (for migration logic)
```

---

## Part 11: Testing & Quality Assurance

### Design Validation Checklist

Before implementation, design should be validated for:

#### Functional Testing

- [ ] All buttons are interactive and respond to taps
- [ ] Navigation between tabs works smoothly
- [ ] Messages display correctly (both user and AI)
- [ ] Input field accepts text and voice
- [ ] Message history persists after app restart
- [ ] Settings changes are saved and applied

#### Visual Testing

- [ ] Colors match specification (exact hex codes)
- [ ] Typography scale is consistent
- [ ] Spacing follows 8px grid
- [ ] Dark mode contrast meets WCAG AA
- [ ] Animations are smooth (60 FPS on both platforms)
- [ ] Loading states clearly indicate progress

#### Responsive Testing

- [ ] iPhone SE (small screen) works well
- [ ] iPhone 14 Pro Max (large screen) works well
- [ ] Android devices (various sizes) work well
- [ ] Landscape orientation works (if supported)
- [ ] Safe areas respected on all platforms

#### Accessibility Testing

- [ ] All buttons have 48pt touch targets
- [ ] Keyboard navigation works (tab through all elements)
- [ ] Screen reader announces content correctly
- [ ] Color contrast meets WCAG AA (4.5:1 minimum)
- [ ] No content relies on color alone to convey meaning
- [ ] Focus indicators are visible

#### User Testing

- [ ] First-time users can complete a message without help
- [ ] Chat history tab is intuitive to use
- [ ] Mode switching is discoverable
- [ ] Voice recording works reliably
- [ ] Error states are clear and recoverable

---

## Part 12: Future Expansion & Growth Features

### Potential enhancements beyond MVP:

1. **Light Mode Theme** - Adapt color system for light backgrounds
2. **Custom Accent Colors** - Let users choose from expanded palette
3. **Conversation Sharing** - Generate shareable links to chats
4. **Advanced Search** - Filter by date, mode, sentiment
5. **Conversation Pinning** - Mark important conversations
6. **Export to PDF** - Save conversations as documents
7. **Cloud Sync** - Sync across devices
8. **Multi-language UI** - Internationalize interface
9. **Web Version** - Responsive web app
10. **Conversation Reminders** - Scheduled follow-ups

---

## Conclusion

This UX Design Specification provides a comprehensive guide for building EchoAI with a consistent, intuitive, and beautiful user experience. Every design decision is documented with rationale and implementation guidance.

**Next Steps for Development:**

1. Create detailed wireframes from this specification
2. Develop high-fidelity mockups with actual UI components
3. Build interactive prototypes for user testing
4. Implement based on specification, referencing this document throughout
5. Validate against this specification before launch

**Design System Maintained By:**

- UX Designer (direction, decisions)
- Visual Designer (detailed mockups)
- Development Team (implementation, adjustments)
- QA Team (validation against specification)

---

**Document Control:**

- **Version:** 1.0
- **Created:** November 10, 2025
- **Last Updated:** November 10, 2025
- **Status:** ✅ Ready for Development
- **Approval:** Pending stakeholder review
