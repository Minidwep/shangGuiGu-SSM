<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
<title>员工列表</title>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- HTML5 shim 和 Respond.js 是为了让 IE8 支持 HTML5 元素和媒体查询（media queries）功能 -->
<!-- 警告：通过 file:// 协议（就是直接将 html 页面拖拽到浏览器中）访问页面时 Respond.js 不起作用 -->
<!--[if lt IE 9]>
      <script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
    <![endif]-->
</head>
<body>

<!-- 员工修改的模态框 -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" >员工修改</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label for="empName_update_input" class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								 <p class="form-control-static" id="empName_update_static"></p>
							</div>
						</div>
						<div class="form-group">
							<label for="email_update_input" class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_update_input" placeholder="email@atguigu.com"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_update_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_update_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<!-- 部门提交id即可 -->
								<select class="form-control" name="dId" id="dept_add_select">
								</select>
							</div>
						</div>

					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
				</div>
			</div>
		</div>
	</div>




	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label for="empName_add_input" class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<input type="text" name="empName" class="form-control"
									id="empName_add_input" placeholder="empName"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="email_add_input" class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_add_input" placeholder="email@atguigu.com"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<!-- 部门提交id即可 -->
								<select class="form-control" name="dId" id="dept_add_select">
								</select>
							</div>
						</div>

					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<div class="container">
		<!-- 标题 -->
		<div class="row ">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row ">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row ">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all" />
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>

				</table>
			</div>
		</div>
		<!-- 分页 -->
		<div class="row ">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area"></div>
		</div>

	</div>

	<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
	<script
		src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
	<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
