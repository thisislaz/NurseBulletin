package net.thisislaz.hospitalreviews.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

import net.thisislaz.hospitalreviews.models.Discussion;
import net.thisislaz.hospitalreviews.models.Category;
import net.thisislaz.hospitalreviews.models.Comment;
import net.thisislaz.hospitalreviews.repositories.DiscussionRepository;
import net.thisislaz.hospitalreviews.utils.CommentDetails;
import net.thisislaz.hospitalreviews.utils.StringUtils;
import net.thisislaz.hospitalreviews.repositories.CommentRepository;

@Service
public class DiscussionService {

	public final DiscussionRepository discussionRepository;
	public final CommentRepository commentRepository;
	
	public DiscussionService(DiscussionRepository discussionRepository, CommentRepository commentRepository) {
		this.discussionRepository = discussionRepository;
		this.commentRepository = commentRepository;
	}
	
	public Discussion createDiscussion(Discussion discussion) {
		return discussionRepository.save(discussion);
	}
	
	public Comment createComment(Comment comment) {
		return commentRepository.save(comment);
	}
	
	public Optional<Comment> findByCommentId(Long id) {
		return commentRepository.findById(id);
	}
	
	public List<Discussion> getAllDiscussions() {
		return (List<Discussion>) discussionRepository.findAll();
	}
	
	public Optional<Discussion> getDiscussionById(Long id) {
		return discussionRepository.findById(id);
	}
	
	public List<Comment> getCommentsByOptionalDiscussion(Optional<Discussion> discussion) {
		return commentRepository.findByDiscussionOrderByCreatedAt(discussion);
	}
	
	public List<Comment> getCommentsByDiscussion(Discussion discussion) {
		return commentRepository.findByDiscussionOrderByCreatedAt(discussion);
	}
	
	public Comment updateComment(Comment commentToEdit) {
		return commentRepository.save(commentToEdit);
	}
	
	public void deleteCommentFromDiscussion(Optional<Comment> commentToDelete) {
		commentRepository.deleteById(commentToDelete.get().getId());
	}
	
	public void deleteDiscussionAndComments(Optional<Discussion> discussionToDelete) {
		discussionRepository.deleteById(discussionToDelete.get().getId());
	}
	
	public List<Discussion> getMostRecentDiscussions() {
		return discussionRepository.findTop5ByOrderByCreatedAtDesc();
	}
	
	public List<Discussion> findByDiscussionTitle(String discussionTitle) {
		return discussionRepository.findByTitle(discussionTitle);
	}
	
	public List<Discussion> findByDiscussionTitleContaining(String title) {
		return discussionRepository.findByTitleContainingIgnoreCase(title);
	}
	
	public List<Discussion> findByDiscussionDescriptionContaining(String searchValue) {
		return discussionRepository.findByDescriptionContainingIgnoreCase(searchValue);
	}
	
	public List<Discussion> findByUsername(String authorUsername) {
		return discussionRepository.findByAuthorUsername(authorUsername);
	}
	
	public List<Discussion> findByCategoryId(Long categoryId) {
		return discussionRepository.findByCategoryId(categoryId);
	}
	
	public Map<Long, CommentDetails> getLatestCommentDetails(List<Discussion> discussions) {
		Map<Long, CommentDetails> detailsMap = new HashMap<>();
		
		for (Discussion discussion : discussions) {
			List<Comment> comments = discussion.getComments();
			if(comments != null && !comments.isEmpty()) {
				Comment mostRecentComment = comments.get(comments.size() - 1);
				String timeAgo = StringUtils.timeAgo(mostRecentComment.getCreatedAt());
				String username = mostRecentComment.getAuthor().getUsername();
				detailsMap.put(discussion.getId(), new CommentDetails(timeAgo, username, mostRecentComment));
			} else {
				detailsMap.put(discussion.getId(), new CommentDetails("No comments yet", "Unknown", null));
			}
		}
		return detailsMap;
	}

	
	
	
	
	
	
	
	
}

