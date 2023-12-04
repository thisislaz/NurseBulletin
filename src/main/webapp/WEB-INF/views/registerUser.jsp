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
	<header>
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
	</header>
	<div id="pw-modal" style="display: none;" class="password-modal">
			<div class="pw-modal-content">
				<p>Password must contain at least 1 uppercase letter, 1 special character and 1 number.</p>
			</div>
		</div>
	<main class="center-form">
		<section class="mid-container">
			<h1>Register</h1>
			<form:form action="/user/register" method="post" modelAttribute="newUser">
				<div class="login-row">
					<div class="col-25">
						<form:label path="firstName"> First Name:</form:label>
					</div>
					<div class="col-75">
						<form:input type="text" path="firstName" class="form-control" />
						<form:errors path="firstName" class="login-errors" />		
					</div>
				</div>
				<div class="login-row">
					<div class="col-25">
						<form:label path="lastName"> Last Name:</form:label>
					</div>
					<div class="col-75">
						<form:input type="text" path="lastName" class="form-control" />
						<form:errors path="lastName" class="login-errors" />
					</div>
				</div>
				<div class="login-row">
					<div class="col-25">
						<form:label path="username"> Username:</form:label>
					</div>
					<div class="col-75">
						<form:input type="text" path="username" class="form-control" />
						<form:errors path="username" class="login-errors" />
					</div>
				</div>
				<div class="login-row">
					<div class="col-25">
						<form:label path="email"> Email: </form:label>
					</div>
					<div class="col-75">
						<form:input type="text" path="email" class="form-control" />
						<form:errors path="email" class="login-errors" />
					</div>
				</div>
				<div class="login-row">
					<div class="col-25">
						<form:label path="password"> Password: </form:label>
						<i id="passwordField" class="fa-regular fa-circle-question fa-lg" style="color: #000000;"></i>
					</div>
					<div class="col-75 algin-items-center">
						<form:input type="password" path="password" class="form-control passwordInput"/>
						<i class="fa-solid fa-eye togglePassword" onclick="togglePasswordVisibility()" ></i>
					</div>
					<form:errors path="password" class="login-errors" />
				</div>
				<div class="login-row">
					<div class="col-25">
						<form:label path="confirm">Confirm Password:</form:label>
					</div>
					<div class="col-75 algin-items-center">
						<form:input type="password" path="confirm" class="form-control confirmPasswordInput" />
						<i class="fa-solid fa-eye toggleConfirmPassword" onclick="toggleConfirmPasswordVisibility()" ></i>
					</div>
					<form:errors path="confirm" class="login-errors" />
				</div>
				<div class="login-row">
					<input type="submit" value="Register" />
				</div>
			</form:form>
			<div class="login-row">
				<div class="col-100">
					<h4>Already have an account?</h4>
					<h4><a href="/user/login">Log in</a></h4>
				</div>
			</div>
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