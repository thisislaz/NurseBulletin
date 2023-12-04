const backgroundImages = [
	'/assets/bottom-highrises.jpg',
	'/assets/church-center.jpg',
	'/assets/distant-highriese.jpg',
	'/assets/hospital-building.jpg',
	'/assets/helicopter.jpg',
	'/assets/highrise-helipad.jpg',
	'/assets/mirror-rain.jpg',
	'/assets/nurse-taking-subway.jpg',
	'/assets/nurse-touching-paitent.jpg',
	'/assets/oriental-city.jpg',
	'/assets/park-highrises.jpg',
	'/assets/pexels-kaique-rocha-185706.jpg',
	'/assets/pills.jpg',
	'/assets/river-intersection.jpg',
	'/assets/sethoscope-heart.jpg',
	'/assets/surgeon-in-surgery.jpg',
	'/assets/surgical-nurse.jpg'
]

function changeBackgoundImage() {
	const imageUrl = backgroundImages[Math.floor(Math.random() * backgroundImages.length)];
	const element = document.getElementById("dark-picture");
	element.style.backgroundImage = `url("${imageUrl}")`;
}

window,addEventListener('load', changeBackgoundImage);

// this is handling the modal for the "?" that shows what the password requires
document.addEventListener('DOMContentLoaded', function() {
    var passwordField = document.getElementById('passwordField');
    var pwModal = document.getElementById('pw-modal');

    passwordField.addEventListener('mouseover', function(event) {
        var fieldRect = passwordField.getBoundingClientRect();
        var scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        var scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;

        pwModal.style.display = 'block';
        pwModal.style.left = fieldRect.right + scrollLeft + 'px'; // Adjusted for scroll
        pwModal.style.top = fieldRect.top + scrollTop + 'px'; // Adjusted for scroll
    });

    passwordField.addEventListener('mouseout', function() {
        pwModal.style.display = 'none';
    });
});

/*

this next function is handling the delte modal for the user's own review.
specificly in the dashboard.jsp

*/
document.addEventListener('DOMContentLoaded', () => {
    // Get the modal and the elements inside it that we need to manipulate
    const deleteModal = document.getElementById('confirmModal');
    const deleteForm = document.getElementById('deleteForm');
    const span = deleteModal.querySelector('.close');

    // Function to open the delete confirmation modal
    window.confirmReviewDelete = function(reviewId) {
        // Set the action attribute of the form with the reviewId
        deleteForm.action = `review/delete/${reviewId}`;
        // Show the modal
        deleteModal.style.display = 'block';
    };

 // Function to open the delete confirmation modal
    window.confirmCommentDelete = function(discussionId, commentId) {
        // Set the action attribute of the form with the reviewId
        deleteForm.action = `/discussion/${discussionId}/comment/delete/${commentId}`;
        // Show the modal
        deleteModal.style.display = 'block';
    };

	window.confirmDiscussionDelete = function(discussionId) {
		deleteForm.action = `/discussion/delete/${discussionId}`;
		deleteModal.style.display = 'block';
	}

    // Close the modal when the user clicks on (x)
    span.onclick = function() {
        deleteModal.style.display = "none";
    };

    // Close the modal when the user clicks anywhere outside of the modal
    window.onclick = function(event) {
        if (event.target == deleteModal) {
            deleteModal.style.display = "none";
        }
    };
});

document.addEventListener("DOMContentLoaded", function() {
    
    // Reference to the dropdown and the second form
    var dropdown = document.getElementById('searchTypeDropdown');
    var selectedCategoryForm = document.getElementById('selectedCategory');
    var defaultForm = document.getElementById('defaultForm');
    
    // Initially hide the second form
    selectedCategoryForm.style.display = 'none';

    // Event listener for change on dropdown
    dropdown.addEventListener('change', function() {
        if (this.value === 'category') {
            // If 'category' is selected, show second form, hide the first
            selectedCategoryForm.style.display = 'block';
            defaultForm.style.display = 'none';
        } else {
            // Otherwise, hide second form, show the first
            selectedCategoryForm.style.display = 'none';
            defaultForm.style.display = 'block';

            // Update the selected value in the first form's dropdown
            defaultForm.querySelector('#searchTypeDropdown').value = this.value;
        }
    });

    // Additional event listener for the dropdown in the second form
    selectedCategoryForm.querySelector('#searchTypeDropdown').addEventListener('change', function() {
        // If a new value is selected, hide second form, show the first
        selectedCategoryForm.style.display = 'none';
        defaultForm.style.display = 'block';

        // Update the selected value in the first form's dropdown
        defaultForm.querySelector('#searchTypeDropdown').value = this.value;
    });
});


