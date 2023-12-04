package net.thisislaz.hospitalreviews.models;


import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name="reviews")
public class Review {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	@NotBlank(message = "Please provide some sort of title.")
    @Size(min = 3, max = 100, message = "Title must be within 3 - 60 characters.")
    private String title;
	
	@NotBlank(message = "Please provide a short summary of your experience.")
    @Size(min = 3, max = 500, message = "Summary must be less than 500 characters.")
    private String content;
	
	@NotNull(message = "Please rate your experience 1-5.")
	@Min(value = 1, message = "Ratings must be from 1 to 5.")
	@Max(value = 5, message = "Ratings must be from 1 to 5.")
	private Double rating;
	
	@NotBlank(message = "Please provide the unit in which you worked.")
	@Size(min=2, max=60, message = "Name of unit must be at least 2 characters long.")
	private String unitWorkedAt;
	
	@NotBlank(message = "Please choose a nurse to patient ratio.")
	private String patientRatio;
	
	@NotBlank(message = "Please provide the charting system used.")
	@Size(max=100, message = "Charting system's name should be less than 100 characters.")
	private String chartingSystem;
	
	@NotBlank(message = "Please provide an asnwer(yes or no).")
	private String wouldReturn;
	
	@NotNull(message = "Please rate your experience with management via a 1-5.")
	@Min(value = 1, message = "Ratings must be from 1 to 5.")
	@Max(value = 5, message = "Ratings must be from 1 to 5.")
	private Double managementRating;
	
	// This will not allow the createdAt column to be updated after creation
    @Column(updatable = false)
    private LocalDateTime createdAt;
	
    @Column(updatable = true)
    private LocalDateTime updatedAt;

    @PrePersist // adds the created at localdatatime to sql on creation
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    @PreUpdate // add the updated at localdatetime when being updated
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public Review() {}
    
    @NotNull(message = "A hospital must be associated with the review.")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hospitalId")
    private Hospital hospital;
    
    // this is so the name does not get stored in the db
    @Transient
    private String hospitalName;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="author_id")
	private User author;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Double getRating() {
		return rating;
	}

	public void setRating(Double rating) {
		this.rating = rating;
	}

	public String getUnitWorkedAt() {
		return unitWorkedAt;
	}

	public void setUnitWorkedAt(String unitWorkedAt) {
		this.unitWorkedAt = unitWorkedAt;
	}

	public String getPatientRatio() {
		return patientRatio;
	}

	public void setPatientRatio(String patientRatio) {
		this.patientRatio = patientRatio;
	}

	public String getChartingSystem() {
		return chartingSystem;
	}

	public void setChartingSystem(String chartingSystem) {
		this.chartingSystem = chartingSystem;
	}

	public String getWouldReturn() {
		return wouldReturn;
	}

	public void setWouldReturn(String wouldReturn) {
		this.wouldReturn = wouldReturn;
	}

	public Double getManagementRating() {
		return managementRating;
	}

	public void setManagementRating(Double managementRating) {
		this.managementRating = managementRating;
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

	public User getAuthor() {
		return author;
	}

	public void setAuthor(User author) {
		this.author = author;
	}

	public Hospital getHospital() {
		return hospital;
	}

	public void setHospital(Hospital hospital) {
		this.hospital = hospital;
	}

	public String getFormattedDate() {
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
	    if(this.updatedAt == null) {
	    	return this.createdAt.format(formatter);
	    } else {
	    	return this.updatedAt.format(formatter);
	    }
	}
	
	public String getHospitalName() {
		return hospitalName;
	}

	public void setHospitalName(String hospitalName) {
		this.hospitalName = hospitalName;
	}

}
