package net.thisislaz.hospitalreviews.controllers;



import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import net.thisislaz.hospitalreviews.models.LoginUser;
import net.thisislaz.hospitalreviews.models.User;
import net.thisislaz.hospitalreviews.services.UserService;
import net.thisislaz.hospitalreviews.utils.StringUtils;
import net.thisislaz.hospitalreviews.validation.OnCreate;

@Controller
@RequestMapping("/user")
public class UserController {

	public final UserService userService;
	public final Validator validator;
	public UserController(UserService userService, Validator validator) {
		this.userService = userService;
		this.validator = validator;
	}
	
	@GetMapping("/register")
	public String registerUser(Model model, HttpSession session) {
		if(session.getAttribute("userId") != null) {
			return "redirect:/dashboard";
		}
		
		model.addAttribute("newUser", new User());
		model.addAttribute("loginUser", new LoginUser());
		return "views/registerUser";
	}
	
	@PostMapping("/register")
	public String processRegisterUser(@Validated(OnCreate.class) @ModelAttribute("newUser") User newUser, 
										BindingResult result, Model model, HttpSession session) {
		
		if(result.hasErrors()) {
			model.addAttribute("loginUser", new LoginUser());
			return "views/registerUser";
		}
		
		if(userService.getUser(newUser.getEmail()) != null) {
			result.rejectValue("email", "Unique", "Email is already registered!");
		}
		
		if(userService.findByUsername(newUser.getUsername()) != null) {
			result.rejectValue("username","Unique", "Username is already in use.");
		}
		
		if (!newUser.getPassword().equals(newUser.getConfirm())) {
			result.rejectValue("confirm", "Unique", "Passwords do not match!");
		}
		
		// this is capitalizing the first name of the user
		String cappedString = StringUtils.capitalizeWords(newUser.getFirstName());
		newUser.setFirstName(cappedString);
		
		// capping the last name
		String cappedLastName = StringUtils.capitalizeWords(newUser.getLastName());
		newUser.setLastName(cappedLastName);
		
		User createdUser = userService.registerUser(newUser, result);
		if(createdUser == null) {
			return "views/registerUser";
		}
		 
		session.setAttribute("userId", createdUser.getId());
		session.setAttribute("cappedFirstNameUser", newUser);
		
		
		return "redirect:/dashboard";
	}
	
	@GetMapping("/login")
	public String loginRegisterUser(Model model, HttpSession session) {
		if(session.getAttribute("userId") != null) {
			return "redirect:/dashboard";
		}
		
		model.addAttribute("newUser", new User());
		model.addAttribute("loginUser", new LoginUser());
		return "views/loginUser";
	}
	
	@PostMapping("/login")
	public String loginUser(@Valid @ModelAttribute("loginUser") LoginUser loginUser, BindingResult result, Model model, HttpSession session) {
		
		if(result.hasErrors()) {
			model.addAttribute("newUser", new User());
			return "views/loginUser";
		}
		User foundUser = userService.login(loginUser, result);
		if(foundUser == null) {
			model.addAttribute("newUser", new User());
			return "views/loginUser";
		}
		session.setAttribute("userId", foundUser.getId());
		
		// this is capitalizing the first name of the user
		String cappedString = StringUtils.capitalizeWords(foundUser.getFirstName());
		foundUser.setFirstName(cappedString);
		
		// capping the last name
		String cappedLastName = StringUtils.capitalizeWords(foundUser.getLastName());
		foundUser.setLastName(cappedLastName);
		
		session.setAttribute("cappedFirstNameUser", foundUser);
		return "redirect:/dashboard";
	}
	
	@GetMapping("/logout")
	public String logoutUser(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	@GetMapping("/edit/{id}")
	public String editProfile(@PathVariable("id") Long userId, HttpSession session, Model model) {
		//fetching the loggedin user's id using sessionscope
		Long loggedInUserId = (Long) session.getAttribute("userId");
		
		//ensure the user is logged in and they're editting their own profile
		if(loggedInUserId == null || !loggedInUserId.equals(userId)) {
			//redirecting to dashboard so the dashboard controller handles if the user is loggedin or not
			return "redirect:/dashboard";
		}
		
		User userToEdit = userService.getUser(userId);
		
		//checking if the user exists
		if(userToEdit == null) {
			return "redirect:/dashboard";
		}
		
		model.addAttribute("userToEdit", userToEdit);
		return "views/editProfile";
	}
	
	@PutMapping("/edit/{id}")
	public String processEditUser(@PathVariable("id") Long id, @ModelAttribute("userToEdit") User editedUser, BindingResult result, HttpSession session) {
		Long userId = (Long) session.getAttribute("userId");

		if(userId == null ) {
			return "redirect:/user/login";
		} else if(userId != editedUser.getId()){
			return "redirect:/dashboard";	
		}
		
		User user = userService.getUser(userId);
		// this is capitalizing the first name of the user
		String cappedString = StringUtils.capitalizeWords(user.getFirstName());
		user.setFirstName(cappedString);
		
		// capping the last name
		String cappedLastName = StringUtils.capitalizeWords(user.getLastName());
		user.setLastName(cappedLastName);
				
		//setting the password equal to the pw in the db 
		User dbUser = userService.getUser(userId);
		
		//checking if the username is already in db
		User checkUsername = userService.findByUsername(editedUser.getUsername()) ;
		User checkEmail = userService.getUser(editedUser.getEmail()) ;
		if (checkUsername != null && editedUser.getId() != checkUsername.getId()) {
			result.rejectValue("username", "Unique", "Username is already registered!");
		}
		if(checkEmail != null && editedUser.getId() != checkEmail.getId()) {
			result.rejectValue("email", "Unique", "Email is already registered!");
		}
		
		editedUser.setPassword(dbUser.getPassword());
		editedUser.setConfirm(dbUser.getPassword());
		
		//now we are manually triggering validation
		validator.validate(editedUser, result);
		
		if (result.hasErrors()) {
			return "views/editProfile";
		}
		User updatedUser = userService.updateUser(editedUser);
		//update the session with the new edited user info
		session.setAttribute("cappedFirstNameUser", updatedUser);
		
		return "redirect:/dashboard";
		
	}
	






}
