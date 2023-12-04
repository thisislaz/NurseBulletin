<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isErrorPage="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title></title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/styles/css/style.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

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
	<main class="center-form">
		<section class="mid-container">
			<h1>Edit Profile</h1>
			<form:form action="/user/edit/${ userToEdit.id }" method="post" modelAttribute="userToEdit">
				<form:hidden path="id"/>
				<form:hidden path="profilePicture" id="profilePicture"/>
				<input type="hidden" name="_method" value="put"  />
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
						<form:label path="profilePicture"> Profile Picture: </form:label>
					</div>
					<div class="col-75">
						<form:input id="chooseBtn" type="button" path="profilePicture" class="form-control" value="Choose ..."/>
						<form:errors path="profilePicture" class="login-errors" />
					</div>
				</div>
				<div id="iconModal" class="modal">
					<div class="modal-content" >
						<span class="close">&times;</span>
						<div class="icon-grid" >
							<div class="icon" data-icon="fa-heart-pulse"> <i class="fa-solid fa-heart-pulse"></i></div>
							<div class="icon" data-icon="fa-staff-snake"> <i class="fa-solid fa-staff-snake"></i></div>
							<div class="icon" data-icon="fa-kit-medical"> <i class="fa-solid fa-kit-medical"></i> </div>
							<div class="icon" data-icon="fa-biohazard"> <i class="fa-solid fa-biohazard"></i> </div>
							<div class="icon" data-icon="fa-circle-radiation"> <i class="fa-solid fa-circle-radiation"></i> </div>
							<div class="icon" data-icon="fa-head-side-cough"> <i class="fa-solid fa-head-side-cough"></i> </div>
							<div class="icon" data-icon="fa-skull"> <i class="fa-solid fa-skull"></i> </div>
							<div class="icon" data-icon="fa-poop"> <i class="fa-solid fa-poop"></i> </div>
							<div class="icon" data-icon="fa-syringe"> <i class="fa-solid fa-syringe"></i> </div>
							<div class="icon" data-icon="fa-lungs"> <i class="fa-solid fa-lungs"></i> </div>
							<div class="icon" data-icon="fa-thermometer"> <i class="fa-solid fa-thermometer"></i> </div>
							<div class="icon" data-icon="fa-stethoscope"> <i class="fa-solid fa-stethoscope"></i> </div>
							<div class="icon" data-icon="fa-user-doctor"> <i class="fa-solid fa-user-doctor"></i> </div>
							<div class="icon" data-icon="fa-user-nurse"> <i class="fa-solid fa-user-nurse"></i> </div>
							<div class="icon" data-icon="fa-virus-covid"> <i class="fa-solid fa-virus-covid"></i> </div>
							<div class="icon" data-icon="fa-truck-medical"> <i class="fa-solid fa-truck-medical"></i> </div>
							<div class="icon" data-icon=""> Default (initials) </div>
						</div>
					</div>
				</div>
				<div class="login-row">
					<input type="submit" value="Update Profile" /> 
					<a href="/dashboard" class="cancel-btn">Cancel</a>
				</div>
			</form:form>
		</section>
	</main>

</body>
<footer>
	<section class="footer-section">
		<div class="left-footer">
			<h1>NurseBulletin</h1>
			<a href="#" class="fa fa-facebook"></a> <a href="#"
				class="fa fa-twitter"></a> <a href="#"
				class="fa fa-brands fa-tiktok"></a>
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

</html>