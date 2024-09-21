package com.my.hr.web;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.my.hr.domain.Laborer;
import com.my.hr.service.HrService;

@RestController
@RequestMapping("hr/laborer")
public class HrController {
	@Autowired private HrService hrService;
	
	@GetMapping
	public ModelAndView main(ModelAndView mv) {
		mv.setViewName("main");
		return mv;
	}
	
	@GetMapping("list")
	public List<Laborer> getLaborers() {
		return hrService.getLaborers();
	}
	
	@PostMapping("add")
	public void addLaborer(String laborerName,
			@DateTimeFormat(pattern="yyyy-MM-dd") LocalDate hireDate) {
		hrService.addLaborer(laborerName, hireDate);
	}
	
	@PutMapping("fix")
	public void fixLaborer(@RequestBody Laborer laborer) {
		hrService.fixLaborer(laborer);
	}
	
	@DeleteMapping("del/{laborerId}")
	public void delLaborer(@PathVariable int laborerId) {
		hrService.delLaborer(laborerId);
	}
}