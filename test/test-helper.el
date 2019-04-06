;;; test-helper.el --- BNF Mode: Non-interactive unit-test setup -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2019 jim

;; Author: jim <xcwenn@qq.com>
;; Maintainer: jim
;; URL: https://github.com/xcwen/ac-php

;; This file is not part of GNU Emacs.

;;; License

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; Non-interactive test suite setup for ERT Runner.

;;; Code:

(require 'ert-x)  ; `ert-with-test-buffer'
(require 'cl-lib) ; `cl-defmacro'

;; Make sure the exact Emacs version can be found in the build output
(message "Running tests on Emacs %s" emacs-version)

(when (require 'undercover nil t)
  (progn
    (undercover "ac-php.el")
    (undercover "ac-php-core.el")
    (undercover "company-php.el")
    (undercover "helm-ac-php-apropros.el")))

(let* ((current-file (if load-in-progress load-file-name (buffer-file-name)))
       (source-directory (locate-dominating-file current-file "Cask"))
       ;; Don't load old byte-compiled versions
       (load-prefer-newer t))
  ;; Load the file under test
  (load (expand-file-name "ac-php" source-directory))
  (load (expand-file-name "ac-php-core" source-directory))
  (load (expand-file-name "company-php" source-directory))
  (load (expand-file-name "helm-ac-php-apropros" source-directory)))

(defun ac-php-test-parse-equal (line expected)
  "Verifies that after parsing LINE will be the same as EXPECTED."
  (let* ((splitted (ac-php-split-line-4-complete-method line))
         (actual (ac-php-remove-unnecessary-items-4-complete-method splitted)))
    (should (equal actual expected))))

;;; test-helper.el ends here