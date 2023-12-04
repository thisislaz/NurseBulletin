package net.thisislaz.hospitalreviews.utils;


import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class HospitalNameValidator implements ConstraintValidator<ValidHospitalName, String> {

	@Override
    public void initialize(ValidHospitalName constraintAnnotation) {
    }

	@Override
	public boolean isValid(String hospitalName, ConstraintValidatorContext context) {
	    if (hospitalName == null || hospitalName.trim().isEmpty()) {
	        context.disableDefaultConstraintViolation();
	        context.buildConstraintViolationWithTemplate("Hospital name is required.")
	               .addConstraintViolation();
	        return false;
	    }
	    return true;
	}

}