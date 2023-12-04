package net.thisislaz.hospitalreviews.services;

import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import net.thisislaz.hospitalreviews.models.LoginUser;
import net.thisislaz.hospitalreviews.models.User;
import net.thisislaz.hospitalreviews.repositories.UserRepository;

@Service
public class UserService {

	public final UserRepository userRepo;
	public UserService(UserRepository userRepo) {
		this.userRepo = userRepo;
	}

	public User getUser(String email) {
		Optional<User> potentialUser = userRepo.findByEmail(email);
		return potentialUser.isPresent() ? potentialUser.get() : null;
	}
	
	public User findByUsername(String username) {
		Optional<User> potentialUser = userRepo.findByUsername(username);
		return potentialUser.isPresent() ? potentialUser.get() : null;
	}
	
	public User getUser(Long id) {
		Optional<User> potentialUser = userRepo.findById(id);
		return potentialUser.isPresent() ? potentialUser.get() : null;
	}
	
	public User registerUser(User newUser, BindingResult result) {
		if(!validatePassword(newUser.getPassword())) {
			result.rejectValue("password", "Invalid", "Password must contain at least 1 number, 1 special character, and uppercase letter.");
			return null;
		}
		String hashedPW = BCrypt.hashpw(newUser.getPassword(), BCrypt.gensalt());
		newUser.setPassword(hashedPW);
		return userRepo.save(newUser);
	}
	
	public boolean validatePassword(String password) {
		String passwordRegexString = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[A-Z]).{8,}$";
		Pattern pattern = Pattern.compile(passwordRegexString);
		Matcher matcher = pattern.matcher(password);
		
		return matcher.matches();
	}
	
	public User login(LoginUser loginUser, BindingResult result) {
		if(result.hasErrors()) {
			return null;
		}
		User existingUser = getUser(loginUser.getEmail());
		if(existingUser == null) {
			result.rejectValue("email", "Unique", "Unknown email.");
			return null;
		}
		if(!BCrypt.checkpw(loginUser.getPassword(), existingUser.getPassword())) {
			result.rejectValue("password", "Matches", "Passowrds do not match!");
			return null;
		}
		return existingUser;
	}
	
	public User updateUser(User user) {
		return userRepo.save(user);
	}
	
}
