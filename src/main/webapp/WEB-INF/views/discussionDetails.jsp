<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix= "fmt" uri= "http://java.sun.com/jsp/jstl/fmt"%> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isErrorPage="true" %>
  
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>  </title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/styles/css/style.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
	<nav class="nav-bar sticky-nav">
			<h2><a href="/">NurseBulletin</a></h2>
			<div >
				<ul class="nav-list">
					<li><a href="/">Home</a></li>
					<li><a href="/review/allReviews">Browse Reviews</a></li>
					<li><a href="/hospitals/allHospitals">Browse Hospitals</a></li>
					<li><a href="/discussion/allDiscussions"> Forums</a></li>
				</ul>
			</div>
			<c:choose>
			    <c:when test="${ not empty sessionScope.userId }">
			        <div class="nav-top-right">
			            <!-- Check for profile picture, if not available, display initials -->
			            <c:choose>
			                <c:when test="${not empty user.profilePicture and fn:length(user.profilePicture) != 2 }">
			                    <span class="nav-profile-image"> 
			                    	<i class="fa-solid <c:out value="${ user.profilePicture }"></c:out>"></i> 
			                    </span>
			                </c:when>
			                <c:otherwise>
			                    <h3 class="nav-profile-image">
			                        <c:out value="${ fn:substring(sessionScope.cappedFirstNameUser.firstName, 0, 1).toUpperCase() }${ fn:substring(sessionScope.cappedFirstNameUser.lastName, 0,1).toUpperCase() }"></c:out>
			                    </h3>
			                </c:otherwise>
			            </c:choose>
            		<div class="dropdown">
						<span class="dropdown-btn">  <c:out value="${ sessionScope.cappedFirstNameUser.firstName  } ${ sessionScope.cappedFirstNameUser.lastName }"></c:out> </span>
						<i class="fa-solid fa-angle-down " style="color: #ffffff;"></i>
						<div class="dropdown-content">
							<a href="/dashboard">Dashboard</a>
							<a href="/user/edit/${sessionScope.userId }">Edit profile</a>
							<a href="/review/new" >Add a review</a>
							<a href="/user/logout" >Logout</a>
						</div>
					</div>
				</div>
				</c:when>
				<c:otherwise>
					<div class="nav-bar-right">
						<a id="bg-color-login" class="custom-btn left-btn" href="/user/login" >Log in</a>
						<a class="custom-btn " href="/user/register" >Join NurseBulletin</a>
					</div>
				</c:otherwise>
			</c:choose>
		</nav>
		<main>
			<div class="discussion-details-top">
				<div class="discussion-top-image">
					<div class="left-side-discussion">
						<c:choose>
							<c:when test="${not empty discussion.author.profilePicture and fn:length(discussion.author.profilePicture) != 2}">
								<span class="nav-profile-image"> <i class="fa-solid <c:out value="${ discussion.author.profilePicture }"></c:out>" ></i> </span>
						    </c:when>
						    <c:otherwise>
						    	<h3 class="nav-profile-image">
						        	<c:out value="${ fn:substring(discussion.author.firstName, 0, 1).toUpperCase()  }${ fn:substring(discussion.author.lastName, 0,1).toUpperCase() }"></c:out>
						        </h3>
						    </c:otherwise>
						</c:choose>
						<span>Author: <strong><c:out value="${ discussion.author.username }"></c:out></strong></span>
						<span>Created on: <strong><c:out value="${ discussionObjectWithFormattedDate }"></c:out></strong></span>
					</div>
					<div class="right-side-discussion">
						<h1 > <c:out  value="${ discussion.title }"></c:out> </h1>
						<hr style="color: white;">
						<br>
						<p style="color: white;">${discussion.description}</p>
					</div>
				</div>
			</div>
			<div class="comment-section">
				<!-- confirm delete modal -->
				<h2>Comments</h2>
				<div id="confirmModal" class="delete-modal">
						<div class="delete-modal-content">
							<span class="close">&times;</span>
							<p>Are you sure you want to delete?</p>
						 	<!-- Use a hidden form to send the delete request -->
						 	<div class="d-flex">
								<button class="delete-modal-button cancel convert-to-button" onclick="location.href='/discussion/allDiscussions/${ discussion.id }';" >Cancel</button>
								<form id="deleteForm" action="" method="post">
									<input type="hidden" name="_method" value="DELETE">
									<button class="delete-modal-button confirm-delete" type="submit">Confirm Delete</button>
								</form>
						 	</div>
						</div>
					</div>
				<c:choose>
					<c:when test="${empty comments}">
						<p>Currently there are no comments on this thread, feel free to add some input.</p>
					</c:when>
					<c:otherwise>
						<c:forEach var="comment" items="${comments}">
							<fieldset class="discussion-card">
								<legend class="right-aligned-legend" align="right" > <c:out value="${ comment.author.username }"></c:out> </legend>
					
								<p><c:out value="${comment.content}"></c:out></p>
								<c:choose>
									<c:when test="${ not empty sessionScope.userId and comment.author.id == sessionScope.userId  }">
										<div class="d-flex js-ct-sp-btw">
										<c:choose>
											<c:when test="${ not empty comment.updatedAt }">
												<p><i><b>Updated on: <c:out value="${ comment.fortmattedDate } - ${ comment.formattedCommentTime }"></c:out></b></i></p>
											</c:when>
											<c:otherwise>
												<p><i><b>Created on: <c:out value="${ comment.fortmattedDate } - ${ comment.formattedCommentTime }"></c:out></b></i></p>
											</c:otherwise>
										</c:choose>
											
											<div>
												<a class="blue-font-hover-blue" href="/discussion/${ discussion.id }/comment/edit/${ comment.id }" > edit</a> | 
												<a class="blue-font-hover-blue" href="javascript:void(0);" onclick="confirmCommentDelete(${ discussion.id },${comment.id})">delete</a>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="d-flex">
											<c:choose>
												<c:when test="${ not empty comment.updatedAt }">
													<p><i><b>Updated on: <c:out value="${ comment.fortmattedDate } - ${ comment.formattedCommentTime }"></c:out></b></i></p>
												</c:when>
												<c:otherwise>
													<p><i><b>Created on: <c:out value="${ comment.fortmattedDate } - ${ comment.formattedCommentTime }"></c:out></b></i></p>
												</c:otherwise>
											</c:choose>
										</div>
									</c:otherwise>
								</c:choose>
							</fieldset>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="centered-text main-container">
				<a href="/discussion/newComment?discussionId=${ discussionId }" class="custom-btn-sq">Add a comment</a>
			</div>
		</main>
	
<script src="/js/script.js"></script>
<script src="https://kit.fontawesome.com/eb2c2d28d2.js" crossorigin="anonymous"></script>
</body>
<footer>
	<section class="footer-section">
		<div class="left-footer">
			<h1>NurseBulletin</h1>
			<a href="#" class="fa fa-facebook"></a>
			<a href="#" class="fa fa-twitter"></a>
			<a href="#" class="fa fa-brands fa-tiktok"></a>
		</div>
		<div class="right-footer">
			<ul id="black-font" class="nav-list">
			<li><a href="/">Home</a></li>
				<li><a href="/review/allReviews">Browse Reviews</a></li>
				<li><a href="/hospitals/allHospitals">Browse Hospitals</a></li>
				<li><a href="/discussion/allDiscussions"> Forums</a></li>
			</ul>
		</div>
		
	</section>
</footer>
</html>