</body>
<script type="text/javascript">
	var totalRecord;
	var currentPage;
	//1.页面加载完以后发送一个ajax请求。

	$(function() {
		//去首页
		to_page(2);
	});

	function to_page(pn) {
		$.ajax({
			url : "${APP_PATH }/emps",
			data : "pn=" + pn,
			type : "GET",
			success : function(result) {
				//console.log(result);
				//1.在页面解析并且显示员工数据
				//2.在页面解析并且显示        分页数据 
				build_emps_table(result);
				build_page_info(result);
				build_page_nav(result);
			}
		});
	}
	function build_emps_table(result) {
		//清空table表格
		$("#emps_table tbody").empty();
		var emps = result.extend.pageInfo.list;
		$
				.each(
						emps,
						function(index, item) {
							//alert(item.empName);
							var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
							var empIdTd = $("<td></td>").append(item.empId);
							var empNameTd = $("<td></td>").append(item.empName);
							var genderTd = $("<td></td>").append(
									item.gender == 'M' ? "男" : "女");
							var emailTd = $("<td></td>").append(item.email);
							var deptNameTd = $("<td></td>").append(
									item.department.deptName);
							/**
							<button type="button" class="btn btn-primary btn-sm">
							编辑 <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
							</button>
							
							<button type="button" class="btn btn-danger btn-sm">
							删除 <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
							</button>
							
							 **/
							//添加一个自定义的属性，来表示当前员工的id
							var editBtn = $("<button></button>").addClass(
									"btn btn-primary btn-sm edit_btn").append(
									$("<span></span>").addClass(
											"glyphicon glyphicon-pencil"))
									.append("编辑");
							 editBtn.attr("edit_id",item.empId);
							var delBtn = $("<button></button>").addClass(
									"delete_btn btn btn-danger btn-sm ").append(
									$("<span></span>").addClass(
											"glyphicon glyphicon-remove"))
									.append("删除");

							var delBtnT = $("<button type='button' class='btn btn-danger btn-sm '>"
									+ "删除 <span class='glyphicon glyphicon-remove' aria-hidden='true'></span>"
									+ "</button>");
							//给删除按钮添加一个自定义的属性
							delBtn.attr("del_id",item.empId);
							var btnTd = $("<td></td>").append(editBtn).append(
									" ").append(delBtn);
							//append方法执行完成以后还是返回原来的元素
							$("<tr></tr>").
							append(checkBoxTd).
							append(empIdTd).append(empNameTd)
									.append(genderTd).append(emailTd).append(
											deptNameTd).append(btnTd)
									//	.append(delBtnT)
									.appendTo("#emps_table tbody");
						});
	}

	function build_page_info(result) {
		$("#page_info_area").empty();
		$("#page_info_area").append(
				"当前" + result.extend.pageInfo.pageNum + " 页, 共有 "
						+ result.extend.pageInfo.pages + "页 , 共有 "
						+ result.extend.pageInfo.total + "条记录");
		totalRecord = result.extend.pageInfo.total;
		currentPage = result.extend.pageInfo.pageNum;
	}

	function build_page_nav(result) {
		$("#page_nav_area").empty();
		var ul = $("<ul></ul>").addClass("pagination");
		var firstPageLi = $("<li><a>首页</a></li>");
		var prePageLi = $("<li><a "
							+"aria-label='Previous'> <span aria-hidden='true'>&laquo;</span>"
				+ "</a></li>");
		if (result.extend.pageInfo.hasPreviousPage == false) {
			firstPageLi.addClass("disabled");
			prePageLi.addClass("disabled");
		} else {
			firstPageLi.click(function() {
				to_page(1);
			});

			prePageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum - 1);
			});

		}

		var nextPageLi = $("<li><a "
						+"aria-label='Next'> <span aria-hidden='true'>&raquo;</span>"
				+ "</a></li>");
		var lastPageLi = $("<li><a>末页</a></li>");
		if (result.extend.pageInfo.hasNextPage == false) {
			nextPageLi.addClass("disabled");
			lastPageLi.addClass("disabled");
		} else {
			nextPageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum + 1);
			});

			lastPageLi.click(function() {
				to_page(result.extend.pageInfo.pages);
			});

		}

		ul.append(firstPageLi).append(prePageLi);
		$.each(result.extend.pageInfo.navigatepageNums, function(index, item) {
			var numLi = $("<li><a >" + item + "</a></li>");
			if (result.extend.pageInfo.pageNum == item) {
				numLi.addClass("active");
			}
			numLi.click(function() {
				to_page(item);
			});
			ul.append(numLi);
		});

		//下一页和末页添加到ul
		ul.append(nextPageLi).append(lastPageLi);

		//ul添加到 nav
		var navEle = $("<nav></nav>").append(ul);
		navEle.appendTo("#page_nav_area");

	}

	//清空表单样式和内容
	function reset_form(ele) {
		$(ele)[0].reset();
		$(ele).find("*").removeClass("has-error has-suceess");
		$(ele).find(".help-block").text("");
	}

	//点击新增按钮弹出模态框
	$("#emp_add_modal_btn").click(function() {
		//清除表单数据
		reset_form("#empAddModal form");
		//$("#empAddModal form")[0].reset();
		//发送ajax请求，查出部门信息，显示在下拉列表中
		getDepts("#empAddModal select");
		//弹出模态框
		$("#empAddModal").modal({
			backdrop : "static"
		});
	});

	//查出所有的部门信息并显示在下拉列表中
	function getDepts(ele) {
		//清空之前下拉列表的值
		$(ele).empty();
		$.ajax({
			url : "${APP_PATH }/depts",
			type : "GET",
			success : function(result) {
				//console.log(result);
				//$("#empAddModal select").append("")
				$.each(result.extend.depts, function() {
					var potionEle = $("<option></option").append(this.deptName)
							.attr("value", this.deptId);
					potionEle.appendTo(ele);
				});
			}
		});
	}

	//校验表单数据
	function validata_add_form() {
		//1.拿到校验数据，使用正则表达式
		var empName = $("#empName_add_input").val();
		var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
		//	checkUser();

		if (!regName.test(empName)) {
			//alert("用户名可以是2到5位中文或者6到16位英文和数字的组合");
			//清空这个元素之前的样式
			//		$("#empName_add_input").parent().addClass("has-error");
			//		$("#empName_add_input").next("span").text("用户名可以是2到5位中文或者6到16位英文和数字的组合");

			//抽取方法
			show_validate_mag("#empName_add_input", "error",
					"用户名可以是2到5位中文或者6到16位英文和数字的组合");
			return false;
		} else {
			/*	if($("#empName_add_input").parent().attr("ajax-va") == "success"){
				show_validate_mag("#empName_add_input","success","用户名可用");
			} else{
				show_validate_mag("#empName_add_input","error","用户名不可用");
			}
			 */
			/*
			if($("#emp_save_btn").attr("ajax-va") == "success"){
				show_validate_mag("#empName_add_input","success","用户名可用");
			}*/
			//	show_validate_mag("#empName_add_input","success","");
			//		$("#empName_add_input").parent().addClass("has-success");
			//		$("#empName_add_input").next("span").text("");
		}
		;

		//2.校验邮箱信息
		var email = $("#email_add_input").val();
		var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if (!regEmail.test(email)) {
			//alert("邮箱格式不正确");
			//		$("#email_add_input").parent().addClass("has-error");
			//		$("#email_add_input").next("span").text("邮箱格式不正确");
			show_validate_mag("#email_add_input", "error", "邮箱格式不正确");
			return false;
		} else {
			//		$("#email_add_input").parent().addClass("has-success");
			//		$("#email_add_input").next("span").text("");
			show_validate_mag("#email_add_input", "success", "");
		}
		return true;
	}

	//抽取方法
	//显示错误信息
	function show_validate_mag(ele, status, msg) {
		//清楚当前元素校验状态
		$(ele).parent().removeClass("has-success has-error");
		$(ele).next("span").text("");
		if ("success" == status) {
			$(ele).parent().addClass("has-success");
			$(ele).next("span").text(msg);
		} else if ("error" == status) {
			$(ele).parent().addClass("has-error");
			$(ele).next("span").text(msg);
		}
	}
	/*
	function vali_time(ele){
		
		 $(ele).on('input',function(){
			 validata_add_form();
	    });
		
		 $(ele).mouseover(function () {
			 validata_add_form();
		    }).mouseout(function () {
		    	validata_add_form();
		    });
		 
		 $(ele).on('blur',function(){
			 validata_add_form();
	    });
	    
	}
	 */
	/*	
	function checkUser(){
		var empName = $("#empName_add_input").val();
		$.ajax({
			url:"${APP_PATH }/checkuser",
			data:"empName="+empName,
			type:"POST",
			success:function(result){
				if(result.code == 100){
					
				//	show_validate_mag("#empName_add_input","success","用户名可用");
					$("#emp_save_btn").attr("ajax-va","success");
					$("#empName_add_input").attr("ajax-va","success");
					$("#empName_add_input").parent().attr("ajax-va","success");
					
				} else {
				//	show_validate_mag("#empName_add_input","error",result.extend.vs_msg);
					$("#emp_save_btn").attr("ajax-va","error");
					$("#empName_add_input").attr("ajax-va","error");
					$("#empName_add_input").parent().attr("ajax-va","error");
					
				//	return false;
					
				}
			}
		});
		
	}
	 */
	/*
	 $("#empName_add_input").on('blur',function(){
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH }/checkuser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					if(result.code == 100){
						
						show_validate_mag("#empName_add_input","success","用户名可用");
						$("#emp_save_btn").attr("ajax-va","success");
					} else {
						show_validate_mag("#empName_add_input","error","用户名不可用");
						$("#emp_save_btn").attr("ajax-va","error");
					//	return false;
						
					}
				}
			});
		 
	 });
	 */

	$("#empName_add_input").change(
			function() {
				//发送ajax请求校验用户名是否可用
				var empName = this.value;
				$.ajax({
					url : "${APP_PATH }/checkuser",
					data : "empName=" + empName,
					type : "POST",
					success : function(result) {
						if (result.code == 100) {
							$("#emp_save_btn").attr("ajax-va", "success");
							show_validate_mag("#empName_add_input", "success",
									"用户名可用");
						} else {
							show_validate_mag("#empName_add_input", "error",
									result.extend.va_msg);
							$("#emp_save_btn").attr("ajax-va", "error");
						}
					}
				});
			});

	//	vali_time("#empName_add_input");
	//	vali_time("#email_add_input");

	//点击保存，保存员工。
	$("#emp_save_btn")
			.click(
				function() {
					//1.对数据进行进行校验
					/*
						if (!validata_add_form()) {
							return false;
						};
					 */
					//2.将模态框中的数据提交。
					//3.发送ajax请求 如果成功才提交。
					if ($(this).attr("ajax-va") == "error") {
						return false;
					}
					//alert($("#empAddModal form").serialize());
					$.ajax({
						url : "${APP_PATH }/emp",
						type : "POST",
						data : $("#empAddModal form").serialize(),
						success : function(result) {
							//alert(result.msg);
							if (result.code == 100) {
								//员工保存成功
								//1.关闭模态框
								$("#empAddModal").modal("hide");

								//2.来到最后一页，显示刚才保存的数据
								//发送ajax请求，显示最后一页数据
								//可以当总记录数当作页码
								to_page(totalRecord);
							} else {
								//显示失败信息
								console.log(result);
								//有那个字段的错误就显示那个字段的错误信息
								//alert(result.extend.errorFidlds.email);
								if (undefined != result.extend.errorFidlds.email) {
									//显示邮箱错误信息
									show_validate_mag(
											"#email_add_input",
											"error",
											result.extend.errorFidlds.email);

								}
								if (undefined != result.extend.errorFidlds.empName) {
									//显示员工名字错误信息
									show_validate_mag(
											"#empName_add_input",
											"error",
											result.extend.errorFidlds.empName);

								}
							}

						}
					});
			});
	
	//1.是按钮创建之前就绑定了click，所以无法绑定
	//1）可以在创建按钮的绑定 2）绑定单击事件 。LIVE事件
	//jquery新版本删除了live方法。使用on方法代替
	
	$(document).on("click",".edit_btn",function(){
		
		//alert("edit");
		//1.查出部门信息，并且显示部门列表
		getDepts("#empUpdateModal select");
		//2.查出员工信息，显示员工信息。
		getEmp($(this).attr("edit_id"));
		//3.弹出模态框
		//4.把员工id传递给模态框的更新按钮
		$("#emp_update_btn").attr("edit_id",$(this).attr("edit_id"));
		$("#empUpdateModal").modal({
			backdrop : "static"
		});
		
	});
	
	function getEmp(id){
		$.ajax({
			url:"${APP_PATH }/emp/"+id,
			type:"GET",
			success:function(result){
				//console.log(result);
				var empData = result.extend.emp;
				$("#empName_update_static").text(empData.empName);
				$("#email_update_input").val(empData.email);
				$("#empUpdateModal input[name=gender]").val([empData.gender]);
				$("#empUpdateModal select").val([empData.dId]);
			}
		});
	}
	
	//点击更新更新员工信息
	$("#emp_update_btn").click(function(){
		//验证邮箱是否合法。
		var email = $("#email_update_input").val();
		var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if (!regEmail.test(email)) {
			show_validate_mag("#email_update_input", "error", "邮箱格式不正确");
			return false;
		} else {
			show_validate_mag("#email_update_input", "success", "");
		}
		
		//2.发送ajax请求 保存更新的员工数据
		$.ajax({
			url:"${APP_PATH }/emp/"+$(this).attr("edit_id"),
			type:"PUT",
			data:$("#empUpdateModal form").serialize(),
			success:function(result){
				//alert(result.msg);
				//1.关闭模态框
				$("#empUpdateModal").modal("hide");
				//2.回到本页面
				to_page(currentPage);
			}	
			
		});
	});
	//单个删除
