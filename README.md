# On-Chain Notes/Message Board

## Project Description

Store short public messages on-chain. This Clarity smart contract enables users to post and retrieve short messages (up to 280 characters) directly on the Stacks blockchain, creating a decentralized message board where all content is permanently stored and publicly accessible.

## Features

- **Decentralized Messaging**: All messages are stored directly on the blockchain
- **Character Limit**: Twitter-like 280 character limit per message
- **Permanent Storage**: Messages cannot be deleted once posted
- **Timestamping**: Each message includes the block height when it was posted
- **User Tracking**: Track how many messages each user has posted
- **Public Access**: Anyone can read any message on the board

## Contract Functions

### Core Functions

#### `post-message`
```clarity
(post-message (content (string-utf8 280)))
```
- **Description**: Posts a new message to the on-chain message board
- **Parameters**: 
  - `content`: The message content (1-280 characters)
- **Returns**: `{message-id: uint, timestamp: uint}` on success
- **Access**: Public (anyone can post)
- **Validation**: 
  - Message must not be empty
  - Message must be ≤ 280 characters

#### `get-message`
```clarity
(get-message (user principal) (message-id uint))
```
- **Description**: Retrieves a specific message by user and message ID
- **Parameters**: 
  - `user`: The principal address of the message author
  - `message-id`: The unique ID of the message for that user
- **Returns**: `{content: string-utf8, timestamp: uint, likes: uint}` on success
- **Access**: Read-only (anyone can read)

### Utility Functions

#### `get-user-message-count`
```clarity
(get-user-message-count (user principal))
```
- **Description**: Gets the total number of messages posted by a specific user
- **Access**: Read-only

#### `get-total-messages`
```clarity
(get-total-messages)
```
- **Description**: Gets the total number of messages on the entire message board
- **Access**: Read-only

## Usage Examples

### Posting a Message
```clarity
;; Post a message
(contract-call? .message-board post-message u"Hello, blockchain world!")
;; Returns: (ok {message-id: u1, timestamp: u1000})
```

### Reading a Message
```clarity
;; Get the first message from a user
(contract-call? .message-board get-message 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM u1)
;; Returns: (ok {content: u"Hello, blockchain world!", timestamp: u1000, likes: u0})
```

### Check Message Count
```clarity
;; Get total messages from a user
(contract-call? .message-board get-user-message-count 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; Returns: (ok u5)
```

## Data Structures

### Message Storage
Messages are stored in a map with the following structure:
- **Key**: `{user: principal, message-id: uint}`
- **Value**: `{content: (string-utf8 280), timestamp: uint, likes: uint}`

### User Tracking
- `user-message-count`: Tracks how many messages each user has posted
- `total-messages`: Global counter for all messages on the board

## Error Codes

- `u100`: Message too long (exceeds 280 characters)
- `u101`: Message is empty
- `u404`: Message not found

## Events

The contract emits events when messages are posted for easier indexing:
```clarity
{
  event: "message-posted",
  user: principal,
  message-id: uint,
  content: string-utf8,
  timestamp: uint
}
```

## Deployment

1. Deploy the contract to the Stacks blockchain
2. The contract is immediately ready for use
3. No initialization required

## Security Considerations

- Messages are permanent and cannot be modified or deleted
- All messages are publicly readable
- No content moderation mechanisms built-in
- Users should be mindful of what they post as it will be permanently on-chain

## Future Enhancements

- Like/reaction system (partially implemented)
- Message threading/replies
- Content categories or tags
- User profiles and reputation system
- Message search functionality
