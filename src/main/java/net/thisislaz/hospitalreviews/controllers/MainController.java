package net.thisislaz.hospitalreviews.controllers;

import java.util.List;
import java.util.Map;

import org.hibernate.internal.util.beans.BeanInfoHelper.ReturningBeanInfoDelegate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;
import net.thisislaz.hospitalreviews.models.User;
import net.thisislaz.hospitalreviews.services.DiscussionService;
import net.thisislaz.hospitalreviews.services.HospitalService;
import net.thisislaz.hospitalreviews.services.ReviewService;
import net.thisislaz.hospitalreviews.services.UserService;
import net.thisislaz.hospitalreviews.utils.StringUtils;

@Controller
public class MainController {

	public final UserService userService;
	public final ReviewService reviewService;
	public final HospitalService hospitalService;
	public final DiscussionService discussionService;
	
	public MainController(UserService userService, ReviewService reviewService, HospitalService hospitalService, DiscussionService discussionService) {
		this.userService = userService;
		this.reviewService = reviewService;
		this.hospitalService = hospitalService;
		this.discussionService = discussionService;
	}
	
	@GetMapping("/register")
	public String indexRegisterPage() {
		return "redirect:/user/register";
	}
	
	@GetMapping("/dashboard")
	public String loginRegisteredUser(HttpSession session, Model model, HttpServletRequest request) {
		if(session.getAttribute("userId") == null) {
			return "redirect:/";
		}

		Long userId = (Long) session.getAttribute("userId");
		
		// Check for a null user
	    User user = userService.getUser(userId);
	    if (user == null) {
	        // handle this case, perhaps redirect with an error message
	        return "redirect:/";
	    }
		model.addAttribute("user", user);
	    model.addAttribute("signedInUser", userService.getUser((Long) session.getAttribute("userId")));
		model.addAttribute("reviewList", reviewService.getAll());
		model.addAttribute("recent5ReviewList", reviewService.getMostRecentReviews());
		
		Map<Hospital, Long> hospitalReviewCountsSorted = reviewService.getHospitalReviewCountsSorted();
	    model.addAttribute("hospitalReviewCountsSorted", hospitalReviewCountsSorted);
	    
	    model.addAttribute("noDuplicates", hospitalService.getHospitalsReviewedByUser(userId));
	    
	    //when rendering the page initially
	    model.addAttribute("userReviews", reviewService.getReviewsByUserIdWithLimit(userId, 0, 4));
	    
	    //this is adding the 5 most recent threads
	    model.addAttribute("recentDiscussions", discussionService.getMostRecentDiscussions());
	    
		return "views/dashboard";
	}
	
	@GetMapping("/loadMoreReviews")
	public ResponseEntity<List<Review>> loadMoreReviews(@RequestParam("skip") int skip, HttpSession session) {
		Long userId = (Long) session.getAttribute("userId");
		List<Review> nextReviews = reviewService.getReviewsByUserIdWithLimit(userId, skip, 4);
	
		return ResponseEntity.ok(nextReviews);
	}
	
	@GetMapping("/")
	public String indexLandingPage(Model model, HttpSession session) {
		List<String> formattedDates = StringUtils.fortmatCreatedAtDates(reviewService.getAll());
		model.addAttribute("fortmattedDates" , formattedDates);
		
		model.addAttribute("reviewList", reviewService.getAll());
		
		
		return "views/index";
	}
	
	
	
}
