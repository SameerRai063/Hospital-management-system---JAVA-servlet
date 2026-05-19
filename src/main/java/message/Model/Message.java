package message.Model;

import Conversation.Model.Conversation;
import User.Model.User;
import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "messages")
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "conversation_id", nullable = false)
    private int conversationId;

    @Column(name = "sender_id", nullable = false)
    private int senderId;

    @Column(name = "message_text", nullable = false, columnDefinition = "TEXT")
    private String messageText;

    @Column(name = "sent_at", insertable = false, updatable = false)
    private Timestamp sentAt;

    @Column(name = "is_read", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean isRead;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversation_id", insertable = false, updatable = false)
    private Conversation conversation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id", insertable = false, updatable = false)
    private User sender;

    // Constructors
    public Message() {}

    public Message(int conversationId, int senderId, String messageText) {
        this.conversationId = conversationId;
        this.senderId = senderId;
        this.messageText = messageText;
        this.isRead = false;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getMessageText() { return messageText; }
    public String getMessage() { return messageText; } // For backward compatibility
    public void setMessage(String message) { this.messageText = message; }
    public void setMessageText(String messageText) { this.messageText = messageText; }

    public Timestamp getSentAt() { return sentAt; }
    public Timestamp getCreatedAt() { return sentAt; } // For backward compatibility
    public void setCreatedAt(Timestamp sentAt) { this.sentAt = sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Conversation getConversation() { return conversation; }
    public void setConversation(Conversation conversation) { this.conversation = conversation; }

    public User getSender() { return sender; }
    public void setSender(User sender) { this.sender = sender; }
}