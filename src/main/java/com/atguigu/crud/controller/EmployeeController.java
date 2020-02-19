package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


/**
 * 处理员工得CRUD请求
 * @author Jack
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单个批量二合一的方法
	 * 批量删除 1-2-3
	 * 单个删除 1
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids") String ids) {
		if(ids.contains("-")) {
			//组装id 的集合
			List<Integer> del_ids = new ArrayList<>();
			String[] str_ids = ids.split("-");
			for (String id : str_ids) {
				Integer idItem = Integer.parseInt(id);
				del_ids.add(idItem);
			}
			employeeService.deleteBatch(del_ids);
		} else {
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Msg.success();
	}
	/**
	 * 员工更新方法
	 * 如果直接发送ajax=PUT形式的请求
	 * 封装的数据  [empId=6, empName=null, gender=null, email=null, dId=null, department=null]
	 * 问题
	 * 请求体重 有数据
	 * 但是Employee对象封装不上
	 * 
	 * 原因：
	 * tomcat
	 * 		将请求体中的数据，封装一个map。
	 * 		request.getParameter("empName")就会从这个map中取值。
	 * 		SprngMVC封装POJO对象的时候
	 * 			会将POJO中的每个属性的值：request.getParament("email");
	 * AJAX发送PUT请求引发的血案：
	 * 		request.getParameter("empName")都拿不到
	 * 		tomcat 一看是put请求不会封装请求体中的数据为map,只有POST形式的请求才会封装map
	 * 
	 * 要是想要支持put方式
	 * 要配置上HttpPutFormContentFilter
	 * 他的作用:将请求体中的数据解析包装成一个map
	 * request呗重新包装，request.getParamenter()被重写
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee){
		System.out.println("将要更新的员工数据："+employee);
		employeeService.updataEmp(employee);
		return Msg.success();
		
	}
	
	/**
	 * 查询员工
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		
		Employee emp = employeeService.getEmp(id);
		return Msg.success().add("emp", emp);
	}
	
	/**
	 * 检查用户名是否可用
	 * @param empName
	 * @return
	 */
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkUser(@RequestParam("empName")String empName) {
		System.out.println("testName =   "+empName);
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg","1用户名可以是2到5位中文或者6到16位英文和数字的组合");
		}
		boolean b = employeeService.checkUser(empName);
		if(b) {
			return Msg.success();
		}
		return Msg.fail().add("va_msg","用户名重复不可用");
		
	}
	
	/**
	 * 支持JSR303校验
	 * 导入Hibernate-Validator
	 * @param employee
	 * @return
	 */
	
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	//@PostMapping
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee ,BindingResult result) {
		if(result.hasErrors()) {
			//校验失败应该返回失败，在模态框中显示校验失败的错误信息
			Map<String,Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fidldError : errors) {
				System.out.println("错误的字段名"+fidldError.getField());
				System.out.println("错误的信息"+fidldError.getDefaultMessage());
				map.put(fidldError.getField(), fidldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFidlds", map);
		} else {
			boolean b = employeeService.checkUser(employee.getEmpName());
			if(b) {
				employeeService.saveEmp(employee);
				System.out.println("验证2");
				return Msg.success();
			}else {
				return Msg.fail();
			}
			
		}
	}
	
	
	
	
	
	/**
	 * 查询员工数据(分页查询)
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
		//这不是一个分页查询
		//引入PageHelper插件
		//在查询之前调用,传入页码，以及分页每页得大小;
		PageHelper.startPage(pn, 5);
		//startPage后面紧跟得查询就是一个分页
		List<Employee> emps = employeeService.getAll();
		//使用pageInfo包装查询后得结果，只需要将pageinfo交给页面就行了。
		//封装了详细得信息，包括查询出来的数据。传入连续显示得页数。
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo",page);
		
		return "list";
	}
	
	/**
	 * 导入jackson包
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
		//这不是一个分页查询
				//引入PageHelper插件
				//在查询之前调用,传入页码，以及分页每页得大小;
				PageHelper.startPage(pn, 5);
				//startPage后面紧跟得查询就是一个分页
				List<Employee> emps = employeeService.getAll();
				//使用pageInfo包装查询后得结果，只需要将pageinfo交给页面就行了。
				//封装了详细得信息，包括查询出来的数据。传入连续显示得页数。
				PageInfo page = new PageInfo(emps,5);
		return Msg.success().add("pageInfo",page);
		
	}

}
