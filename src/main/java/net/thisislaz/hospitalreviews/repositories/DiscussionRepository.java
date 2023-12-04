package net.thisislaz.hospitalreviews.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import net.thisislaz.hospitalreviews.models.Discussion;
import net.thisislaz.hospitalreviews.models.User;
import net.thisislaz.hospitalreviews.models.Category;


public interface DiscussionRepository extends CrudRepository<Discussion, Long> {

	Optional<Discussion> findById(Long discussionId);
	
	List<Discussion> findTop5ByOrderByCreatedAtDesc();
	
	List<Discussion> findByTitle(String title);
	
	List<Discussion> findByTitleContainingIgnoreCase(String title);
	
	List<Discussion> findByDescriptionContainingIgnoreCase(String searchValue);
	
	List<Discussion> findByAuthorUsername(String authorUsername);
	
	List<Discussion> findByCategoryId(Long categoryId);
	
}
