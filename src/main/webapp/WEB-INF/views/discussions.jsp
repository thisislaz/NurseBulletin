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
			<div class="discussions-bottom">
				<div class="discussions-left">
					<div id="discussion-threads-search">
						<h1>Discussion Threads</h1>
						<a class="custom-search-btn" href="/discussion/searchedDiscussions">
							Search discussions 
							<i class="fa-solid fa-magnifying-glass" ></i>
						</a>
					</div>
					<hr>
					<br>
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
				    <c:forEach var="discussion" items="${discussions}">
						<fieldset class="discussion-card">
				        <legend class="right-aligned-legend" align="right"><c:out value="${ discussion.category.name }"></c:out> </legend>
				        		<div class="fieldset-left-col">
					        		<c:choose>
					        			<c:when test="${not empty discussion.author.profilePicture and fn:length(discussion.author.profilePicture) != 2}">
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
				        			<div>
									</div>
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
				</div>
				<div class="discussions-right">
					<h1>Create new discussion</h1>
					<div class="mid-container" >
					   <form:form action="/discussion/allDiscussions" method="post" modelAttribute="allDiscussions">
					        <!-- Category Dropdown and Description -->
					   		<div >
					            <form:label path="category">Category:</form:label>
					            <form:select path="category" id="categoryDropdown" >
					                <form:option value="" disabled="true" selected="true">Please select a category</form:option>
					                <!-- Assuming you have a list of categories available as `categoriesList` -->
					                <form:options items="${categoriesList}" itemValue="id" itemLabel="name" />
					            </form:select>
					        </div>
					
					        <div >
					            <form:label path="title">Title:</form:label>
					            <form:input path="title" type="text"/>
					            <form:errors path="title" />
					        </div>
					        <div >
					            <form:label path="description">Description: </form:label>
					            <form:textarea rows="5" path="description" id="reviewContent"/>
					            <span id="charCount">0</span><span>/ 500 characters</span>
					            <form:errors path="description" />
					        </div>
					        
					        <form:hidden path="author" value="${ userId }" />
		
					        <div class="login-row">
					            <input type="submit" value="Start Discussion" />
					        </div>
					    </form:form>
					</div>
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