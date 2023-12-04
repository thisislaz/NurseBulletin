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
		<main class="center-form specific-edit">
			<div class="mid-container">
				<div class="discussion-top">
					<h2>Search discussions by...</h2>
					<div id="confirmModal" class="delete-modal">
						<div class="delete-modal-content">
							<span class="close">&times;</span>
							<p>Are you sure you want to delete?</p>
						 	<!-- Use a hidden form to send the delete request -->
						 	<div class="d-flex">
								<button class="delete-modal-button cancel convert-to-button" onclick="location.href='/discussion/allDiscussions';" >Cancel</button>
								<form id="deleteForm" action="" method="post">
									<input type="hidden" name="_method" value="DELETE">
									<button class="delete-modal-button confirm-delete" type="submit">Confirm Delete</button>
								</form>
						 	</div>
						</div>
					</div>
					<div class="search-reviews-form" id="defaultForm">
						<form action="/discussion/searchedDiscussions" method="get">
							<select name="searchType" id="searchTypeDropdown">
								<option value="" selected disabled>Please choose from the following...</option>
								<option value="title">Search by Discussion Title</option>
								<option value="description">Search by Discussion Description</option>
								<option value="author">Search by Username</option>
								<option value="category">Search by Category</option>
								<option value="recent">Most Recent</option>
							</select>
							<input id="search-review-input" type="text" name="searchValue" placeholder="Enter search value...">
							<input class="custom-btn-sq" type="submit" value="Search">
						</form>
					</div>
					<div id="selectedCategory" class="search-reviews-form" >
						<form:form action="/discussion/searchedDiscussions" method="get" modelAttribute="category">
							<select name="searchType" id="searchTypeDropdown">
								<option value=""  disabled>Please choose from the following...</option>
								<option value="title">Search by Discussion Title</option>
								<option value="description">Search by Discussion Description</option>
								<option value="author">Search by Username</option>
								<option selected value="category">Search by Category</option>
								<option value="recent">Most Recent</option>
							</select>
							<form:select path="id" id="categoryDropdown">
								<form:option value="" disabled="true" selected="true">Please select a category</form:option>
								<form:options items="${categoriesList }" itemValue="id" itemLabel="name" />
							</form:select>
							<input class="custom-btn-sq" type="submit" value="Search">
						</form:form>
					</div>
				</div>
				<!-- Results section -->
			    <div id="resultsSection">
			        <h2>Search Results</h2>
			        <hr>
			        <br>
			        <c:choose>
			            <c:when test="${ not empty searchedDiscussionsList }">
			                <c:forEach items="${ searchedDiscussionsList }" var="discussion">
			                <fieldset class="discussion-card" >
			                <legend class="right-aligned-legend" align="right"> <c:out value="${ discussion.category.name }"></c:out> </legend>
			                   <div class="fieldset-left-col">
					        		<c:choose>
					        			<c:when test="${not empty discussion.author.profilePicture and fn:length(discussion.author.profilePicture) != 2 }">
						        			<span class="profile-image"> <i class="fa-solid <c:out value="${ discussion.author.profilePicture }"></c:out>" ></i> </span>
					        			</c:when>
					        			<c:otherwise>
					        				<h3 class="profile-image">
					        					<c:out value="${ fn:substring(discussion.author.firstName, 0, 1).toUpperCase()  }${ fn:substring(discussion.author.lastName, 0,1).toUpperCase() }"></c:out>
					        				</h3>
					        			</c:otherwise>
					        		</c:choose>
				        			<h2>
				        				<c:out value="${ discussion.author.username }"></c:out>
				        			</h2>
				        			<c:choose>
				        				<c:when test="${ sessionScope.userId == discussion.author.id }">
					        				<a class="blue-font-hover-blue" href="javascript:void(0);" onclick="confirmDiscussionDelete(${ discussion.id })">delete</a>
				        				</c:when>
				        			</c:choose>
				        		</div>
				        		<div class="fieldset-middle-col">
					        		<h3>
					        			<a href="<c:url value='/discussion/allDiscussions/${discussion.id}'/>">${discussion.title} </a>
					        		</h3>
				        			<span>
				        				<i class="fa-solid fa-reply fa-flip-vertical fa-xs" style="color: #000000;"></i> 
				        				<c:choose>
				        					<c:when test="${not empty latestCommentDetails[discussion.id].timeAgo }">
				        						Latest reply by <c:out value="@${latestCommentDetails[discussion.id].authorFirstName }"></c:out>
				        						${ latestCommentDetails[discussion.id].timeAgo }
				        					</c:when>
				        					<c:otherwise>
				        						No comments yet
				        					</c:otherwise>
				        				</c:choose>
				        			</span>
				        			<p> <c:out value="${ latestCommentDetails[discussion.id].latestComment.content }"></c:out> </p>
				        		</div>
				        		<div class="fieldset-right-col">
					        		<div class="fieldset-right-col-list">
					        			<c:forEach var="comment" items="${ discussion.comments }" varStatus="status">
											<c:choose>
												<c:when test="${status.index < 4}">
												    <c:choose>
												        <c:when test="${not empty comment.author.profilePicture and fn:length(comment.author.profilePicture) != 2}">
												            <div class="profile-image" style="z-index:${4 - status.index};">
												                <i class="fa-solid ${comment.author.profilePicture}"></i>
												            </div>
												        </c:when>
												        <c:otherwise>
												            <div class="profile-image alt-image" style="z-index:${4 - status.index};">
												               <h3> ${fn:substring(comment.author.firstName, 0, 1).toUpperCase()}${fn:substring(comment.author.lastName, 0,1).toUpperCase()} </h3>
												            </div>
												        </c:otherwise>
												    </c:choose>
												</c:when>
												<c:when test="${status.index == 4}">
												    <div class="profile-image more-indicator" style="z-index:0;">
												        ...
												    </div>
												</c:when>
											</c:choose>
										</c:forEach>
					        		</div>
				        			<a href="/discussion/allDiscussions/${ discussion.id }" >	 
				        				<i class="fa-regular fa-comments"></i>
				        				<c:out value=" ${ discussion.comments.size() } Comments"></c:out>  
				        			</a>
				        		</div>
				       		 
			                </fieldset>
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                <p>No discussions found for the provided criteria.</p>
			            </c:otherwise>
			        </c:choose>
			    </div>	
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