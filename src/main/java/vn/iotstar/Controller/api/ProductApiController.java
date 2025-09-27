package vn.iotstar.Controller.api;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.model.ProductModel;
import vn.iotstar.model.Response;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping(path = "/api/product")
public class ProductApiController {
	@Autowired
	IProductService productService;
	@Autowired
	ICategoryService categoryService;
	@Autowired
	IStorageService storageService;
	
	@GetMapping
	public ResponseEntity<?> getAllProduct() {
		return new ResponseEntity<Response>(new Response(true, "Thành công", productService.findAll()),
				HttpStatus.OK);
	}
	
	@PostMapping(path = "/addProduct")
	public ResponseEntity<?> addProduct(
			@Validated @RequestParam("productName") String productName,
			@RequestParam("imageFile") MultipartFile productImages,
			@Validated @RequestParam("unitPrice") Double unitPrice,
			@Validated @RequestParam("discount") Double discount,
			@Validated @RequestParam("description") String description,
			@Validated @RequestParam("categoryId") Long categoryId,
			@Validated @RequestParam("quantity") Integer quantity,
			@Validated @RequestParam("status") Short status) {
		
		try {
			// Kiểm tra sản phẩm đã tồn tại
			Optional<Product> optProduct = productService.findByProductName(productName);
			if (optProduct.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(false, "Sản phẩm này đã tồn tại trong hệ thống", null),
					HttpStatus.BAD_REQUEST);
			}
			
			// Kiểm tra category tồn tại
			Optional<Category> optCategory = categoryService.findById(categoryId);
			if (!optCategory.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(false, "Category không tồn tại", null),
					HttpStatus.BAD_REQUEST);
			}
			
			// Tạo product mới
			Product product = new Product();
			product.setProductName(productName);
			product.setUnitPrice(unitPrice);
			product.setDiscount(discount);
			product.setDescription(description);
			product.setQuantity(quantity);
			product.setStatus(status);
			product.setCategory(optCategory.get());
			product.setCreateDate(new Timestamp(System.currentTimeMillis()));
			
			// Xử lý upload file ảnh
			if (productImages != null && !productImages.isEmpty()) {
				UUID uuid = UUID.randomUUID();
				String fileName = storageService.getSorageFilename(productImages, uuid.toString());
				storageService.store(productImages, fileName);
				product.setImages(fileName);
			}
			
			// Lưu product
			Product savedProduct = productService.save(product);
			
			return new ResponseEntity<Response>(
				new Response(true, "Thêm sản phẩm thành công", savedProduct),
				HttpStatus.OK);
				
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<Response>(
				new Response(false, "Lỗi khi thêm sản phẩm: " + e.getMessage(), null),
				HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PostMapping(path = "/getProduct")
	public ResponseEntity<?> getProduct(@RequestParam("id") Long id) {
		try {
			Optional<Product> product = productService.findById(id);
			if (product.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(true, "Thành công", product.get()), 
					HttpStatus.OK);
			} else {
				return new ResponseEntity<Response>(
					new Response(false, "Không tìm thấy sản phẩm", null), 
					HttpStatus.NOT_FOUND);
			}
		} catch (Exception e) {
			return new ResponseEntity<Response>(
				new Response(false, "Lỗi khi lấy thông tin sản phẩm: " + e.getMessage(), null),
				HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PostMapping(path = "/editProduct")
	public ResponseEntity<?> editProduct(
			@RequestParam("id") Long id,
			@Validated @RequestParam("productName") String productName,
			@RequestParam(value = "imageFile", required = false) MultipartFile productImages,
			@Validated @RequestParam("unitPrice") Double unitPrice,
			@Validated @RequestParam("discount") Double discount,
			@Validated @RequestParam("description") String description,
			@Validated @RequestParam("categoryId") Long categoryId,
			@Validated @RequestParam("quantity") Integer quantity,
			@Validated @RequestParam("status") Short status) {
		
		try {
			// Kiểm tra product tồn tại
			Optional<Product> optProduct = productService.findById(id);
			if (!optProduct.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(false, "Sản phẩm không tồn tại", null),
					HttpStatus.NOT_FOUND);
			}
			
			// Kiểm tra category tồn tại
			Optional<Category> optCategory = categoryService.findById(categoryId);
			if (!optCategory.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(false, "Category không tồn tại", null),
					HttpStatus.BAD_REQUEST);
			}
			
			// Kiểm tra tên sản phẩm trùng (trừ chính nó)
			Optional<Product> existingProduct = productService.findByProductName(productName);
			if (existingProduct.isPresent() && !existingProduct.get().getProductId().equals(id)) {
				return new ResponseEntity<Response>(
					new Response(false, "Tên sản phẩm đã tồn tại", null),
					HttpStatus.BAD_REQUEST);
			}
			
			// Cập nhật thông tin product
			Product product = optProduct.get();
			product.setProductName(productName);
			product.setUnitPrice(unitPrice);
			product.setDiscount(discount);
			product.setDescription(description);
			product.setQuantity(quantity);
			product.setStatus(status);
			product.setCategory(optCategory.get());
			
			// Xử lý upload file ảnh mới (nếu có)
			if (productImages != null && !productImages.isEmpty()) {
				UUID uuid = UUID.randomUUID();
				String fileName = storageService.getSorageFilename(productImages, uuid.toString());
				storageService.store(productImages, fileName);
				product.setImages(fileName);
			}
			
			// Lưu product
			Product updatedProduct = productService.save(product);
			
			return new ResponseEntity<Response>(
				new Response(true, "Cập nhật sản phẩm thành công", updatedProduct),
				HttpStatus.OK);
				
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<Response>(
				new Response(false, "Lỗi khi cập nhật sản phẩm: " + e.getMessage(), null),
				HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PostMapping(path = "/deleteProduct")
	public ResponseEntity<?> deleteProduct(@RequestParam("id") Long id) {
		try {
			Optional<Product> optProduct = productService.findById(id);
			if (!optProduct.isPresent()) {
				return new ResponseEntity<Response>(
					new Response(false, "Sản phẩm không tồn tại", null),
					HttpStatus.NOT_FOUND);
			}
			
			productService.deleteById(id);
			
			return new ResponseEntity<Response>(
				new Response(true, "Xóa sản phẩm thành công", null),
				HttpStatus.OK);
				
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<Response>(
				new Response(false, "Lỗi khi xóa sản phẩm: " + e.getMessage(), null),
				HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}