package net.thisislaz.hospitalreviews.repositories;


import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import net.thisislaz.hospitalreviews.models.Hospital;

@Repository
public interface HospitalsRepository extends CrudRepository<Hospital, Long>{
	
	List<Hospital> findByHospitalName(String hospitalName);
	
	Hospital findFirstByHospitalName(String hospitalName);
	
	Optional<Hospital> findById(Long id);
	
	List<Hospital> findByHospitalNameContaining(String term);
	
	List<Hospital> findByState(String state);
	
	List<Hospital> findByCity(String city);
	
	List<Hospital> findByHospitalType(String type);
	
	@Query("SELECT COUNT(r) FROM Review r WHERE r.hospital.id = :hospitalId")
	int countReviewsByHospitalId(@Param("hospitalId") Long hositalId);
	
	@Query("SELECT new map(h as hospital, count(r) as reviewCount) FROM Hospital h LEFT JOIN h.reviews r GROUP BY h")
	List<Map<String, Object>> findAllWithReviewCount();
	
}
