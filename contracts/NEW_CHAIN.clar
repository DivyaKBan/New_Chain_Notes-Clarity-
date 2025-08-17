;; On-Chain Notes/Message Board
;; Store short public messages on-chain.

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-message-too-long (err u100))
(define-constant err-message-empty (err u101))
(define-constant max-message-length u280) ;; Twitter-like character limit

;; Data structures
;; Map to store messages by user and message ID
(define-map user-messages 
  {user: principal, message-id: uint} 
  {content: (string-utf8 280), timestamp: uint, likes: uint})

;; Track message count per user
(define-map user-message-count principal uint)

;; Track total messages on the board
(define-data-var total-messages uint u0)

;; Function 1: Post a message to the board
(define-public (post-message (content (string-utf8 280)))
  (let (
    (user tx-sender)
    (current-count (default-to u0 (map-get? user-message-count user)))
    (message-id (+ current-count u1))
  )
    ;; Validate message content
    (asserts! (> (len content) u0) err-message-empty)
    (asserts! (<= (len content) max-message-length) err-message-too-long)
    
    ;; Store the message
    (map-set user-messages 
      {user: user, message-id: message-id}
      {content: content, timestamp: stacks-block-height, likes: u0})
    
    ;; Update counters
    (map-set user-message-count user message-id)
    (var-set total-messages (+ (var-get total-messages) u1))
    
    ;; Print event for indexing
    (print {
      event: "message-posted",
      user: user,
      message-id: message-id,
      content: content,
      timestamp: stacks-block-height
    })
    
    (ok {message-id: message-id, timestamp: stacks-block-height})))

;; Function 2: Get a message by user and message ID
(define-read-only (get-message (user principal) (message-id uint))
  (match (map-get? user-messages {user: user, message-id: message-id})
    message-data (ok message-data)
    (err u404))) ;; Message not found

;; Additional read-only functions for utility
(define-read-only (get-user-message-count (user principal))
  (ok (default-to u0 (map-get? user-message-count user))))

(define-read-only (get-total-messages)
  (ok (var-get total-messages)))