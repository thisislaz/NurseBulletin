package net.thisislaz.hospitalreviews.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;
import net.thisislaz.hospitalreviews.services.HospitalService;
import net.thisislaz.hospitalreviews.services.ReviewService;
import net.thisislaz.hospitalreviews.utils.StringUtils;

@Controller
@RequestMapping("/review")
public class ReviewController {

	public final ReviewService reviewService;
	public final HospitalService hospitalService;
	public ReviewController(ReviewService reviewService, HospitalService hospitalService) {
		this.reviewService = reviewService;
		this.hospitalService = hospitalService;
	}
	
	
	@GetMapping("/new")
	public String newReview(@ModelAttribute("review") Review review, HttpSession session, Model model) {
		if(session.getAttribute("userId") == null) {
			return "redirect:/";
		}
		
		List<Hospital> hospitals = hospitalService.findAll();
		model.addAttribute("hospitals", hospitals);
		
		return "views/createReview";
	}
	
	@PostMapping("/new")
	public String processNewReview(@Valid @ModelAttribute("review") Review review, BindingResult result
	     ) {
	    
	    if(result.hasErrors()) {
	        return "views/createReview";
	    }

	    String hospitalName = review.getHospital().getHospitalName();
	    
	    Hospital hospital = hospitalService.findByName(hospitalName);
	    
	    review.setHospital(hospital);
	    reviewService.createReview(review);

	    return "redirect:/dashboard";
	}

	
	@GetMapping("/view/{id}")
	public String viewReview(@PathVariable("id") Long id, HttpSession session, Model model, HttpServletRequest request ) {
		if(session.getAttribute("userId") == null ) {
			return "redirect:/user/login";
		}

		String formattedDate = StringUtils.fmCreatedAt(reviewService.getOne(id));
		model.addAttribute("fortmattedDate" , formattedDate);
		
		model.addAttribute("review", reviewService.getOne(id));
		return "views/viewReview";
		
	}
	
	@DeleteMapping("/delete/{id}")
	public String deleteReview(@PathVariable("id") Long id, HttpSession session) {
		if(session.getAttribute("userId") != reviewService.getOne(id).getAuthor().getId()) {
			return "redirect:/dashboard";
		}
		reviewService.deleteReview(id);
		return "redirect:/dashboard";
	}
	
	@GetMapping("/allReviews")
	public String viewAllReviews(@RequestParam(name = "searchType", required = false) String searchType,
	                             @RequestParam(name = "searchValue", required = false) String searchValue,
	                             Model model) {

	    List<Review> reviews = new ArrayList<>();

	    if (searchType != null && searchValue != null) {
	        switch (searchType) {
	            case "state":
	                reviews = reviewService.findByHospitalState(searchValue);
	                break;
	            case "hospitalName":
	                reviews = reviewService.findByHospitalNameContaining(searchValue);
	                break;
	            case "city":
	                reviews = reviewService.findByHospitalCity(searchValue);
	                break;
	            case "hospitalType":
	                reviews = reviewService.findByHospitalType(searchValue);
	                break;
	            case "recent":
	            	reviews = reviewService.getMostRecentReviews();
	        }
	    }

	    model.addAttribute("reviewList", reviews);

	    return "views/allReviews";
	}

	@GetMapping("/edit/{id}")
	public String editReview(@PathVariable("id") Long reviewId, HttpSession session, Model model ) {
		//fetching the loggedIn user's id from the sessionscope
		Long loggedInUserId = (Long) session.getAttribute("userId");
		Review reviewToEdit = reviewService.getOne(reviewId);
		List<Hospital> hospitals = hospitalService.findAll();
		
		//ensuring the user is logged in and theyy're editting their own review
		if(loggedInUserId == null || !loggedInUserId.equals(reviewService.getOne(reviewId).getAuthor().getId())) {
			// redirecting to dashboard so the ashboard controller handles if the user id loggedin or not
			return "redirect:/dashboard";
		}
		
		model.addAttribute("review",reviewToEdit);
		model.addAttribute("hospitals", hospitals);
		return "views/editReview";
		
	}
	
	@PutMapping("/edit/{id}")
	public String processEditedReview(@PathVariable("id") Long reviewId,
										@Valid @ModelAttribute("review") Review editedReview, 
										BindingResult result, HttpSession session, Model model) {
		
		if(result.hasErrors()) {
			return "views/editReview";
		}
		
		Long loggedInUserUserId = (Long) session.getAttribute("userId");
		Review reviewToEdit = reviewService.getOne(reviewId);
		List<Hospital> hospitals = hospitalService.findAll();
		
		if(loggedInUserUserId == null) {
			return "redirect:/user/login";
		} else if (loggedInUserUserId != reviewToEdit.getAuthor().getId()) {
			return "redirect:/";
		}

		try {
	        if(org.apache.commons.lang3.StringUtils.isBlank(editedReview.getHospitalName())) {
	            result.rejectValue("hospitalName", "error.hospitalName", "Please select a hospital from the list.");
	            model.addAttribute("hospitals", hospitals);
	            return "views/editReview";
	        }
	        Hospital hospital = hospitalService.findByName(editedReview.getHospitalName());
	        if(hospital == null) {
	            result.rejectValue("hospitalName", "error.hospitalName", "The hospital you selected does not exist. Try again.");
	            model.addAttribute("hospitals", hospitals);
	            return "views/editReview";
	        }
	        editedReview.setHospital(hospital);
	        editedReview.setAuthor(reviewToEdit.getAuthor());
	        reviewService.updateReview(editedReview);
	        model.addAttribute("hospitals", hospitals);
	    } catch (Exception e) {
	        result.rejectValue("hospitalName", "error.hospitalName", "An error occurred while updating the review: " + e.getMessage());
	        return "views/editReview";
	    }

	    return "redirect:/dashboard";
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
	