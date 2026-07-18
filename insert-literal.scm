;; insert-literal.scm - insert literal commands for Helix.
;;
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; Copyright (C) 2026 Tom Waddington
;;
(require-builtin helix/components as helix.components.)
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/configuration.scm")
(require "helix/misc.scm")

(provide
  insert-literal
  insert-without-pairing)

;;@doc
;; Insert the next keypress literally, bypassing auto-pairs, auto-indent, and other
;; insert-mode processing.
(define (insert-literal)
  (on-key-callback
    (lambda (event)
      (let* ((is? (lambda (spec) (equal? event (helix.components.string->key-event spec))))
             (insert-byte (lambda (n) (helix.static.insert_string (string (integer->char n)))))
             (ch (helix.components.on-key-event-char event))
             (letter (and ch
                      (let* ((lc (char-downcase ch))
                             (code (char->integer lc)))
                        (and (>= code 97) (<= code 122) lc)))))
        (cond
          ((is? "esc") (insert-byte 27))
          ((is? "ret") (insert-byte 13))
          ((is? "tab") (insert-byte 9))
          ((and letter (is? (string-append "C-" (string letter))))
            (insert-byte (- (char->integer letter) 96)))
          (ch (helix.static.insert_string (string ch)))
          (else (void)))))))

;;@doc
;; Return the list of current auto-pairing characters.
(define (current-pair-chars)
  (let ((default-pair-chars (list #\( #\) #\{ #\} #\[ #\] #\' #\" #\`))
        (cfg (get-config-option-value "auto-pairs")))
    (cond
      ((equal? cfg #t) default-pair-chars)
      ((equal? cfg #f) '())
      ((hash? cfg) (map (lambda (x) (if (char? x) x (string-ref x 0)))
                    (append (hash-keys->list cfg) (hash-values->list cfg))))
      (else default-pair-chars))))

;;@doc
;; Insert the next keypress, but if it is one of the currently auto-paired
;; characters, insert it raw so no matching pair is added. Any other key is
;; typed normally.
(define (insert-without-pairing)
  (on-key-callback
    (lambda (event)
      (let ((ch (helix.components.on-key-event-char event)))
        (cond
          ((and ch (member ch (current-pair-chars)))
            (helix.static.insert_string (string ch)))
          (ch (helix.static.insert_char ch))
          (else (void)))))))
