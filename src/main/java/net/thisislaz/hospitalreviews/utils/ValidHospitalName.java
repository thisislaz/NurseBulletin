package net.thisislaz.hospitalreviews.utils;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

/**
 * 
 * @author cuban
 *
 * This interface is to handle the error message for the hostpial.hospitalName that is sent from the createReview form
 * The review class does not a hospitalName attribute since the hospital Object is never empty, because of all the options
 * 		in the list, it woont throw the custom error.
 * This interface along with the {@code HospitalNameValidator} handles that.
 */

@Documented
@Constraint(validatedBy = HospitalNameValidator.class)
@Target({ ElementType.METHOD, ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidHospitalName {
    String message() default "Please search for a hospital to associate with your review.";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}