package net.thisislaz.hospitalreviews.models;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class Hospital {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	private String facilityId;
	private String hospitalName;
	private String address;
	private String city; 
	private String state;
	private String zipcode;
	private String hospitalType;
	private String ownership;
	
	@OneToMany(mappedBy = "hospital", fetch = FetchType.LAZY)
	private List<Review> reviews = new ArrayList<>();

	public Hospital () {}
	
	public Hospital (String facilityId, String hospitalName, String address, String city, String state, String zipcode, String hospitalType, String ownership) {
		this.facilityId = facilityId;
		this.hospitalName = hospitalName;
		this.address = address;
		this.city = city;
		this.state = state;
		this.zipcode = zipcode;
		this.hospitalType = hospitalType;
		this.ownership = ownership;
	}
	
	public Hospital (String hospitalName) {
		this.hospitalName = hospitalName;
	}
	
// --------           methods              -------------
	
	public void addReview(Review review) {
		reviews.add(review);
		review.setHospital(this);
	}
	
	public int getReviewCount() {
		return reviews.size();
	}
	
	
//	--------          getters and setters          ----------
	
	public String getHospitalName() {
		return hospitalName;
	}

	public void setHospitalName(String hospitalName) {
		this.hospitalName = hospitalName;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

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

	public String getFacilityId() {
		return facilityId;
	}

	public void setFacilityId(String facilityId) {
		this.facilityId = facilityId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getHospitalType() {
		return hospitalType;
	}

	public void setHospitalType(String hospitalType) {
		this.hospitalType = hospitalType;
	}

	public String getOwnership() {
		return ownership;
	}

	public void setOwnership(String ownership) {
		this.ownership = ownership;
	}
	
}