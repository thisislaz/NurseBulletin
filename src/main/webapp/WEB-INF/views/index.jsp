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
	<section class="bg-img">
		<section class="container ">
			<h1>Join now and review your latest assignment!!</h1>
			<br>
			<p>Help fellow traveling nurses get a heads up on the situation they are heading into.</p>
			<br>
			<p>Don't worry we're on your side! The hospitals/agencies won't know who you are.</p>
			<br>
			<a class="custom-btn " id="fill-btn" href="/user/register" >Join NurseBulletin</a>
			<br>
		</section>
		<section class="right-container">
			<h3>Karina Khan</h3>
			<p>BSN, RN</p>
			<p>CV-ICU Miami, FL</p>
		</section>
		
	</section>
	<section class="middle-section">
		<section class="top-half">
			<h2>The best way to know facts about the hospital you can't find anywhere else!!</h2>
			<br>
			<p>
				Here at the NurseBulletin, we listen to our nurses, 
				and let you inform others on certain things about the hospital, 
				so you don't have to wait a week to hear it from your recruiter.
			</p>
		</section>
		<section class="bottom-half">
			<div class="card">
				<img alt="Smiling cartoon nurse" src="/assets/cartoon_nurse.jpg" style="width:50%">
				<div class="card-container">
					<h3>Create your account</h3>
					<br>
					<p> Create your account so you can review multiple facilities</p>
				</div>
			</div>
			<div class="card">
				<img alt="Cartoonish flustered nurse" src="/assets/paperwork_nurse.jpg" style="width:50%">
				<div class="card-container">
					<h3>Create reviews on past experiences</h3>
					<br>
					<p>Create reviews on your past experiences and search our database of reviews.</p>
				</div>
			</div>
			<div class="card">
				<img alt="Cartoonish hospital" src="/assets/cartoon_hospital.jpg" style="width:50%">
				<div class="card-container">
					<h3>Browse our database of US hospitals</h3>
					<br>
					<p>Check out all the reviews we have on certain hospitals across the US.</p>
				</div>
			</div>
		</section>
	</section>
	<div>
		<h2 class="centered-text lg-font">What other nurses are saying</h2>
		<br>
		<h4 class="centered-text">Each nurse is encouraged to be as truthful as possible so other fellow nurses have accurate information.</h4>
	</div>
	<section class="bottom-section">
		<div class="slideshow-container">
			<c:forEach var="eachReview" items="${ reviewList }" varStatus="status" >
				<div class="card mySlides fade">
					<div class="custom-card">
						<h2>${ eachReview.hospital.hospitalName }</h2>
					</div>
					<p>"${ eachReview.title.toUpperCase() }"</p>
					<p><b>Unit:</b> ${ eachReview.unitWorkedAt.toUpperCase() }</p>
					<p><b>Summary:</b> "${ eachReview.content }"</p>
					<p><b>Posted:</b> ${ eachReview.getFormattedDate() } </p>
					<br>
					<br>
					<a class="custom-btn-sq" href="/review/view/${eachReview.id}" >View Review</a>
				</div>
			</c:forEach>
		</div>
	</section>
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