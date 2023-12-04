package net.thisislaz.hospitalreviews.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.OptionalDouble;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;
import net.thisislaz.hospitalreviews.services.HospitalService;
import net.thisislaz.hospitalreviews.services.ReviewService;

@Controller
@RequestMapping("/hospitals")
public class HospitalController {

	
	private final HospitalService hospitalService;
	private final ReviewService reviewService;
	public HospitalController(HospitalService hospitalService, ReviewService reviewService) {
		this.hospitalService = hospitalService;
		this.reviewService = reviewService;
	}
	
	@GetMapping("/allHospitals")
	public String viewAllHospitals(@RequestParam(name = "searchType", required = false) String searchType,
	                               @RequestParam(name = "searchValue", required = false) String searchValue,
	                               Model model) {

	    List<Hospital> hospitals = new ArrayList<>();

	    if (searchType != null && searchValue != null) {
	        switch (searchType) {
	            case "state":
	                hospitals = hospitalService.findByState(searchValue);
	                break;
	            case "hospitalName":
	                hospitals = hospitalService.findByNameContaining(searchValue);
	                break;
	            case "city":
	                hospitals = hospitalService.findByCity(searchValue);
	                break;
	        }
	    }

	    model.addAttribute("hospitalList", hospitals);

	    return "views/allHospitals";
	}

	@GetMapping("/view/{id}")
	public String viewHospital(@PathVariable("id") Long id, HttpSession session, Model model) {
		 
		if(session.getAttribute("userId") == null) {
			return "redirect:/user/login";
		}
		
		Hospital hospital = hospitalService.getOne(id);
		List<Review> reviews = reviewService.findReviewsBelongingToHospitalByHospitalNameOrderedByDateDesending(hospital.getHospitalName()); // Fetch the reviews using the ReviewService
		
		// get the average rating
		OptionalDouble averageRatingOpt = reviewService.getAverageRatingForHospital(hospital.getHospitalName());
		
		double averageRating = averageRatingOpt.isPresent() ? averageRatingOpt.getAsDouble() : 0;
		
		//this is rounding the average to the nears tenth
		averageRating = Math.round(averageRating * 10.0)/ 10.0;
		
		model.addAttribute("hospital", hospital);
		model.addAttribute("reviews", reviews);
		model.addAttribute("averageRating", averageRating);
		return "views/hospitalDetails";
	}
	
	@GetMapping("/hospitalNames")
	@ResponseBody
	public List<String> getHospitalNames(){
		  List<Hospital> hospitals = hospitalService.readHospitalsFromCSV();
		  return hospitals.stream().map(Hospital::getHospitalName).collect(Collectors.toList());
	}
	
	@GetMapping("/search")
	public List<Hospital> getHospitalsForReview(@RequestParam("term") String term) {
		return hospitalService.findByNameContaining(term);
	}
	
	
	
}
