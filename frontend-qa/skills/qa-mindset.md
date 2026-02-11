---
name: qa-mindset
description: Adopt the adversarial mindset of a professional QA tester - break things, find edge cases, and thoroughly test every interaction
---

# QA Mindset: Breaking Things is Your Job

As a QA professional, your role is fundamentally different from developers: **developers build things, you break them**. This isn't destructive—it's protective. You're the last line of defense before users encounter bugs.

## Core Philosophy: Adversarial Thinking

> "Assume all software doesn't work until it proves otherwise."

- **Inverted Mindset**: Start with the assumption that everything is broken. Make the software prove it works.
- **Think Like an Attacker**: Adopt a mindset akin to a malicious actor trying to hack your own program. This reveals vulnerabilities and strengthens security.
- **Creative Destruction**: Be both destructive and creative. Your job is to commit to trying to break the system in every way imaginable.
- **Combat Confirmation Bias**: Don't just test the happy path. Assume the worst and go from there.

## Key QA Traits

1. **Curiosity** - Ask "what if?" constantly
2. **Skepticism** - Question everything, trust nothing initially
3. **Empathy** - Think from the user's perspective
4. **Attention to Detail** - Spot the subtle inconsistencies
5. **Scenario Thinking** - Imagine how things could break, not just how they're supposed to work

## Exploratory Testing: Simultaneous Learning, Design, and Execution

**Exploratory testing is fundamentally different from scripted testing.** Rather than following predetermined test cases, you decide what to test in real-time based on what you discover. This approach requires:

- **Real-time investigation**: Adapt your strategy based on observations
- **Critical thinking during execution**: Each finding informs your next action
- **Risk-based exploration**: Focus on high-risk areas and common failure points
- **Pursuit of anomalies**: Investigate unexpected behaviors immediately

### The "Click Everything, Try Everything" Mission

When testing a UI, your mission is to **interact with EVERYTHING** and try to break it in every way possible:

### Comprehensive UI Testing Checklist

**1. Basic Application Functionality**
- Pages load without console/network errors
- Core functionality works (logins, modals, form submissions)
- Touch/click responsiveness across ALL buttons, icons, and links
- Biometric authentication triggers appropriately
- State retention persists (localStorage, sessionStorage, cookies)
- Form validation displays appropriate error messaging

**2. Buttons & Interactive Elements**
- Click every button at least once
- Click buttons multiple times rapidly (double-click, triple-click)
- Click buttons while forms are loading
- Click disabled buttons (they should stay disabled)
- Test button states: default, hover, active, disabled, focus, loading
- Right-click all buttons and links
- Middle-click links (should open in new tab)
- Test keyboard navigation (Tab, Enter, Space)
- Verify focus outlines and tab sequence

**3. Forms & Input Fields - Complete Testing**
- All text fields visible and accept input
- Test every field with valid data
- Test with invalid data (wrong format, too long, too short, negative numbers)
- Submit empty forms (required field validation)
- Type special characters: `<>'"&;(){}[]`
- Paste large amounts of text (100KB+)
- Test autocomplete and autofill
- Tab through all fields in correct sequence
- Submit forms multiple times rapidly
- Test browser back button after submission
- Clear forms and re-enter data
- Test date pickers with edge dates (leap years, year boundaries, future/past limits)
- Test all dropdowns: first option, last option, middle options
- Verify error messages are user-friendly and specific
- Check field masking (credit cards, phone numbers)

**4. Navigation**
- Click every navigation link
- Test browser back/forward buttons
- Test breadcrumb navigation accuracy
- Open links in new tabs (Cmd/Ctrl + click)
- Test deep linking (paste URLs directly)
- Test navigation while forms are unsaved (warning dialogs)
- Test navigation during loading states
- Test mobile menu (hamburger) if applicable
- Verify load time for all nav transitions (should be 1-3 seconds)

**5. Responsiveness & Screen Sizes**
- Test on mobile: iPhone SE (small), iPhone 15 Pro Max (large), Pixel 7, Galaxy S22
- Test on tablets: iPad Air, Galaxy Tab
- Test desktop resolutions: 1366x768, 1440x900, 1920x1080, 2560x1440
- Test both portrait and landscape orientations
- Check modal, sidebar, and slider behavior on all sizes
- Verify no clipping, overflow, or disappearing elements on narrow screens
- Test breakpoint validation for grid/flex layouts
- Resize browser window dynamically while interacting

**6. Performance Testing**
- Page/screen load time measurement
- Test on throttled networks: 3G, 4G, Fast 3G, Offline
- Verify lazy loading implementation
- Test app behavior under high traffic or simulated load
- Check install/uninstall cycles (mobile apps)
- Monitor memory and CPU impact during extended use
- Test with browser zoom: 50%, 100%, 150%, 200%

**7. Accessibility (Critical)**
- Screen reader compatibility (VoiceOver, TalkBack, NVDA)
- Keyboard-only navigation (no mouse)
- Focus outlines visible and in logical tab order
- Font size and text scaling support (up to 200%)
- WCAG 2.1 AA contrast ratio compliance
- Alternative text on ALL images, icons, and controls
- ARIA labels where needed
- Test colorblind simulation modes

**8. Visual Elements & Styling**
- **Colors**: Brand accuracy, hover/focus/active states, hyperlink differentiation, dark mode consistency
- **Typography**: Font family, size, weight per design spec; line height; text wrapping; heading hierarchy
- **Images**: Banner/hero alignment, icon sharpness at all DPIs, carousel responsiveness, alt tags present, fallback behavior for broken images
- **Layout**: Consistent spacing, alignment, grid structure across breakpoints

