package vn.iotstar.Controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/images")
public class ImageController {

    @GetMapping("/{filename:.+}")
    public ResponseEntity<byte[]> getImage(@PathVariable String filename) {
        try {
            Path imagePath = Paths.get("uploads", filename);
            if (Files.exists(imagePath)) {
                byte[] imageBytes = Files.readAllBytes(imagePath);
                String contentType = Files.probeContentType(imagePath);
                if (contentType == null) {
                    contentType = "image/jpeg"; // default
                }
                return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(imageBytes);
            } else {
                // Return default image if file not found
                Path defaultImagePath = Paths.get("uploads", "default.png");
                if (Files.exists(defaultImagePath)) {
                    byte[] defaultImageBytes = Files.readAllBytes(defaultImagePath);
                    return ResponseEntity.ok()
                        .contentType(MediaType.IMAGE_PNG)
                        .body(defaultImageBytes);
                }
                return ResponseEntity.notFound().build();
            }
        } catch (IOException e) {
            return ResponseEntity.notFound().build();
        }
    }
}