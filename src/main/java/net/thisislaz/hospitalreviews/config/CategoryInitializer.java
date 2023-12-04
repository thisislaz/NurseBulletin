package net.thisislaz.hospitalreviews.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import net.thisislaz.hospitalreviews.models.Category;
import net.thisislaz.hospitalreviews.repositories.CategoryRepository;

@Component
public class CategoryInitializer {

	private CategoryRepository categoryRepository;
	
	public CategoryInitializer(CategoryRepository categoryRepository) {
		this.categoryRepository = categoryRepository;
	}
	
	@PostConstruct
	public void initCategorires() {
		if (categoryRepository.count() == 0) {
			List<Category> initialCategories = Arrays.asList(
		            new Category("Introductions", "New users can introduce themselves, share their experience, and what they're hoping to gain from the forum."),
		            new Category("General Discussion", "A catch-all for various topics related to travel nursing that don't fit into specialized categories."),
		            new Category("Hospital Reviews Discussion", "Users can discuss specific reviews, ask questions about hospitals, or share experiences that don't fit into the review format."),
		            new Category("Travel Tips & Advice", "Share tips on traveling, from best airlines to baggage advice specific to nurses' needs."),
		            new Category("Accommodations & Housing", "Discuss housing options, seek roommates, or share experiences with different accommodation providers."),
		            new Category("Job Opportunities & Contracts", "Discuss job openings, contract terms, agencies, and other employment-related topics."),
		            new Category("Off-topic", "For discussions not related to travel nursing. Helps build community camaraderie."),
		            new Category("Site Feedback & Help", "Users can suggest site improvements, report issues, or seek help using the website.")
		        );
			categoryRepository.saveAll(initialCategories);
		}
	}
	
}
