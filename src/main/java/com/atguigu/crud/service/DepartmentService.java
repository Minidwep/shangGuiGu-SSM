package com.atguigu.crud.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Department;
import java.util.*;
import com.atguigu.crud.dao.DepartmentMapper;


@Service
public class DepartmentService {

	@Autowired
	private DepartmentMapper departmentMapper;
	
	public List<Department> getDepts() {
;		List<Department> list = departmentMapper.selectByExample(null);
		// TODO Auto-generated method stub
		return list;
	}

	
}
