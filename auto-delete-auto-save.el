;;; auto-delete-auto-save.el --- Delete auto-save files when Emacs is closed
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2019

;; Author: Sarah Marshall <marshallsaraha@gmail.com>
;; Keywords: files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; When Emacs is closed without saving buffers that have unsaved changes, the
;; auto-save files are not deleted.  This package provides a global minor mode,
;; `auto-delete-auto-save-mode', that automatically deletes those auto-save
;; files.  The mode can be enabled by putting this in your init file:
;;
;; (require 'auto-delete-auto-save-mode)
;; (auto-delete-auto-save-mode)  ; or customize the
;;                               ; `auto-delete-auto-save-mode' variable
;;
;; Or, if you have `use-package':
;;
;; (use-package auto-delete-auto-save-mode
;;   :config                        ; or customize the
;;   (auto-delete-auto-save-mode))  ; `auto-delete-auto-save-mode' variable

;;; Code:

(defun auto-delete-auto-save--delete (&optional buffer)
  "Deletes the auto-save file for the given buffer, or for the
current buffer if no buffer is given."
  (when (buffer-file-name buffer)
    (let ((file-name (if buffer
                         (with-current-buffer buffer (make-auto-save-file-name))
                       (make-auto-save-file-name))))
      (when (and file-name (file-exists-p file-name))
        (delete-file file-name)))))

(defun auto-delete-auto-save--delete-all ()
  "Deletes the auto-save file for every buffer with unsaved changes."
  (let ((unsaved-buffers (seq-filter (lambda (buffer)
                                       (and (buffer-file-name buffer)
                                            (buffer-modified-p buffer)))
                                     (buffer-list))))
    (when unsaved-buffers
      (mapc #'auto-delete-auto-save--delete unsaved-buffers))))

(defun auto-delete-auto-save--on-emacs-closed ()
  "Deletes the auto-save file for every buffer with unsaved
changes when Emacs is closed."
  (auto-delete-auto-save--delete-all)
  ;; Return non-nil so Emacs will still close.
  t)

(define-minor-mode auto-delete-auto-save-mode
  "Global minor mode to delete auto-save files when Emacs is
closed."
  :global t
  :require 'auto-delete-auto-save
  (if auto-delete-auto-save-mode
      (add-to-list 'kill-emacs-query-functions
                   #'auto-delete-auto-save--on-emacs-closed)
    (setq kill-emacs-query-functions
          (remove #'auto-delete-auto-save--on-emacs-closed
                  kill-emacs-query-functions))))

(provide 'auto-delete-auto-save)
;;; auto-delete-auto-save.el ends here
