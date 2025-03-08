# KeyPhantom

<p align="center">
  <img src="KeyPhantom/Assets.xcassets/AppIcon.appiconset/256.png" width="128" height="128">
</p>

<p align="center">
  <strong>Send keyboard events silently to background applications</strong>
</p>

## Overview

KeyPhantom is a macOS utility that lets you create keyboard shortcuts that send specific keystrokes to background applications - like a phantom operating behind the scenes. Perfect for power users who need to control multiple applications simultaneously without switching contexts.

## Key Features

- **Custom Keyboard Shortcuts**: Create global shortcuts that trigger specific key presses in target applications
- **Application Targeting**: Send keystrokes to specific applications without bringing them to the foreground
- **Menu Bar Control**: Quick access to enable/disable functionality from the status menu
- **Easy-to-Use Interface**: Simple settings panel for managing your phantom key bindings
- **Launch at Login**: Option to start automatically when you log in
- **Automatic Updates**: Stay current with the latest features and improvements

## Why I Built KeyPhantom

I created KeyPhantom to solve a personal frustration. As a Minecraft player, I often found myself wanting to read e-books while playing. However, Minecraft relies heavily on mouse control, making it impossible to switch to other apps like WeChat Reading or other e-book readers to flip pages without disrupting gameplay.

KeyPhantom lets me assign some global shortcuts that send "page turn" keystrokes to my e-book reading app in the background while I remain focused on Minecraft. This way, I can continue gaming with full mouse control while still flipping my e-book, without switching apps and making my game lose focus and pause.

## Requirements

- macOS 13.5 or later
- Accessibility permissions (required to send keystrokes to applications)

## Installation

1. Download the latest release from the [Releases](https://github.com/situ2001/keyphantom/releases) page
2. Move KeyPhantom to your Applications folder
3. Launch KeyPhantom and follow the onscreen instructions to grant Accessibility permissions

## Usage

After setting up KeyPhantom, you can create phantom key bindings to send keystrokes to background applications:

1. Open KeyPhantom from your Applications folder
2. Click the keyboard icon in your menu bar to access KeyPhantom
3. Open Settings to configure your phantom key bindings
4. Create a new binding by:
   - Setting a global shortcut. For example, `Control + D`
   - Recording the key to be sent. For example, `Right Arrow`
   - Selecting the target application
5. Enable KeyPhantom using the toggle in menu or in the settings panel

Then, whenever you press your global shortcut (For example, `Control + D`), KeyPhantom will send the recorded key (For example, `Right Arrow`) to the target application, no matter which app is currently in focus.

## Planned Features

KeyPhantom currently supports sending single keyboard events to background applications, but more features are planned for future releases:

- **Modifier Key Support**: Send complex key combinations with modifier keys
- **Scroll Wheel Events**: Control scrolling in background applications

## Privacy

KeyPhantom requires accessibility permissions to function but does not record or transmit your keystrokes. All operations happen locally on your Mac.

## Support

If you encounter any issues or have questions, please file an issue in the [GitHub repository](https://github.com/situ2001/keyphantom/issues).

## License

Copyright © 2025 situ2001. All rights reserved.