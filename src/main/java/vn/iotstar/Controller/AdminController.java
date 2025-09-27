package vn.iotstar.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("/categories")
    public String categoryManagement() {
        return "admin/categories/list";
    }
    
    @GetMapping("")
    public String adminHome() {
        return "admin/admin";
    }
}