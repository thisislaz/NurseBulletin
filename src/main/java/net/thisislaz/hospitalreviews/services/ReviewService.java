package net.thisislaz.hospitalreviews.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.OptionalDouble;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;
import net.thisislaz.hospitalreviews.repositories.HospitalsRepository;
import net.thisislaz.hospitalreviews.repositories.ReviewsRepository;

@Service
public class ReviewService {
	
	public final HospitalService hospitalService;
	public final HospitalsRepository hospitalRepo;
	public final ReviewsRepository reviewRepo;
	
	public ReviewService(ReviewsRepository reviewRepo, HospitalService hospitalService, HospitalsRepository hospitalRepo) {
		this.reviewRepo = reviewRepo;
		this.hospitalService = hospitalService;
		this.hospitalRepo = hospitalRepo;
	}
	
	public Review getOne(Long id) {
		Optional<Review> review = reviewRepo.findById(id);
		return review.isPresent() ? review.get() : null;
	}
	
	public List<Review> getAll() {
		return (List<Review>) reviewRepo.findAll();
	}
	
	public List<Review> getMostRecentReviews() {
		return reviewRepo.findTop5ByOrderByCreatedAtDesc();
	}
	
	public Review createReview(Review review) {
		Hospital hospital = hospitalService.findByName(review.getHospitalName());
		review.setHospital(hospital);
		return reviewRepo.save(review);
	}
	
	public Review updateReview(Review review) {
		if(StringUtils.isBlank(review.getHospitalName())) {
			throw new IllegalArgumentException("Please select a hospital from the list.");
		}
		Hospital hospital = hospitalService.findByName(review.getHospitalName());
		if(hospital == null) {
			throw new IllegalArgumentException("Hospital not found with name: "+review.getHospitalName()+". Please check your spelling or provide a hospital's name if you did not do so.");
		}
		review.setHospital(hospital);
		review.setHospitalName(hospital.getHospitalName());
		
		return reviewRepo.save(review);
	}
	
	public void deleteReview(Long id) {
		reviewRepo.deleteById(id);
	}
	
	//this is finding the reviews associated with the hospital and ordering them by most recent first
	public List<Review> findReviewsBelongingToHospitalByHospitalNameOrderedByDateDesending(String hospitalName) {
		List<Review> createdAtSortList = reviewRepo.findByHospitalHospitalNameOrderByCreatedAtDesc(hospitalName);
		List<Review> updateAtSortList = reviewRepo.findByHospitalHospitalNameOrderByUpdatedAtDesc(hospitalName);
		
		//combining the lists into a set so the duplicates get removed
		Set<Review> combinedReviews = new HashSet<>();
		combinedReviews.addAll(createdAtSortList);
		combinedReviews.addAll(updateAtSortList);
		
		//converting the set to a list for sorting
		List<Review> combinedList = new ArrayList<>(combinedReviews);
		
		//sorting the combined list by the mnost recent date(either createdat or updated)
	    Collections.sort(combinedList, (review1, review2) -> {
	        LocalDateTime mostRecent1 = net.thisislaz.hospitalreviews.utils.StringUtils.getMaxDate(review1.getCreatedAt(), review1.getUpdatedAt());
	        LocalDateTime mostRecent2 = net.thisislaz.hospitalreviews.utils.StringUtils.getMaxDate(review2.getCreatedAt(), review2.getUpdatedAt());
	        return mostRecent2.compareTo(mostRecent1); // Descending order
	    });

	    return combinedList;
	}

	//finding by hospital's state for the allReviews search
	public List<Review> findByHospitalState(String state) {
		return reviewRepo.findByHospitalState(state);
	}
	
	//finding the hospital's review by the hospitals name for the allreviews search
	public List<Review> findByHospitalName(String hospitalName) {
		return reviewRepo.findByHospitalHospitalName(hospitalName);
	}
	
	//finding the hospital's name that contains partial name of the hospital
	public List<Review> findByHospitalNameContaining(String partialName) {
		return reviewRepo.findByHospitalHospitalNameContaining(partialName);
	}
	
	//find the hospital's review by state from the allReviews Search
	public List<Review> findByHospitalCity(String city) {
		return reviewRepo.findByHospitalCity(city);
	}
	
