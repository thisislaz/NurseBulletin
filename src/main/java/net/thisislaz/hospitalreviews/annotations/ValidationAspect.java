package net.thisislaz.hospitalreviews.annotations;

import java.util.Set;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import net.thisislaz.hospitalreviews.models.User;

@Aspect
@Component
public class ValidationAspect {

	@Around("@annotation(conditionalValidation)")
	public Object validate(ProceedingJoinPoint joinPoint, ConditionalValidation conditionalValidation) throws Throwable {
		Object[] args = joinPoint.getArgs();
		for (Object arg : args) {
			if(arg instanceof User) {
				ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
				Validator validator = factory.getValidator();
				Set<ConstraintViolation<User>> violations = validator.validate((User) arg, conditionalValidation.groups()) ;
				if (!violations.isEmpty()) {
					// handle violations as necesary
					throw new ConstraintViolationException(violations);
				}
			}
		}
		return joinPoint.proceed();
	}
	
}
