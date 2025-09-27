package vn.iotstar.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

import vn.iotstar.entity.Product;

public interface IProductService {
    List<Product> findAll();
    Optional<Product> findById(Long id);
    Optional<Product> findByProductName(String productName);
    Optional<Product> findByCreateDate(Timestamp createDate);
    Product save(Product product);
    void deleteById(Long id);
    void delete(Product product);
}