# Auto Delete Auto Save

When Emacs is closed without saving buffers that have unsaved changes, the
auto-save files are not deleted.  This package provides a global minor mode,
`auto-delete-auto-save-mode`, that automatically deletes those auto-save files.
The mode can be enabled by putting this in your init file:

    (require 'auto-delete-auto-save-mode)
    (auto-delete-auto-save-mode)  ; or customize the
                                  ; `auto-delete-auto-save-mode' variable

Or, if you have `use-package`:

    (use-package auto-delete-auto-save-mode
      :config                       ; or customize the
      (auto-delete-auto-save-mode)  ; `auto-delete-auto-save-mode' variable
