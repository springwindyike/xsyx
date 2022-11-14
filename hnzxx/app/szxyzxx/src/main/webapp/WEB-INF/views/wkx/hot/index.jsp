<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/views/embedded/common.jsp"%>
<link href="${ctp}/res/css/extra/add.css" rel="stylesheet">
<title></title>
</head>
<body>
	<div class="container-fluid">
		<jsp:include page="/views/embedded/navigation.jsp">
			<jsp:param value="fa-asterisk" name="icon"/>
			<jsp:param value="热门微课" name="title" />
			<jsp:param value="${param.dm}" name="menuId" />
		</jsp:include>
		<div class="row-fluid">
			<div class="span12">
				<div class="content-widgets white">
					<div class="widget-head">
						<h3>
							热门微课列表
							<p class="btn_link" style="float: right;">
								<a href="javascript:void(0)" class="a3"
									onclick="$.refreshWin();"><i class="fa  fa-undo"></i>刷新列表</a>
								<a href="javascript:void(0)" class="a4"
									onclick="loadCreatePage();"><i class="fa fa-plus"></i>创建</a>
							</p>
						</h3>
					</div>
					<div class="light_grey"></div>
					<div class="content-widgets">
						<div class="widget-container">
							<div class="select_b">
								<div class="select_div">
									<span>标题：</span>
									<input type="text" id="title" name="title" style="margin-bottom: 0; padding: 6px; width: 120px;" placeholder="" value="">
								</div>
								<button type="button" class="btn btn-primary" onclick="search()">查询</button>
								<div class="clear"></div>
							</div>
							<table class="responsive table table-striped" id="data-table">
								<thead>
									<tr role="row">
<!-- 											<th style="text-align:center"><input type="checkbox" id="checkAll"/></th> -->
											<th>微课标题</th>
											<th>URL</th>
											<th>是否启用</th>
											<th>作者</th>
											<th>创建时间</th>
										<th class="caozuo" style="max-width: 250px;">操作</th>
									</tr>
								</thead>
								<tbody id="microLessonHot_list_content">
									<jsp:include page="./list.jsp" />
								</tbody>
							</table>
							<jsp:include page="/views/embedded/jqpagination.jsp" flush="true">
								<jsp:param name="id" value="microLessonHot_list_content" />
								<jsp:param name="url" value="/wkx/microlessonhot/index?sub=list&dm=${param.dm}" />
								<jsp:param name="pageSize" value="${page.pageSize}" />
							</jsp:include>
							<div class="clear"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function search() {
		var val = {};
		var title = $("#title").val();
		if (title != null && title != "") {
			val.title = title;
		}
		var id = "microLessonHot_list_content";
		var url = "/wkx/microlessonhot/index?sub=list&dm=${param.dm}";
		myPagination(id, val, url);
	}
	function changPush(id,obj,flag){
		var url = "${ctp}/wkx/microlessonhot/" + id;
		$.post(url, {"_method":"put","pushState":flag}, function(data, status) {
			if("success" === status) {
				$.success('操作成功');
				data = eval("(" + data + ")");
				if("success" === data.info) {
					if(flag == 0){
						$(obj).hide();;
						$(obj).parent().find("#push_no").show();
						$(obj).parent().parent().find("#push_state span:eq(0)").show();
						$(obj).parent().parent().find("#push_state span:eq(1)").hide();
					}else{
						$(obj).hide();
						$(obj).parent().find("#push_yes").show();
						$(obj).parent().parent().find("#push_state span:eq(1)").show();
						$(obj).parent().parent().find("#push_state span:eq(0)").hide();
					}
				} else {
					$.error("操作失败");
				}
			}else{
				$.error("操作失败");
			}
		});
	}
	// 	加载创建对话框
	function loadCreatePage() {
		$.initWinOnTopFromLeft('创建', '${ctp}/wkx/microlessonhot/create',"800","500");
	}
	//  加载编辑对话框
	function loadEditPage(id) {
		$.initWinOnTopFromLeft('编辑', '${ctp}/wkx/microlessonhot/editor?id=' + id, '700', '390');
	}
	
	function loadViewerPage(id) {
		$.initWinOnTopFromLeft('详情', '${ctp}/wkx/microlessonhot/viewer?id=' + id, '700', '300');
	}
	
	// 	删除对话框
	function deleteObj(obj, id) {
		$.confirm("确定执行此次操作？", function() {
			executeDel(obj, id);
		});
	}
	
	// 	执行删除
	function executeDel(obj, id) {
		var listLength = $("#microLessonHot_list_content tr").length;
		$.post("${ctp}/wkx/microlessonhot/" + id, {"_method" : "delete"}, function(data, status) {
			if ("success" === status) {
				if ("success" === data) {
					$.success("删除成功");
					$("#" + id + "_tr").remove();
					if(listLength <= 2){
						search();
					}
				} else if ("fail" === data) {
					$.error("删除失败，系统异常", 1);
				}
			}
		});
	}
</script>
</html>