//review slides
let slideIndex = 0;

function showSlides() {
    const slides = document.getElementsByClassName("mySlides");
    if (!slides.length) {
        return;
    }
    for (let i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }
    // Initialize slideIndex during the first call
    if (slideIndex === undefined) {
        slideIndex = slides.length;
    } else {
        slideIndex--;
        if (slideIndex < 1) {
            slideIndex = slides.length;
        }
    }
    slides[slideIndex - 1].style.display = "block";
    setTimeout(showSlides, 4500); // Change image every 4.5 seconds
}

window.onload = function () {
    handleStickyNav();
    showSlides();
};

function handleStickyNav() {
    window.addEventListener('scroll', toggleStickyNav);
    const navbars = document.getElementsByClassName("sticky-nav");
    if (!navbars.length) return;  // Added check

    const sticky = Array.from(navbars).map(navbar => navbar.offsetTop);

    function toggleStickyNav() {
        for (let i = 0; i < navbars.length; i++) {
            if (window.pageYOffset >= sticky[i]) {
                navbars[i].classList.add("sticky")
            } else {
                navbars[i].classList.remove("sticky");
            }
        }
    }
}

// character counter for review.content
document.addEventListener("DOMContentLoaded", function () {
    const reviewContent = document.getElementById("reviewContent");
    const charCount = document.getElementById("charCount");
    if (reviewContent && charCount) {  // Added check
        reviewContent.addEventListener("input", function () {
            const currentLength = reviewContent.value.length;
            charCount.textContent = currentLength;
            charCount.style.color = currentLength > 500 ? "red" : "initial";
        });
    }
});

//handling the list for hospitals in the add review form/edit review form
const hospitalInput = document.getElementById('hospitalName');
if (hospitalInput) {
    hospitalInput.addEventListener('input', function(e) {
        var input = e.target;
        var list = input.getAttribute('list');
        var options = document.getElementById(list).getElementsByTagName('option');
        var hiddenInput = document.getElementById('hospitalId');
        var inputValue = input.value.split(" - ")[0]; // Extract hospital name before the hyphen

        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            var optionHospitalName = option.getAttribute('data-hospital-name');
            if (optionHospitalName === inputValue) {
                var id = option.getAttribute('data-id');
                hiddenInput.value = id;
                input.value = optionHospitalName; // Set input to only hospital name
                break;
            }
        }
    });
}


document.addEventListener("DOMContentLoaded", function() {
    const searchTypeSelect = document.querySelector("[name='searchType']");
    const searchValueInput = document.getElementById("search-review-input");
	const categorySelect = document.getElementById("categoryDropdown");

    if (searchTypeSelect && searchValueInput) {
        function checkOption() {
           
            if (searchTypeSelect.value === "Most Recent") {
                searchValueInput.disabled = true;
                searchValueInput.value = "";
                searchValueInput.placeholder = "Not required for Most Recent";
            } else if (searchTypeSelect.value === "category") {
                searchValueInput.disabled = true;
                searchTypeSelect.value = categorySelect.value;
            } else {
                searchValueInput.disabled = false;
                searchValueInput.placeholder = "Enter search value...";
            }
        }
        
		if (categorySelect) {
			categorySelect.addEventListener("change", function(){
				if (searchTypeSelect.value === "category") {
					categorySelect.value = categorySelect.value;
				}
			})
		}
	
        checkOption();
        searchTypeSelect.addEventListener("change", checkOption);
    }
});


