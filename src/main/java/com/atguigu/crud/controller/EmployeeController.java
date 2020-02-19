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
 * ����Ա����CRUD����
 * @author Jack
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * ������������һ�ķ���
	 * ����ɾ�� 1-2-3
	 * ����ɾ�� 1
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids") String ids) {
		if(ids.contains("-")) {
			//��װid �ļ���
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
	 * Ա�����·���
	 * ���ֱ�ӷ���ajax=PUT��ʽ������
	 * ��װ������  [empId=6, empName=null, gender=null, email=null, dId=null, department=null]
	 * ����
	 * �������� ������
	 * ����Employee�����װ����
	 * 
	 * ԭ��
	 * tomcat
	 * 		���������е����ݣ���װһ��map��
	 * 		request.getParameter("empName")�ͻ�����map��ȡֵ��
	 * 		SprngMVC��װPOJO�����ʱ��
	 * 			�ὫPOJO�е�ÿ�����Ե�ֵ��request.getParament("email");
	 * AJAX����PUT����������Ѫ����
	 * 		request.getParameter("empName")���ò���
	 * 		tomcat һ����put���󲻻��װ�������е�����Ϊmap,ֻ��POST��ʽ������Ż��װmap
	 * 
	 * Ҫ����Ҫ֧��put��ʽ
	 * Ҫ������HttpPutFormContentFilter
	 * ��������:���������е����ݽ�����װ��һ��map
	 * request�����°�װ��request.getParamenter()����д
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee){
		System.out.println("��Ҫ���µ�Ա�����ݣ�"+employee);
		employeeService.updataEmp(employee);
		return Msg.success();
		
	}
	
	/**
	 * ��ѯԱ��
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
	 * ����û����Ƿ����
	 * @param empName
	 * @return
	 */
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkUser(@RequestParam("empName")String empName) {
		System.out.println("testName =   "+empName);
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg","1�û���������2��5λ���Ļ���6��16λӢ�ĺ����ֵ����");
		}
		boolean b = employeeService.checkUser(empName);
		if(b) {
			return Msg.success();
		}
		return Msg.fail().add("va_msg","�û����ظ�������");
		
	}
	
	/**
	 * ֧��JSR303У��
	 * ����Hibernate-Validator
	 * @param employee
	 * @return
	 */
	
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	//@PostMapping
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee ,BindingResult result) {
		if(result.hasErrors()) {
			//У��ʧ��Ӧ�÷���ʧ�ܣ���ģ̬������ʾУ��ʧ�ܵĴ�����Ϣ
			Map<String,Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fidldError : errors) {
				System.out.println("������ֶ���"+fidldError.getField());
				System.out.println("�������Ϣ"+fidldError.getDefaultMessage());
				map.put(fidldError.getField(), fidldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFidlds", map);
		} else {
			boolean b = employeeService.checkUser(employee.getEmpName());
			if(b) {
				employeeService.saveEmp(employee);
				System.out.println("��֤2");
				return Msg.success();
			}else {
				return Msg.fail();
			}
			
		}
	}
	
	
	
	
	
	/**
	 * ��ѯԱ������(��ҳ��ѯ)
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
		//�ⲻ��һ����ҳ��ѯ
		//����PageHelper���
		//�ڲ�ѯ֮ǰ����,����ҳ�룬�Լ���ҳÿҳ�ô�С;
		PageHelper.startPage(pn, 5);
		//startPage��������ò�ѯ����һ����ҳ
		List<Employee> emps = employeeService.getAll();
		//ʹ��pageInfo��װ��ѯ��ý����ֻ��Ҫ��pageinfo����ҳ������ˡ�
		//��װ����ϸ����Ϣ��������ѯ���������ݡ�����������ʾ��ҳ����
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo",page);
		
		return "list";
	}
	
	/**
	 * ����jackson��
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
		//�ⲻ��һ����ҳ��ѯ
				//����PageHelper���
				//�ڲ�ѯ֮ǰ����,����ҳ�룬�Լ���ҳÿҳ�ô�С;
				PageHelper.startPage(pn, 5);
				//startPage��������ò�ѯ����һ����ҳ
				List<Employee> emps = employeeService.getAll();
				//ʹ��pageInfo��װ��ѯ��ý����ֻ��Ҫ��pageinfo����ҳ������ˡ�
				//��װ����ϸ����Ϣ��������ѯ���������ݡ�����������ʾ��ҳ����
				PageInfo page = new PageInfo(emps,5);
		return Msg.success().add("pageInfo",page);
		
	}

}
