package cn.netkiller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/domain")
public class DomainController {

	public DomainController() {
		// TODO Auto-generated constructor stub
	}
	@RequestMapping("/")
	public ModelAndView manual() {
		
		return new ModelAndView("domain/index");

	}
}
