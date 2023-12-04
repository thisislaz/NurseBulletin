package net.thisislaz.hospitalreviews.utils;

import java.text.DateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;


import org.springframework.stereotype.Component;

import net.thisislaz.hospitalreviews.models.Comment;
import net.thisislaz.hospitalreviews.models.Discussion;
import net.thisislaz.hospitalreviews.models.Hospital;
import net.thisislaz.hospitalreviews.models.Review;

@Component
public class StringUtils {
	
	/**
	 * Helper method to get the most recent date between two dates.
	 * 
	 * @param date1 The first LocalDateTime object to compare.
	 * @param date2 The second LocalDateTime object to compare.
	 * @return The most recent date among the two provided dates.
	 */
	public static LocalDateTime getMaxDate(LocalDateTime date1, LocalDateTime date2) {
	    // If the first date is null, the second date is returned by default,
	    // as there's nothing to compare it with.
	    if (date1 == null) return date2;

	    // Similarly, if the second date is null, the first date is returned.
	    if (date2 == null) return date1;

	    // If both dates are not null, compare them:
	    // - If date1 is after date2, it means date1 is more recent, so return date1.
	    // - Otherwise, return date2, which means date2 is either more recent or both dates are equal.
	    return date1.isAfter(date2) ? date1 : date2;
	}

	
	/**
	 * Capitalize the first letter of every word in a string.
	 * 
	 * @param text the original string
	 * @return the transformed string with every word capitalized
	 * 
	 */
	
	public static String capitalizeWords(String text) {
		String[] words = text.split(" ");
		
		for (int i = 0; i < words.length; i++ ) {
			String word = words[i];
			words[i] = word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
		}
		
		return String.join(" ", words);
	}
	
	
	/**
	 * Change the createdAt timestamp to a new pattern of "hh:mm a MM/dd/yyyy" .
	 * 
	 * @param List<Review> the full list of Review objects
	 * @return the transformed Review list with the createdAt timestamp with a new time pattern
	 * 
	 */
	
	public static List<String> fortmatCreatedAtDates(List<Review> reviews) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		List<String> formattedDates = new ArrayList<>();
		
		for (Review review : reviews) {
			String formattedDate = review.getCreatedAt().toLocalDate().format(formatter);
			formattedDates.add(formattedDate);
		}
		
		return formattedDates;
 		
	}
	
	/**
	 * change the createdat timestamp of each comment to a new string pattern of "MM/dd/yyyy"
	 * 
	 * @param comments the full list of Comment objects
	 * @return the transformed list of comments with the createat timestamp in a new date pattern
	 * 
	 */

	public static List<String> formattedCommentDates(List<Comment> comments) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		List<String> formattedDates = new ArrayList<>();
		
			for (Comment comment : comments) {
				if(comment.getUpdatedAt() == null) {
					
					String formattedDateString = comment.getCreatedAt().toLocalDate().format(formatter);
					formattedDates.add(formattedDateString);
				} else {
					String formattedDateString = comment.getUpdatedAt().toLocalDate().format(formatter);
					formattedDates.add(formattedDateString);
				}
			}
				
		return formattedDates;
	}
	
	/**
	 * Change the createat timestampe of each comment to a new pattern of "hh:mm am or pm"
	 * 
	 * @param comments the full list of Comment objects belonging to this discussion
	 * @return the transformed list of comments with the createAt value set to ONLY TIME NOT DATE
	 * 
	 */
	
	public static List<String> fortmattedCommentTimes(List<Comment> comments) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");
		List<String> formattedTimes = new ArrayList<>();
		
		for (Comment comment : comments) {
			
			if(comment.getUpdatedAt() == null) {
				
				String formattedTimeString = comment.getCreatedAt().toLocalTime().format(formatter);
				formattedTimes.add(formattedTimeString);
			} else {
				String formattedTimeString = comment.getUpdatedAt().toLocalTime().format(formatter);
				formattedTimes.add(formattedTimeString);
			}
			
		}
		return formattedTimes;
	}
	
	/**
	 * change the createat timestamp of a discussion to a new String pattern of "MM/dd/yyyy"
	 * 
	 * @param discussion the Discussion object
	 * @return the transformed Discussion object's createAt value
	 * 
	 */
	
	public static String fortmattedDiscussionCreateAtDate(Discussion discussion) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		String formattedDiscussionDate = discussion.getCreatedAt().toLocalDate().format(formatter);
		
		return formattedDiscussionDate;
	}

	/**
	 * Change the createdAt timestamp to a new pattern of "hh:mm a MM/dd/yyyy" .
	 * 
	 * @param Review object
	 * @return the transformed Review object with the createdAt timestamp with a new time pattern
	 * 
	 */
	
	public static String fmCreatedAt(Review review) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		String fortmattedDate = review.getCreatedAt().toLocalDate().format(formatter);
		
		return fortmattedDate;
	}
	
	
	public final boolean containsHospitalByName(List<Hospital> list, String hospitalName) {
		for (Hospital hospital : list) {
			if (hospital.getHospitalName().equals(hospitalName)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Calculate the time difference between teh eprovided timestamp and the current time.
	 * It returns a relatvie description of the time difference, e.g., " 5 minutes ago"
	 * 
	 * @param past The time to be compared with the current time
	 * @return A human-readable string indicating the time difference
	 */
	public static String timeAgo(LocalDateTime past) {
		//get the current time
		LocalDateTime now = LocalDateTime.now();
		
		//calculate the duration difference between the past and now
		Duration duration = Duration.between(past, now);
		
		//convert the duration to seconds for calculation
		long seconds = duration.getSeconds();
		
		//get the absolute value of seconds to avoid negative values
		long absSeconds = Math.abs(seconds);
		
		String agoText;
		// determine the appropriate time description based on the seconds difference
		if (absSeconds < 60) {
			agoText = absSeconds + " seconds ago";
		} else if (absSeconds < 3600) {
			agoText = absSeconds / 60 + " minutes ago";
		} else if (absSeconds < 86400) {
			agoText = absSeconds / 3600 + " hours ago";
		} else {
			agoText = absSeconds / 86400 + " days ago";
		}
		
		return agoText;
	}
	
	
	
	
	
}