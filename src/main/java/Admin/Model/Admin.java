package Admin.Model;

import jakarta.persistence.*;
import User.Model.User;

import java.sql.Timestamp;

@Entity
@Table(name = "admin")
public class Admin {

    @Id
    @Column(name = "user_id")
    private int userId;

    @Column(name = "last_login")
    private Timestamp lastLogin;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Timestamp createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private Timestamp updatedAt;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    // Constructors
    public Admin() {}

    public Admin(int userId) {
        this.userId = userId;
    }

    public Admin(User user) {
        this.user = user;
        this.userId = user.getId();
    }

    // Getters & Setters

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public User getUser() { return user; }
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }
}