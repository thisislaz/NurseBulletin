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
		<section class="mid-container">
			<h1>Add a Review</h1>
			<form:form method="post" action="/review/new" modelAttribute="review">
			    <div>
			        <form:label path="hospital">Hospitals:</form:label>
					<form:input type="text" id="hospitalName" list="hospitalList" placeholder="Search for hospitals..." path="hospitalName"/>
					<datalist id="hospitalList">
					    <c:forEach items="${hospitals}" var="hospital">
					        <option value="${hospital.hospitalName} - ${ hospital.city }, ${hospital.state}" data-id="${hospital.id}" data-hospital-name="${ hospital.hospitalName }"></option>
					    </c:forEach>
					</datalist>
					<form:hidden path="hospital.id" id="hospitalId"/>
			        <form:errors path="hospitalName"/>
			    </div>
				<div>
					<form:label path="title">Review Title:</form:label>
					<form:input type="text" path="title"/>
					<form:errors path="title" />
				</div>
				<div>
					<form:label path="unitWorkedAt">Unit:</form:label>
					<form:input type="text" path="unitWorkedAt"/>
					<form:errors path="unitWorkedAt" />
				</div>
				<div>
					<form:label path="rating">Rating:</form:label>
					<form:select path="rating">
				        <form:option value="" label="Select" disabled="true" selected="true" />
				        <form:option value="5" />
				        <form:option value="4" />
				        <form:option value="3" />
				        <form:option value="2" />
				        <form:option value="1" />
				    </form:select>
					<form:errors path="rating" />
				</div>
				<div>
					<form:label path="patientRatio">Nurse to Patient Ratio:</form:label>
					<form:select path="patientRatio">
				        <form:option value="" label="Select" disabled="true" selected="true" />
				        <form:option value="1:1 - 1:2" />
				        <form:option value="1:3 - 1:5" />
				        <form:option value="1:6 - 1:8" />
				        <form:option value="> 1:8" />
				    </form:select>
					<form:errors path="patientRatio" />
				</div>
				<div>
					<form:label path="chartingSystem">Charting system used:</form:label>
					<form:input type="text" path="chartingSystem"/>
					<form:errors path="chartingSystem" />
				</div>
				<div>
					<form:label path="wouldReturn">Would you return:</form:label>
					<form:select path="wouldReturn">
				        <form:option value="" label="Select" disabled="true" selected="true" />
				        <form:option value="yes" />
				        <form:option value="no" />
				        <form:option value="maybe" />
				    </form:select>
					<form:errors path="wouldReturn" />
				</div>
				<div>
					<form:label path="managementRating">How would you rate management:</form:label>
					<form:select path="managementRating">
				        <form:option value="" label="Select" disabled="true" selected="true" />
				        <form:option value="5" />
				        <form:option value="4" />
				        <form:option value="3" />
				        <form:option value="2" />
				        <form:option value="1" />
				    </form:select>
					<form:errors path="managementRating" />
				</div>
				<div>
					<form:label path="content">How was your experience: </form:label>
					<form:textarea rows="5" path="content" id="reviewContent"/>
					<span id="charCount">0</span><span>/ 500 characters</span>
					<form:errors path="content" />
				</div>
				<form:hidden path="author" value=" ${ userId } " />
				<br>
				<div class="login-row">
					<input type="submit" value="Add review" />
				</div>
			</form:form>
		</section>
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