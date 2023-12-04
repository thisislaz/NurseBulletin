package net.thisislaz.hospitalreviews.services;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityNotFoundException;
import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;
import net.thisislaz.hospitalreviews.repositories.HospitalsRepository;
import net.thisislaz.hospitalreviews.repositories.ReviewsRepository;
import net.thisislaz.hospitalreviews.utils.StringUtils;

@Service
public class HospitalService {

	@Value("${csv.processed}")
	private boolean csvProcessed;
	
	private final HospitalsRepository hospitalRepository;
	private final ReviewsRepository reviewsRepository;
	private final StringUtils stringUtils;
	
	public HospitalService(HospitalsRepository hospitalsRepository, ReviewsRepository reviewsRepository, StringUtils stringUtils) {
		this.hospitalRepository = hospitalsRepository;
		this.reviewsRepository = reviewsRepository;
		this.stringUtils = stringUtils;
	}
	
	
	public List<Hospital> findAll() {
		return (List<Hospital>) hospitalRepository.findAll();
	}
	
	public Hospital getOne(Long id) {
		Optional<Hospital> hospital = hospitalRepository.findById(id);
		return hospital.isPresent() ? hospital.get() : null;
	}
	
	public Hospital findByName(String hospitalName) {
		return hospitalRepository.findFirstByHospitalName(hospitalName);
	}
	
	public Hospital findHospitalById(Long id) {
		Optional<Hospital> optionalHospital = hospitalRepository.findById(id);
		if(optionalHospital.isPresent()) {
			System.out.println(optionalHospital.get().getHospitalName());
			return optionalHospital.get();
		} else {
			throw new EntityNotFoundException("Hospital with id " + id + "not found");
		}
	}
	
	// this is for finding hospitals that have the word typed in the input field in their names
	public List<Hospital> findByNameContaining(String term) {
		return hospitalRepository.findByHospitalNameContaining(term);
	}
	
	// this is finding the hospital by its state
	public List<Hospital> findByState(String state) {
		return hospitalRepository.findByState(state);
	}

	//this is finding the hispital by its city.
	public List<Hospital> findByCity(String city) {
		return hospitalRepository.findByCity(city);
	}
	
	//this is handling the pagination
	public List<Hospital> getHospitalsForPage(List<Hospital> allHospitals, int pageNum, int pageSize) {
		int totalHospitals = allHospitals.size();
		int start = (pageNum - 1) * pageSize;
		int end = Math.min(start + pageSize, totalHospitals);
		
		if (start > totalHospitals) {
			return Collections.emptyList();
		}
		
		return allHospitals.subList(start, end);
	}
	
	// this reads the hospital fill that comes from the government website.
	 public List<Hospital> readHospitalsFromCSV() {
	        if (!csvProcessed) {
	            List<Hospital> hospitals = new ArrayList<>();

	            try (InputStream inputStream = getClass().getResourceAsStream("/Hospital_General_Information.csv");
	                 BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {

	                String line;
	                while ((line = br.readLine()) != null) {
	                    line = line.replaceAll("\"(.*?)\",", "$1 ");
	                    String[] values = line.split(",");
	                    if (values.length >= 2) {
	                        Hospital hospital = new Hospital(values[0], values[1], values[2], values[3], values[4], values[5], values[8], values[9]);
	                        List<Hospital> existingHospitals = (List<Hospital>) hospitalRepository.findByHospitalName(hospital.getHospitalName());
	                        if (existingHospitals.isEmpty()) {
	                            hospitals.add(hospital);
	                            hospitalRepository.save(hospital);
	                        }
	                    }
	                }
	                csvProcessed = true;
	            } catch (IOException ioe) {
	                ioe.printStackTrace();
	            }
	            return hospitals;
	        } else {
	            Iterable<Hospital> hospitalsIterable = hospitalRepository.findAll();
	            return StreamSupport.stream(hospitalsIterable.spliterator(), false)
	                    .collect(Collectors.toList());
	        }
	    }
	
	public List<Hospital> getHospitalsReviewedByUser(Long userID) {
	    List<Review> reviews = reviewsRepository.findByAuthorId(userID);
	    
	    List<Hospital> noDubsList = new ArrayList<>();
	    
	    for (Review review : reviews) {
	    	Hospital hospital = review.getHospital();
	    	if (hospital != null && !stringUtils.containsHospitalByName(noDubsList, hospital.getHospitalName())) {
	    		noDubsList.add(hospital);
	    	}
	    }
	    
	    return noDubsList;
	}
	
}