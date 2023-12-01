The code is copied from https://github.com/singerdmx/flutter-quill.
Last checkout commit: https://github.com/singerdmx/flutter-quill/commit/f01f93590770f0a7a2124efb78516073dbddf5ae

Modified:
1. Remove unused deps for our use cases.
2. Code format.
3. Remove code for toolbar.
4. Replace `pasteboard` with `super_clipboard`.
5. When double clicking or onDragSelectionEnd, only show editor context menu in Mobile.
6. Don't show "copy" and "cut" in context menu if select nothing.
7. Show the cursor immediately when focused instead of waiting.
8. Remove cursor animation.
9. Show "SystemMouseCursors.text" for whole editor rather than text lines only.