// this is for the hospitals detail page
// this is also handling the carousel functionality
document.addEventListener('DOMContentLoaded', function() {

    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-item');
    const totalSlides = slides.length;

    function moveSlides(direction) {
        slides[currentSlide].style.display = 'none';
        currentSlide = (currentSlide + direction + totalSlides) % totalSlides;
        slides[currentSlide].style.display = 'block';
    }

    // Initialize the carousel
    if (totalSlides > 0) {
        slides.forEach(slide => slide.style.display = 'none');
        slides[0].style.display = 'block';

        const prevButton = document.querySelector('.prev-btn');
        const nextButton = document.querySelector('.next-btn');

        if (prevButton && nextButton) {  // Added check
            prevButton.addEventListener('click', () => moveSlides(-1));
            nextButton.addEventListener('click', () => moveSlides(1));
        }
    } else {
        console.log('no slides');
    }

});

document.addEventListener("DOMContentLoaded", function() {
    let currentSlide = 0;
    const slideItems = document.querySelectorAll('.carousel-item');
    const totalSlides = slideItems.length;
    const slideDisplay = document.querySelector('.slide-number-display');

    document.querySelector('.next-btn').addEventListener('click', function() {
        slideItems[currentSlide].classList.remove('active-slide'); // remove active class from current slide
        currentSlide = (currentSlide + 1) % totalSlides; // increment slide or reset if at end
        slideItems[currentSlide].classList.add('active-slide'); // add active class to new current slide
        updateSlideDisplay();
    });

    document.querySelector('.prev-btn').addEventListener('click', function() {
        slideItems[currentSlide].classList.remove('active-slide'); // remove active class from current slide
        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides; // decrement slide or set to last if at start
        slideItems[currentSlide].classList.add('active-slide'); // add active class to new current slide
        updateSlideDisplay();
    });

    function updateSlideDisplay() {
        slideDisplay.innerText = `${currentSlide + 1}/${totalSlides}`;
    }
});

const chooseBtn = document.getElementById('chooseBtn');
const iconModal = document.getElementById('iconModal');
const closeBtn = iconModal.querySelector('.close');
const icons = iconModal.querySelectorAll('.icon');

chooseBtn.addEventListener('click', () => {
  iconModal.style.display = 'block';
});

closeBtn.addEventListener('click', () => {
  iconModal.style.display = 'none';
});

icons.forEach(icon => {
  icon.addEventListener('click', (e) => {
	  // this will get the 'data-icon' attribute value
    const selectedIconClass = e.currentTarget.dataset.icon;
    
    
    //setting the 'profilePicture' value
    // if 'data-icon' is empty (the default option), it sets an empty string
    document.getElementById('profilePicture').value = selectedIconClass;

    
    iconModal.style.display = 'none';
  });
});

function togglePasswordVisibility() {
        var passwordInput = document.getElementsByClassName("passwordInput")[0];
        var togglePasswordIcon = document.getElementsByClassName("togglePassword")[0];

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            togglePasswordIcon.classList.remove("fa-eye");
            togglePasswordIcon.classList.add("fa-eye-slash");
        } else {
            passwordInput.type = "password";
            togglePasswordIcon.classList.remove("fa-eye-slash");
            togglePasswordIcon.classList.add("fa-eye");
        }
    }

    function toggleConfirmPasswordVisibility() {
        var confirmPasswordInput = document.getElementsByClassName("confirmPasswordInput")[0];
        var toggleConfirmPasswordIcon = document.getElementsByClassName("toggleConfirmPassword")[0];

        if (confirmPasswordInput.type === "password") {
            confirmPasswordInput.type = "text";
            toggleConfirmPasswordIcon.classList.remove("fa-eye");
            toggleConfirmPasswordIcon.classList.add("fa-eye-slash");
        } else {
            confirmPasswordInput.type = "password";
            toggleConfirmPasswordIcon.classList.remove("fa-eye-slash");
            toggleConfirmPasswordIcon.classList.add("fa-eye");
        }
    }

function toggleLoginPasswordVisibility() {
	var passwordInput = document.getElementById("loginPasswordInput");
	var togglePasswordIcon = document.getElementById("toggleLoginPassword");
	
	if(passwordInput.type == "password") {
		passwordInput.type = "text";
		togglePasswordIcon.classList.remove("fa-eye");
		togglePasswordIcon.classList.add("fa-eye-slash");
	} else {
		passwordInput.type = "password";
		togglePasswordIcon.classList.remove("fa-eye-slash");
		togglePasswordIcon.classList.add("fa-eye");
	}
}




