$(document).on("click",".delete_btn",function(){
		//1，是否确认删除对话框
		//员工姓名弹出框
		//alert($(this).parents("tr").find("td:eq(1)").text());
		var empName = $(this).parents("tr").find("td:eq(2)").text();
		var empId = $(this).attr("del_id");
		if(confirm("确认删除【"+empName+"】吗？")){
			//确认，发送ajax请求删除
			$.ajax({
				url:"${APP_PATH}/emp/"+empId,
				type:"DELETE",
				success:function(result){
					//alert(result.msg);
					to_page(currentPage);
				}
			});
		}
	});
	//完成全选/全不选
	$("#check_all").click(function(){
		//attr获取checked 是 underfunded;
		//我们这些原生的属性。使用prop获取。attr获取自定义
		//alert($(this).prop("checked"));
		$(".check_item").prop("checked",$(this).prop("checked"));
		
	});
	
	$(document).on("click",".check_item",function(){
		//判断当前选中的元素是不是5个
		//alert($(".check_item:checked").length);
		var flag = $(".check_item:checked").length == $(".check_item").length;
		$("#check_all").prop("checked",flag);
	});
	$("#emp_delete_all_btn").click(function(){
		//$(".check_item:checked")
		var empNames = "";
		var dedel_id = "";
		$.each($(".check_item:checked"),function(){
			//员工姓名
			empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
			//组装员工的id
			dedel_id += $(this).parents("tr").find("td:eq(1)").text()+"-"
			//alert($(this).parents("tr").find("td:eq(2)").text());
		});
		//去除多余的，
		empNames = empNames.substring(0,empNames.length-1);
		dedel_id = dedel_id.substring(0,dedel_id.length-1);
		if(confirm("确认删除【"+empNames+"】吗？")){
			//发送ajax
			$.ajax({
				url:"${APP_PATH}/emp/"+dedel_id,
				type:"DELETE",
				success:function(result){
					alert(result.msg);
					//回到当前页码
					to_page(currentPage);
				}
			});
		}
	});
</script>
</html>