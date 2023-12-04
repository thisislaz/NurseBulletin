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
	<div class="flex-container">
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
		<main class="main-container">
			<h1><c:out value="${sessionScope.cappedFirstNameUser.firstName }'s dashboard"></c:out> </h1>
			<p>Reviews are based off of the information provided by our users, such as yourself.</p>
			<div class="top-btns">
				<a class="bot-margin" href="review/new">Add review</a>
				<a class="bot-margin" href="review/allReviews">View all reviews</a>
			</div>
			<div class="row">
				<section class="col-left">
					<h3>Hospitals you have reviewed</h3>
					<c:if test="${ fn:length(noDuplicates) > 0 }">
						<div id=reviewed-hospitals-div class="reviews-col">
							<c:forEach var="eachHospitalName" items="${ noDuplicates }">
								<div>
									<ul class="custom-list"> 
										<li><c:out value="${ eachHospitalName.hospitalName}  |  ${ eachHospitalName.city }, ${ eachHospitalName.state }"></c:out></li> 
									</ul>
								</div>
							</c:forEach>
						</div>
					</c:if>
					<h3>Links to most reviewed hospitals</h3>
					<div class="reviews-col">
					    <div>
					        <c:forEach var="eachEntry" items="${ hospitalReviewCountsSorted }">
					            <ul class="custom-list"> 
					                <li>
					                	<a class="black-font" href="/hospitals/view/${ eachEntry.key.id }">
						                    <c:out value="${ eachEntry.key.hospitalName }"></c:out>
						                    (<c:out value="${ eachEntry.value }"></c:out>)
					                	</a>
					                </li>
					            </ul>
					        </c:forEach>
					    </div>
					</div>
					<h3>Your reviews</h3>
					<!-- Confirm Delete Modal -->
					<div id="confirmModal" class="delete-modal">
						<div class="delete-modal-content">
							<span class="close">&times;</span>
							<p>Are you sure you want to delete?</p>
						 	<!-- Use a hidden form to send the delete request -->
						 	<div class="d-flex">
								<button class="delete-modal-button cancel convert-to-button" onclick="location.href='/dashboard';" >Cancel</button>
								<form id="deleteForm" action="" method="post">
									<input type="hidden" name="_method" value="DELETE">
									<button class="delete-modal-button confirm-delete" type="submit">Confirm Delete</button>
								</form>
						 	</div>
						</div>
					</div>
					<c:forEach var="eachReview" items="${ reviewList }">
						<c:if test="${userId.equals(eachReview.author.id) }">
							<div class="reviews-col margin-bot">
								<div class="own-reviews">
									<h3><c:out value="${ eachReview.hospital.hospitalName }"></c:out> </h3>
									<div class="d-flex">
										<a class="blue-font-hover-blue" href="/review/edit/${ eachReview.id }" >edit</a>
										<a class="blue-font-hover-blue" href="javascript:void(0);" onclick="confirmReviewDelete(${eachReview.id})">delete</a>
									</div>
								</div>
								<p><b>Title:</b>	<c:out value="${ eachReview.title }"></c:out></p>
								<p><b>Unit:</b>	<c:out value="${ eachReview.unitWorkedAt }"></c:out></p>
								<p><b>Rating:</b>	<c:out value="${ eachReview.rating }"></c:out></p>
								<p><b>Patient ratio:</b>	<c:out value="${ eachReview.patientRatio }"></c:out></p>
								<p><b>Charting system:</b>	<c:out value="${ eachReview.chartingSystem }"></c:out></p>
								<p><b>Would return:</b>	<c:out value="${ eachReview.wouldReturn }"></c:out></p>
								<p><b>Management rating:</b>	<c:out value="${ eachReview.managementRating }"></c:out></p>
								<p><b>Summary:</b>	<c:out value="${ eachReview.content }"></c:out></p>
							</div>
						</c:if>
					</c:forEach>


				</section>
				<section class="col-right ">
				<h3><a href="/discussion/allDiscussions" class="arrow-link">Discussions <i class="fa-solid fa-circle-right" ></i></a></h3>
					<div class="reviews-col">
					    <div>
					        <c:forEach var="discussion" items="${ recentDiscussions }">
					            <ul class="custom-list"> 
					                <li>
					                	<a class="black-font" href="/discussion/allDiscussions/${ discussion.id }">
						                    <c:out value="${ discussion.title }"></c:out> 
					                	</a> - <c:out value="${ discussion.category.name }"></c:out>
					                </li>
					            </ul>
					        </c:forEach>
					    </div>
					</div>
					<h3>Most Recent Reviews Posted By Others</h3>
					<c:forEach var="eachReview" items="${ recent5ReviewList }">
						<c:if test="${!userId.equals(eachReview.author.id) }">
							<div class="reviews-col margin-bot">
								<div class="own-reviews">
									<h3><c:out value="${ eachReview.hospital.hospitalName }"></c:out> </h3>
									<div id="other-reviews-view" class="d-flex">
										<a class="blue-font-hover-blue" href="review/view/${eachReview.id}" >view</a>
									</div>
								</div>
								<p><b>Title:</b>	<c:out value="${ eachReview.title }"></c:out></p>
								<p><b>Unit:</b>	<c:out value="${ eachReview.unitWorkedAt }"></c:out></p>
								<p><b>Rating:</b>	<c:out value="${ eachReview.rating }"></c:out></p>
								<p><b>Patient ratio:</b>	<c:out value="${ eachReview.patientRatio }"></c:out></p>
								<p><b>Charting system:</b>	<c:out value="${ eachReview.chartingSystem }"></c:out></p>
								<p><b>Would return:</b>	<c:out value="${ eachReview.wouldReturn }"></c:out></p>
								<p><b>Management rating:</b>	<c:out value="${ eachReview.managementRating }"></c:out></p>
								<p><b>Summary:</b>	<c:out value="${ eachReview.content }"></c:out></p>
								<p><b>Posted:</b>	<c:out value="${ eachReview.getFormattedDate() }"></c:out></p>
								<p><b>Posted By:</b> <c:out value="${eachReview.author.username }"></c:out>  </p>
							</div>
						</c:if>
					</c:forEach>

				</section>
			</div>
		</main>
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
		<script src="/js/script.js"></script>
		<script src="https://kit.fontawesome.com/eb2c2d28d2.js" crossorigin="anonymous"></script>
	</div>
	
</body>


</html>