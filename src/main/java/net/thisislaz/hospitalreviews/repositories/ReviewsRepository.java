package net.thisislaz.hospitalreviews.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import net.thisislaz.hospitalreviews.models.Review;

@Repository
public interface ReviewsRepository extends CrudRepository<Review, Long> {

	List<Review> findAll();
	
	List<Review> findByAuthorIdNot(Long authorId);
	
	List<Review> findByAuthorId(Long authorId);
	
	List<Review> findTop5ByOrderByCreatedAtDesc();
	
	List<Review> findByHospitalState(String state);
	
	List<Review> findByHospitalHospitalName(String hospitalName);

	List<Review> findByHospitalCity(String city);

	List<Review> findByHospitalHospitalType(String hospitalType);

	List<Review> findByHospitalHospitalNameContaining(String hospitalName);
	
	List<Review> findByHospitalHospitalNameOrderByCreatedAtDesc(String hospitalName);
	
	List<Review> findByHospitalHospitalNameOrderByUpdatedAtDesc(String hospitalName);

}
