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
	<main class="center-form">
		<div class="centered-text main-container">
			<h1>View Review</h1>
		</div>
		<div class="new-card">
				<div class="hospitalname-city">
					<h2><c:out value="${ review.hospital.hospitalName }"></c:out> </h2>
					
				</div>
				<div class="pair-container">
					<p><strong>Location:</strong></p>
					<h4><c:out value="${ review.hospital.city }, ${ review.hospital.state }"></c:out> </h4>
				</div>
				<div class="pair-container">
				    <p><strong>Title:</strong></p>
				    <p> <c:out value="${ review.title }"></c:out> </p>
				</div>
				<div class="pair-container">
				    <p><strong>Unit:</strong></p>
				    <p> <c:out value="${ review.unitWorkedAt }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Hospital Rating:</strong></p>
					<p> <c:out value="${ review.rating }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Patient Ratio:</strong></p>
					<p> <c:out value="${ review.patientRatio }"></c:out> </p>
				</div>
				<div class="pair-container">
						<p><strong>Charting System:</strong></p>
						<p> <c:out value="${ review.chartingSystem }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Would return:</strong></p> 
					<p> <c:out value="${ review.wouldReturn }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Management Rating:</strong></p>
					<p> <c:out value="${ review.managementRating }"></c:out>  </p>
				</div>
				<div class="pair-container">
					<p><strong>Summary:</strong></p>
					<p> <c:out value="${ review.content }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Posted:</strong></p>
					<p> <c:out value="${ fortmattedDate }"></c:out> </p>
				</div>
				<div class="pair-container">
					<p><strong>Posted by:</strong></p>
					<p> <c:out value=" ${ review.author.username }"></c:out> </p>				
				</div>
		</div>
		<div class="centered-text main-container">
			<a class="custom-btn-sq" href="/review/new?hospitalName=${ review.hospital.hospitalName }">Review this hospital</a>
			<a class="custom-btn-sq" href="/hospitals/view/${review.hospital.id }">View Hospital Details</a>
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
</body>
<script src="/js/script.js"></script>
<script src="https://kit.fontawesome.com/eb2c2d28d2.js" crossorigin="anonymous"></script>

</html>