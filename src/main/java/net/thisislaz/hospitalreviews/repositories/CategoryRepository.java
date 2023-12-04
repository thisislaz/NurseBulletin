package net.thisislaz.hospitalreviews.repositories;

import org.springframework.data.repository.CrudRepository;

import net.thisislaz.hospitalreviews.models.Category;

public interface CategoryRepository extends CrudRepository<Category, Long> {

}