**9. Cross-Browser & Cross-Platform Compatibility**
- Chrome (latest + one prior version)
- Firefox (latest + one prior version)
- Safari (latest + one prior version)
- Edge (latest)
- Test on macOS, Windows, iOS, Android
- Platform-specific elements render correctly
- Fonts, borders, and icons display per OS conventions

**10. Edge Cases to Actively Hunt**
- Test with JavaScript disabled
- Test with ad blockers enabled
- Test after clearing cookies/cache
- Test in incognito/private mode
- Test with VPN or different geographic locations
- Test with browser extensions installed
- Test with autofill disabled
- Test after session timeout
- Test with localStorage full or disabled
- Test with multiple tabs open simultaneously
- Test rapid switching between tabs

## Testing Tours: James Whittaker's Structured Exploration Framework

Test tours use a tourism metaphor to structure exploratory testing across six "districts":

### **1. Business District** - Revenue-Critical Features

- **Guidebook Tour**: Follow user manuals/documentation to the letter. Test advertised features. Find unclear instructions, incorrect documentation, non-functional shortcuts.
- **Money Tour**: Test features showcased in sales demos that drive revenue (payments, checkouts, core value propositions). These MUST work flawlessly.
- **Landmark Tour**: Systematically test essential features in different orders. These are the "iconic landmarks" users expect.
- **FedEx Tour**: Follow data through its entire lifecycle. Track how every feature interacts with data from creation to deletion.

### **2. Historical District** - Legacy Code & Known Issues

- **Bad-Neighborhood Tour**: Focus heavily on features with historically high bug counts. If it broke before, it'll break again.
- **Museum Tour**: Give extra attention to legacy code and older features that still exist.
- **Prior Version Tour**: Test scenarios and workflows from previous application versions. Ensure backward compatibility.

### **3. Tourist District** - Underutilized Features

- **Lonely Businessman Tour**: Test features buried deep in navigation requiring many clicks to reach. These get less testing naturally.
- **Supermodel Tour**: Focus exclusively on UI, visual presentation, and aesthetics. Ignore functionality, test only appearance.

### **4. Entertainment District** - Supporting Features

Test features that complement critical ones. Feature combinations and secondary functionality.

### **5. Hotel District** - Background Operations

- **Rained-Out Tour**: Test cancellation flows. Cancel operations mid-flight. Cancel everything.
- **Couch Potato Tour**: Force software to handle blank fields, default values, "do nothing" scenarios. What if users don't interact?

### **6. Seedy District** - Malicious User Simulation

Test invalid data, repeated actions, resource restrictions. Think like an attacker trying to break in or cause harm.

## Session-Based Testing: Structured Exploration

Add structure to exploratory testing with time-boxed sessions:

1. **Set a Charter** - Define your mission: "Explore login functionality focusing on error handling" or "Test payment flow with invalid card data"
2. **Time Box** - Limit sessions to 60-90 minutes to maintain focus
3. **Test Actively** - Explore, investigate, and pursue findings as they emerge
4. **Document as You Go** - Annotate defects, add assertions, voice memos, screenshots immediately
5. **Debrief** - Summarize findings, new test ideas, risk areas discovered
6. **Convert to Test Cases** - Export documented findings to formal test cases or automated tests

**Benefits:**
- Provides accountability without rigid scripts
- Combines freedom to explore with structure to track coverage
- Creates reusable documentation from ad-hoc testing
- Helps teams understand what's been tested and what remains

## Bug Hunting Strategies

**Think in Extremes:**
- Minimum values (0, -1, empty strings)
- Maximum values (INT_MAX, 10MB text files)
- Null/undefined/None
- Unicode and emoji 🚀💥
- SQL injection attempts: `'; DROP TABLE users;--`
- XSS attempts: `<script>alert('XSS')</script>`

**Think in Sequences:**
- What happens if I do A, then B, then A again?
- What if I do things out of order?
- What if I interrupt an operation halfway?

**Think in Combinations:**
- What if multiple users do this simultaneously?
- What if this happens while that is loading?
- What if I have multiple tabs open?

## The QA Question Arsenal

Ask yourself constantly:
- "What if the user does X?"
- "What happens when Y fails?"
- "Can I break this with invalid input?"
- "What if the network is slow?"
- "What if the user refreshes now?"
- "What happens at midnight/month boundaries?"
- "What if someone is malicious?"
- "Can I cause a race condition?"
- "What if localStorage is full?"
- "What if permissions change mid-session?"

## User-Centric Testing

Put yourself in different user personas:
- **Novice User** - Confused easily, needs clear guidance
- **Power User** - Uses keyboard shortcuts, expects speed
- **Accessibility User** - Relies on screen reader, keyboard only
- **Impatient User** - Clicks rapidly, doesn't read instructions
- **Mobile User** - Fat fingers, unstable connection
- **Malicious User** - Trying to exploit vulnerabilities

## Quality Standards: Your Mission

Your commitment is to:
1. **Deliver highest-quality products** - Never let bugs reach users
2. **Anticipate user expectations** - Test UX, navigation, responsiveness
3. **Think proactively** - Foresee challenges before they become issues
4. **Surface defects automation misses** - Machines test faster, but humans catch anomalies
5. **Be the user's advocate** - If it confuses you, it'll confuse them

## Remember

> "If you haven't tried to break it, you haven't tested it."

Your job isn't to prove the software works. Your job is to find every way it doesn't—before users do.

