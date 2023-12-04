package net.thisislaz.hospitalreviews.config;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;
import net.thisislaz.hospitalreviews.models.User;
import net.thisislaz.hospitalreviews.services.UserService;

@ControllerAdvice
public class GlobalControllerAdvice {

	private final UserService userService;
	
	public GlobalControllerAdvice(UserService userService) {
		this.userService = userService;
	}
	
	@ModelAttribute
	public void addUserToModel(Model model, HttpSession session) {
		Long userId = (Long) session.getAttribute("userId");
		
		if(userId != null) {
			User user = userService.getUser(userId);
			model.addAttribute("user",user);
		}
	}
	
}
