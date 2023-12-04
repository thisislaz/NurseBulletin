package net.thisislaz.hospitalreviews.utils;

import net.thisislaz.hospitalreviews.models.Comment;

public class CommentDetails {

	private String timeAgo;
	private String authorFirstName;
	private Comment latestComment;
	
	public CommentDetails(String timeAgo, String authorFirstName, Comment latestComment) {
		this.timeAgo = timeAgo;
		this.authorFirstName = authorFirstName;
		this.latestComment = latestComment;
	}

	public String getTimeAgo() {
		return timeAgo;
	}

	public void setTimeAgo(String timeAgo) {
		this.timeAgo = timeAgo;
	}

	public String getAuthorFirstName() {
		return authorFirstName;
	}

	public void setAuthorFirstName(String authorFirstName) {
		this.authorFirstName = authorFirstName;
	}

	public Comment getLatestComment() {
		return latestComment;
	}

	public void setLatestComment(Comment latestComment) {
		this.latestComment = latestComment;
	}
	
	
}
