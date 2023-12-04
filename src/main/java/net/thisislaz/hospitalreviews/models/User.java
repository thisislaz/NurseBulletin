package net.thisislaz.hospitalreviews.models;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import net.thisislaz.hospitalreviews.validation.OnCreate;

@Entity
@Table(name="users")
public class User {

		@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;
	    
	    @NotNull(message="First name is required!",groups = OnCreate.class)
	    @Size(min=1, max=40, message="First name must be less than 40 characters",groups = OnCreate.class)
	    private String firstName;
	    
	    @NotNull(message="Last name is required!",groups = OnCreate.class)
	    @Size(min=1, max=40, message="Last name must be less than 40 characters",groups = OnCreate.class)
	    private String lastName;
	    
	    @NotEmpty(message="Email is required!",groups = OnCreate.class)
	    @Email(message="Please enter a valid email!",groups = OnCreate.class)
	    private String email;
	    
	    @NotNull(message="Password is required!",groups = OnCreate.class)
	    @Size(min=8, max=128, message="Password must be between 8 and 128 characters",groups = OnCreate.class)
	    private String password;
	    
	    @Transient
	    @NotNull(message="Confirm Password is required!", groups = OnCreate.class)
	    @Size(min=8, max=128, message="Confirm Password must match.", groups = OnCreate.class)
	    private String confirm;
	
	    // This will not allow the createdAt column to be updated after creation
	    @Column(updatable = false)
	    private LocalDateTime createdAt;
		
	    @Column(updatable = false)
	    private LocalDateTime updatedAt;

	    @PrePersist // adds the created at localdatatime to sql on creation
	    protected void onCreate() {
	        this.createdAt = LocalDateTime.now();
	    }

	    @PreUpdate // add the updated at localdatetime when being updated
	    protected void onUpdate() {
	        this.updatedAt = LocalDateTime.now();
	    }

	    @NotNull(message = "Username is required!")
	    @Size(min=3, max=60, message="Username must be less than 60 characters",groups = OnCreate.class)
	    private String username;
	    
	    //profile picture will default to initials if one isnt choosen on signup
	    private String profilePicture;
	    
	    public User() {}

	    @OneToMany(mappedBy = "author", fetch = FetchType.LAZY)
	    private List<Review> reviews;
	    
		public List<Review> getReviews() {
			return reviews;
		}

		public void setReviews(List<Review> reviews) {
			this.reviews = reviews;
		}

		public Long getId() {
			return id;
		}

		public void setId(Long id) {
			this.id = id;
		}

		public String getFirstName() {
			return firstName;
		}

		public void setFirstName(String firstName) {
			this.firstName = firstName;
		}

		public String getLastName() {
			return lastName;
		}

		public void setLastName(String lastName) {
			this.lastName = lastName;
		}

		public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public String getPassword() {
			return password;
		}

		public void setPassword(String password) {
			this.password = password;
		}

		public String getConfirm() {
			return confirm;
		}

		public void setConfirm(String confirm) {
			this.confirm = confirm;
		}

		public LocalDateTime getCreatedAt() {
			return createdAt;
		}

		public void setCreatedAt(LocalDateTime createdAt) {
			this.createdAt = createdAt;
		}

		public LocalDateTime getUpdatedAt() {
			return updatedAt;
		}

		public void setUpdatedAt(LocalDateTime updatedAt) {
			this.updatedAt = updatedAt;
		}
		
		public String getUsername() {
	        return username;
	    }

	    public void setUsername(String username) {
	        this.username = username;
	    }

	    public String getProfilePicture() {
	        return profilePicture;
	    }

	    public void setProfilePicture(String profilePicture) {
	        this.profilePicture = profilePicture != null && !profilePicture.isEmpty() 
	                              ? profilePicture 
	                              : this.firstName.substring(0, 1).toUpperCase() + this.lastName.substring(0, 1).toUpperCase();
	    }

	    

}
