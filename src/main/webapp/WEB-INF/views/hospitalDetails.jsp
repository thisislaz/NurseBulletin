<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix= "fmt" uri= "http://java.sun.com/jsp/jstl/fmt"%> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


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
		<main class="" >
			<div class="dark-picture " id="dark-picture">
				<div class="hospitalname-city">
					<h1><c:out value="${ hospital.hospitalName }"></c:out></h1>
				</div>
				<div class="pair-container">
					<p><strong>Address:</strong></p>
					<p><c:out value="${ hospital.address }, ${ hospital.city }, ${ hospital.state }, ${ hospital.zipcode }"></c:out></p>
				</div>
				<div class="pair-container">
					<p><strong>Type:</strong></p>
					<p><c:out value="${ hospital.hospitalType }"></c:out></p>
				</div>
				<div class="pair-container">
					<p><strong>Ownership:</strong></p>
					<p><c:out value="${ hospital.ownership }"></c:out></p>
				</div>
				<div class="pair-container">
					<p><strong>Total Reviews:</strong></p>
					<p><c:out value="${ hospital.getReviewCount() }"></c:out></p>
				</div>
				<div class="pair-container">
					<p><strong>Average Rating:</strong></p>
					<p><c:out value="${ averageRating }"></c:out></p>
				</div>
			</div>
			<div class="centered-text main-container">
				<h2>Hospital Reviews</h2>
			</div>
			<!-- Reviews Carousel -->
			<!-- Check if reviews are present -->
			<c:choose>
			    <c:when test="${ not empty reviews }">
			        <!-- Reviews Carousel -->
			        <div class="carousel-container modern-carousel">
			            <div class="carousel-slides ">
			                <c:forEach items="${ reviews }" var="review">
			                    <div class="carousel-item active-slide">
			                    	<div class="review-card">
			    	                    <h2><c:out value='"${ review.title }"'/></h2>
			    	                    <c:choose>
			    	                    	<c:when test="${not empty review.updatedAt }">
												<p><b>Updated on: </b><c:out value="${ review.getFormattedDate() }"/></p>
			    	                    	</c:when>
											<c:otherwise>
						                        <p><b>Posted: </b><c:out value="${ review.getFormattedDate() }"/></p>
											</c:otherwise>			    	                    	
			    	                    </c:choose>
				                        <p><b>Unit: </b><c:out value="${ review.unitWorkedAt }"/></p>
				                        <p><b>Summary: </b><c:out value="${ review.content }"/></p>
				                        <p><b>Posted By: </b> <c:out value="${review.author.username }"></c:out>  </p>
			                    	</div>
			                    </div>
			                </c:forEach>
			            </div>
			            <button class="carousel-btn prev-btn">&#10094;</button>
			            <button class="carousel-btn next-btn">&#10095;</button>
			            <div class="slide-number-display">1/${fn:length(reviews)}</div>
			        </div>
			    </c:when>
			    <c:otherwise>
			        <div class="centered-text main-container">
			            <p>Currently there are no reviews available for this hospital.</p>
			        </div>
			    </c:otherwise>
			</c:choose>

		
			<div class="centered-text main-container">
				<a class="custom-btn-sq" href="/review/new?hospitalName=${ hospital.hospitalName }">Review this hospital</a>
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