	//finding the hospital reviews that have the matching hospital type for the all reviews search
	public List<Review> findByHospitalType(String hospitalType){
		return reviewRepo.findByHospitalHospitalType(hospitalType);
	}
	
	public List<Review> getReviewsByUserId(Long userId) {
		return reviewRepo.findByAuthorIdNot(userId);
	}
	
	public Map<Hospital, List<Review>> getUserReviewsWithHospital(Long userId) {
		List<Review> userReviews = getReviewsByUserId(userId);

		// Filter the reviews to get a list of hospitals the user has reviewed
		List<Hospital> hospitalsReviewedByUser = userReviews.stream()
															.map(Review::getHospital)
															.distinct()
															.collect(Collectors.toList());

		Map<Hospital, List<Review>> result = new HashMap<>();
		for (Hospital hospital : hospitalsReviewedByUser) {
			List<Review> reviewsForHospital = userReviews.stream()
														 .filter(review -> review.getHospital().equals(hospital))
														 .collect(Collectors.toList());
			result.put(hospital, reviewsForHospital);
		}

		return result;
	}
	
	public Map<Long, Long> getHospitalReviewCount() {
		List<Map<String, Object>> data = hospitalRepo.findAllWithReviewCount();
		Map<Long, Long> counts = new HashMap<>();
		for (Map<String, Object> entry : data) {
			Hospital hospital = (Hospital) entry.get("hospital");
			Long count = (Long) entry.get("reviewCount");
			counts.put(hospital.getId(), count);
		}
		return counts;
	}
	
	public Map<Hospital, Long> getHospitalReviewCountsNotByAuthor(Long authorId) {
        // Fetch all reviews excluding those from the specified author
        List<Review> reviewsExcludingAuthor = reviewRepo.findByAuthorIdNot(authorId);

        // Group the reviews by hospital and count them
        return reviewsExcludingAuthor.stream()
            .collect(Collectors.groupingBy(Review::getHospital, Collectors.counting()));
    }
	
	public Map<Hospital, Long> getHospitalReviewCountsNotByAuthorSorted(Long authorId) {
        // Fetch all reviews excluding those from the specified author
        List<Review> reviewsExcludingAuthor = reviewRepo.findByAuthorIdNot(authorId);

        // Group the reviews by hospital, count them, and then sort by review count in descending order
        return reviewsExcludingAuthor.stream()
            .collect(Collectors.groupingBy(Review::getHospital, Collectors.counting()))
            .entrySet()
            .stream()
            .sorted(Map.Entry.<Hospital, Long>comparingByValue().reversed())
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                Map.Entry::getValue,
                (e1, e2) -> e1,
                LinkedHashMap::new
            ));
    }
	
	public Map<Hospital, Long> getHospitalReviewCountsSorted() {
	    // Fetch all reviews
	    List<Review> allReviews = getAll();

	    // Group the reviews by hospital, count them
	    Map<Hospital, Long> reviewCounts = allReviews.stream()
	        .collect(Collectors.groupingBy(Review::getHospital, Collectors.counting()));

	    // Sort the map by review count in descending order
	    return reviewCounts.entrySet().stream()
	        .sorted(Map.Entry.<Hospital, Long>comparingByValue().reversed()
	        //this part is handling the sorting by hospitalName
	        .thenComparing(e -> e.getKey().getHospitalName()))
	        // the limit part stops the list from going beyond 5 hospitals
	        .limit(5)
	        .collect(Collectors.toMap(
	            Map.Entry::getKey, 
	            Map.Entry::getValue,
	            (e1, e2) -> e1, 
	            LinkedHashMap::new));
	}

	//this is to get the average between the hospital's reviews amd display back at the user without saving to db
	public OptionalDouble getAverageRatingForHospital(String hospitalName) {
		List<Review> reviews = findReviewsBelongingToHospitalByHospitalNameOrderedByDateDesending(hospitalName);
		
		return reviews.stream()
				.mapToDouble(Review::getRating)
				.average();
	}
	
	//this method gets a given number of reviews for a user after skipping a certain number
	public List<Review> getReviewsByUserIdWithLimit(Long userId, int skip, int limit) {
		List<Review> allUserReviews = reviewRepo.findByAuthorId(userId);
		
		return allUserReviews.stream()
				.skip(skip)
				.limit(limit)
				.collect(Collectors.toList());
	}
	
}
