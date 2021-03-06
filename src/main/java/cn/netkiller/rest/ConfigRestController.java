package cn.netkiller.rest;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import java.util.stream.Stream;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/v1/config")
public class ConfigRestController extends CommonRestController {

	public ConfigRestController() {
	}

	// @Autowired
	// private WithdrawRepository repository;

	@RequestMapping("version")
	@ResponseStatus(HttpStatus.OK)
	public String version() {
		return "[OK] Welcome to withdraw Restful version 1.0";
	}

//	@RequestMapping("/project/{group}/{envionment}")
//	public Enumeration<Object> project(@PathVariable String group, @PathVariable String envionment) throws IOException {
//		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s/%s.properties", group, envionment)));
//		return properties.keys();
//	}
//
//	@RequestMapping("/group")
//	public List<String> group() throws IOException {
//		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s.properties", "config")));
//		return Arrays.asList(String.valueOf(properties.get("group")).concat(",").split(","));
//	}
//	@RequestMapping("/envionment")
//	public List<String> envionment() throws IOException {
//		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s.properties", "config")));
//		return Arrays.asList(String.valueOf(properties.get("envionment")).concat(",").split(","));
//	}
	
	@RequestMapping("/group")
	public List<String> antGroup() throws IOException {
		List<String> dir= new ArrayList<String>();
		String path = String.format("%s/", this.workspace);
 		try(Stream<Path> paths = Files.walk(Paths.get(path),1)) {
		    paths.forEach(filePath -> {
		        if (Files.isDirectory(filePath)) {
		        	String project = filePath.toString().replace(path, "").replace(path.substring(0, path.length()-1), "");
		        	if(! project.equals("")){
		        		dir.add(project);
		        	}
		            
		        }
		    });
		}
		return dir;
	}
	@RequestMapping("/project/{group}")
	public List<String> project(@PathVariable String group) throws IOException {
		List<String> dir= new ArrayList<String>();
		String path = String.format("%s/%s/", this.workspace, group);
 		try(Stream<Path> paths = Files.walk(Paths.get(path),1)) {
		    paths.forEach(filePath -> {
		        if (Files.isDirectory(filePath)) {
		        	String project = filePath.toString().replace(path, "").replace(path.substring(0, path.length()-1), "");
		        	if(! project.equals("")){
		        		dir.add(project);
		        	}
		            
		        }
		    });
		}
		return dir;
	}

	@RequestMapping("/branch/{group}/{project}")
	public List<String> branch(@PathVariable String group, @PathVariable String project) throws IOException {
		List<String> dir= new ArrayList<String>();
		String path = String.format("%s/%s/%s/", this.workspace, group, project);
 		try(Stream<Path> paths = Files.walk(Paths.get(path),1)) {
		    paths.forEach(filePath -> {
		        if (Files.isDirectory(filePath)) {
		        	String branch = filePath.toString().replace(path, "").replace(path, "").replace(path.substring(0, path.length()-1), "");
		        	if(! branch.equals("")){
		        		dir.add(branch);
		        	}
		            
		        }
		    });
		}
		return dir;
	}
	@RequestMapping("/ant/build/{group}/{project}/{branch}")
	public ResponseEntity<Properties> buildfile(@PathVariable String group, @PathVariable String project, @PathVariable String branch) throws IOException {
		String path = String.format("%s/%s/%s/%s/build.properties", this.workspace, group, project, branch);
		Properties properties = new Properties();
		properties.load(new FileInputStream(path));
		return new ResponseEntity<Properties>(properties, HttpStatus.OK);
	}
	
	@RequestMapping("/build/{group}/{branch}/{project}/")
	public ResponseEntity<Properties> build(@PathVariable String group, @PathVariable String branch, @PathVariable String project) throws IOException {
		Properties properties = null;
		String workspace = String.format("%s/%s/%s/%s/build.properties", this.workspace, group, branch, project);
		File file = new File(workspace);
		if (file.exists()) {
			properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s/%s.properties", group, branch)));
		}

		return new ResponseEntity<Properties>(properties, HttpStatus.OK);
	}
	@RequestMapping("/host")
	public Enumeration<Object> host() throws IOException {
		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s.properties", "host")));
		return properties.keys();
	}

	@RequestMapping("/mail")
	public ResponseEntity<Properties> mail() throws IOException {
		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s.properties", "mail")));
		return new ResponseEntity<Properties>(properties, HttpStatus.OK);
	}
	@RequestMapping("/dns")
	public Properties dns() throws IOException {
		Properties properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(String.format("/%s.properties", "dns")));
		return properties;
	}
}
