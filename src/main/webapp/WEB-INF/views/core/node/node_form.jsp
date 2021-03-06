<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Jspxcms管理平台 - Powered by Jspxcms</title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>
<style type="text/css">
</style>
<script type="text/javascript">
$(function() {
	$("#validForm").validate();
	$("input[name='name']").focus();
	//setTimeout(function() {
	//	$("#color").colorPicker();
	//},0);
	
});
function uploadImg(name,button) {
	if($("#f_"+name).val()=="") {alert("<s:message code='pleaseSelectTheFile'/>");return;}
	Cms.uploadImg("../upload_image.do",name,button);
}
function imgCrop(name) {
	if($("#"+name).val()=="") {alert("<s:message code='noImageToCrop'/>");return;}
	Cms.imgCrop("../../commons/img_area_select.do",name);
}
function confirmDelete() {
	return confirm("<s:message code='confirmDelete'/>");
}
<c:if test="${!empty refreshLeft}">
parent.frames['left'].location.href="left.do";
</c:if>
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="node.management"/> - <s:message code="${oprt=='edit' ? 'edit' : 'create'}"/></span>
</div>
<form id="validForm" action="${oprt=='edit' ? 'update' : 'save'}.do" method="post">
<tags:search_params/>
<f:hidden name="cid" value="${oprt=='create' ? cid : ''}"/>
<f:hidden name="oid" value="${bean.id}"/>
<f:hidden name="queryParentId" value="${queryParentId}"/>
<f:hidden name="showDescendants" value="${showDescendants}"/>
<f:hidden name="position" value="${position}"/>
<input type="hidden" id="redirect" name="redirect" value="edit"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="4" class="in-opt">
			<shiro:hasPermission name="core:node:create">
			<div class="in-btn"><input type="button" value="<s:message code="create"/>" onclick="location.href='create.do?parentId=${parent.id}&infoModelId=${bean.infoModel.id}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"<c:if test="${oprt=='create'||parent==null}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"><input type="button" value="<s:message code="node.createChild"/>" onclick="location.href='create.do?parentId=${bean.id}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:node:copy">
			<div class="in-btn"><input type="button" value="<s:message code="copy"/>" onclick="location.href='create.do?cid=${bean.id}&parentId=${parent.id}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"<c:if test="${oprt=='create'||parent==null}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:node:delete">
			<div class="in-btn"><input type="button" value="<s:message code="delete"/>" onclick="if(confirmDelete()){location.href='delete.do?ids=${bean.id}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';}"<c:if test="${oprt=='create'||parent==null}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="prev"/>" onclick="location.href='edit.do?id=${side.prev.id}&position=${position-1}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"<c:if test="${empty side.prev}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"><input type="button" value="<s:message code="next"/>" onclick="location.href='edit.do?id=${side.next.id}&position=${position+1}&queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"<c:if test="${empty side.next}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <c:set var="colCount" value="${0}"/>
  <c:forEach var="field" items="${model.normalFields}">
  <c:if test="${colCount%2==0||!field.dblColumn}"><tr></c:if>
  <td class="in-lab" width="15%"><c:if test="${field.required}"><em class="required">*</em></c:if><c:out value="${field.label}"/>:</td>
  <td<c:if test="${field.type!=50}"> class="in-ctt"</c:if><c:choose><c:when test="${field.dblColumn}"> width="35%"</c:when><c:otherwise> width="85%" colspan="3"</c:otherwise></c:choose>>
  <c:choose>
  <c:when test="${field.custom || field.innerType == 3}">
  	<tags:feild_custom bean="${bean}" field="${field}"/>
  </c:when>
  <c:otherwise>
  <c:choose>
  <c:when test="${field.name eq 'parent'}">
    <f:hidden id="parentId" name="parentId" value="${parent.id}"/>
    <f:hidden id="parentIdNumber" value="${parent.id}"/>
    <f:text id="parentIdName" value="${parent.displayName}" readonly="readonly" style="width:160px;"/><input id="parentIdButton" type="button" value="<s:message code='choose'/>"/>
    <script type="text/javascript">
    $(function(){
    	Cms.f7.nodeNodePerm("parentId","parentIdName",{
    		"settings": {"title": "<s:message code='node.f7.selectNode'/>"},
    		"params": {
    			"excludeChildrenId":"${oprt=='edit' ? bean.id : ''}"
    		}
    	});
    });
    </script>
  </c:when>
  <c:when test="${field.name eq 'name'}">
    <f:text name="name" value="${oprt=='edit' ? bean.name : ''}" class="required" maxlength="100" style="width:180px;"/>
  </c:when>
  <c:when test="${field.name eq 'number'}">
    <f:text name="number" value="${bean.number}" maxlength="100" style="width:180px;"/>
  </c:when>
  <c:when test="${field.name eq 'link'}">
    <f:text name="link" value="${bean.link}" maxlength="255" style="width:180px;"/><span class="in-prompt" title="<s:message code='node.link.prompt' htmlEscape='true'/>"></span>
  </c:when>
  <c:when test="${field.name eq 'newWindow'}">
  	<select name="newWindow">
  		<option value=""><s:message code="defaultSelect"/></option>
      <f:option value="true" selected="${bean.newWindow}"><s:message code="yes"/></f:option>
      <f:option value="false" selected="${bean.newWindow}"><s:message code="no"/></f:option>
  	</select>
  </c:when>
  <c:when test="${field.name eq 'metaKeywords'}">
    <f:text name="metaKeywords" value="${bean.metaKeywords}" maxlength="150" style="width:500px;"/>
  </c:when>
  <c:when test="${field.name eq 'metaDescription'}">
    <f:textarea name="metaDescription" value="${bean.metaDescription}" maxlength="450" style="width:500px;height:80px;"/>
  </c:when>
  <c:when test="${field.name eq 'workflow'}">
    <select name="workflowId">
    	<option value=""><s:message code="noneSelect"/></option>
      <f:options items="${workflowList}" itemLabel="name" itemValue="id" selected="${bean.workflow.id}"/>
    </select>
  </c:when>
  <c:when test="${field.name eq 'infoPerms'}">
  	<input type="hidden" name="infoPermIdsExist" value="true"/>
  	<c:forEach var="role" items="${roleList}">
			<label><input type="checkbox" name="infoPermIds" value="${role.id}"<c:if test="${fnx:contains_co(bean.infoPerms,role) || role.allInfoPerm || empty bean}"> checked="checked"</c:if><c:if test="${role.allInfoPerm}"> disabled="disabled"</c:if>/>${role.name}</label>
  	</c:forEach>
  </c:when>
  <c:when test="${field.name eq 'nodePerms'}">
  	<input type="hidden" name="nodePermIdsExist" value="true"/>
  	<c:forEach var="role" items="${roleList}">
			<label><input type="checkbox" name="nodePermIds" value="${role.id}"<c:if test="${fnx:contains_co(bean.nodePerms,role) || role.allNodePerm || empty bean}"> checked="checked"</c:if><c:if test="${role.allNodePerm}"> disabled="disabled"</c:if>/>${role.name}</label>
  	</c:forEach>
  </c:when>
  <c:when test="${field.name eq 'viewGroups'}">
  	<input type="hidden" name="viewGroupIdsExist" value="true"/>
  	<s:message code="node.groups"/>:
  	<c:forEach var="group" items="${groupList}">
			<label><input type="checkbox" name="viewGroupIds" value="${group.id}"<c:if test="${fnx:contains_co(bean.viewGroups,group) || empty bean}"> checked="checked"</c:if>/>${group.name}</label>
  	</c:forEach>
  	<div id="viewOrgIds">
	  	<c:set var="viewOrgs" value="${bean.viewOrgs}"/>
	  	<c:forEach var="n" items="${viewOrgs}">
	  		<f:hidden name="viewOrgIds" value="${n.id}"/>
	  	</c:forEach>
  	</div>
  	<div id="viewOrgIdsNumber">
	  	<c:forEach var="n" items="${viewOrgs}">
	  		<f:hidden name="viewOrgIdsNumber" value="${n.id}"/>
	  	</c:forEach>
  	</div>
  	<div id="viewOrgIdsName">
	  	<c:forEach var="n" items="${viewOrgs}">
	  		<f:hidden name="viewOrgIdsName" value="${n.displayName}"/>
	  	</c:forEach>
	  </div>
  	<s:message code="node.orgs"/>:
    <f:text id="viewOrgIdsNameDisplay" value="" readonly="readonly" style="width:160px;"/><input id="viewOrgIdsButton" type="button" value="<s:message code='choose'/>"/>
    <script type="text/javascript">
    $(function(){
    	Cms.f7.orgMulti("viewOrgIds",{
    		settings: {"title": "<s:message code='org.f7.selectOrg'/>"},
    		params: {"treeNumber": "${orgTreeNumber}"}
    	});
    });
    </script>
  </c:when>
  <c:when test="${field.name eq 'contriGroups'}">
  	<input type="hidden" name="contriGroupIdsExist" value="true"/>
  	<c:forEach var="group" items="${groupList}">
			<label><input type="checkbox" name="contriGroupIds" value="${group.id}"<c:if test="${fnx:contains_co(bean.contriGroups,group) || empty bean}"> checked="checked"</c:if>/>${group.name}</label>
  	</c:forEach>
  </c:when>
  <c:when test="${field.name eq 'commentGroups'}">
  	<input type="hidden" name="commentGroupIdsExist" value="true"/>
  	<c:forEach var="group" items="${groupList}">
			<label><input type="checkbox" name="commentGroupIds" value="${group.id}"<c:if test="${fnx:contains_co(bean.commentGroups,group) || empty bean}"> checked="checked"</c:if>/>${group.name}</label>
  	</c:forEach>
  </c:when>
  <c:when test="${field.name eq 'nodeModel'}">
    <select name="nodeModelId" onchange="location.href='${oprt=='edit' ? 'edit' : 'create'}.do?id=${bean.id}&parentId=${parent.id}&modelId='+$(this).val()+'&${searchstring}';">
      <f:options items="${nodeModelList}" itemLabel="name" itemValue="id" selected="${model.id}" default="${bean.nodeModel.id}"/>
    </select>
  </c:when>
  <c:when test="${field.name eq 'infoModel'}">
    <select name="infoModelId">
      <option value=""><s:message code="noneSelect"/></option>
      <f:options items="${infoModelList}" itemLabel="name" itemValue="id" selected="${infoModel.id}"/>
    </select>
  </c:when>
  <c:when test="${field.name eq 'nodeTemplate'}">
    <f:text id="nodeTemplate" name="nodeTemplate" value="${bean.nodeTemplate}" maxlength="255" style="width:160px;"/><input id="nodeTemplateButton" type="button" value="<s:message code='choose'/>"/>
    <script type="text/javascript">
    $(function(){
    	Cms.f7.template("nodeTemplate",{
    		settings: {"title": "<s:message code="webFile.chooseTemplate"/>"}
    	});
    });
    </script>
  </c:when>
  <c:when test="${field.name eq 'infoTemplate'}">
    <f:text id="infoTemplate" name="infoTemplate" value="${bean.infoTemplate}" maxlength="255" style="width:160px;"/><input id="infoTemplateButton" type="button" value="<s:message code='choose'/>"/>
    <script type="text/javascript">
    $(function(){
    	Cms.f7.template("infoTemplate",{
    		settings: {"title": "<s:message code="webFile.chooseTemplate"/>"}
    	});
    });
    </script>
  </c:when>
  <c:when test="${field.name eq 'staticMethod'}">
    <select name="staticMethod">
      <option value=""><s:message code="defaultSelect"/></option>
      <f:option value="0" selected="${bean.staticMethod}"><s:message code="node.staticMethod.0"/></f:option>
      <f:option value="1" selected="${bean.staticMethod}"><s:message code="node.staticMethod.1"/></f:option>
      <f:option value="2" selected="${bean.staticMethod}"><s:message code="node.staticMethod.2"/></f:option>
      <f:option value="3" selected="${bean.staticMethod}"><s:message code="node.staticMethod.3"/></f:option>
      <f:option value="4" selected="${bean.staticMethod}"><s:message code="node.staticMethod.4"/></f:option>
    </select>
  </c:when>
  <c:when test="${field.name eq 'staticPage'}">
    <f:text name="staticPage" value="${bean.staticPage}" class="{digits:true,min:1,max:2147483647}" maxlength="10" style="width:180px;"/>
  </c:when>
  <c:when test="${field.name eq 'generateNode'}">
  	<select name="generateNode">
      <option value=""><s:message code="defaultSelect"/></option>
      <f:option value="true" selected="${bean.generateNode}"><s:message code="on"/></f:option>
      <f:option value="false" selected="${bean.generateNode}"><s:message code="off"/></f:option>
  	</select> &nbsp;
    <f:text name="nodePath" value="${bean.nodePath}" style="text-align:right;width:300px;"/>
    <select name="nodeExtension">
      <option value="">---<s:message code="node.extension"/>---</option>
      <f:options items="${fn:split('.html,.htm,.shtml',',')}" selected="${bean.nodeExtension}"/>
    </select> &nbsp;
    <select name="defPage">
      <option value="">---<s:message code="node.defPage"/>---</option>
      <f:option value="true" selected="${bean.defPage}"><s:message code="yes"/></f:option>
      <f:option value="false" selected="${bean.defPage}"><s:message code="no"/></f:option>
    </select>
  </c:when>
  <c:when test="${field.name eq 'generateInfo'}">
  	<select name="generateInfo">
      <option value=""><s:message code="defaultSelect"/></option>
      <f:option value="true" selected="${bean.generateInfo}"><s:message code="on"/></f:option>
      <f:option value="false" selected="${bean.generateInfo}"><s:message code="off"/></f:option>
  	</select> &nbsp;
    <f:text name="infoPath" value="${bean.infoPath}" style="text-align:right;width:300px;"/>
    <select name="infoExtension">
      <option value="">---<s:message code="node.extension"/>---</option>
      <f:options items="${fn:split('.html,.htm,.shtml',',')}" selected="${bean.infoExtension}"/>
    </select>
  </c:when>
  <c:when test="${field.name eq 'smallImage'}">
      <tags:image_upload name="smallImage" value="${bean.smallImage}" width="${field.customs['imageWidth']}" height="${field.customs['imageHeight']}" watermark="${field.customs['imageWatermark']}" scale="${field.customs['imageScale']}" exact="${field.customs['imageExact']}"/>
  </c:when>
  <c:when test="${field.name eq 'largeImage'}">
      <tags:image_upload name="largeImage" value="${bean.largeImage}" width="${field.customs['imageWidth']}" height="${field.customs['imageHeight']}" watermark="${field.customs['imageWatermark']}" scale="${field.customs['imageScale']}" exact="${field.customs['imageExact']}"/>
  </c:when>
  <c:otherwise>
    System field not found: '${field.name}'
  </c:otherwise>
  </c:choose>
  </c:otherwise>
  </c:choose>
  </td><c:if test="${colCount%2==1||!field.dblColumn}"></tr></c:if>
  <c:if test="${field.dblColumn}"><c:set var="colCount" value="${colCount+1}"/></c:if>
  </c:forEach>
</table>
<c:forEach var="field" items="${model.editorFields}">
  <div style="padding:5px 3px;">
	  <c:if test="${field.required}"><em class="required">*</em></c:if><c:out value="${field.label}"/>:
	  <span id="editorRadio_${field.name}" style="margin-left:5px;">
			<f:radio id="editorRadioUeditor_${field.name}" name="customs_${field.name}_editor_type" checked="${bean.customs[fnx:concat(field.name,'_editor_type')]}" default="${empty field.customs['editorDefault'] ? 'ueditor' : field.customs['editorDefault']}" value="ueditor" onclick="create_ueditor_${field.name}(delete_editormd_${field.name}());"/><label for="editorRadioUeditor_${field.name}">Ueditor</label>
			<f:radio id="editorRadioEditormd_${field.name}" name="customs_${field.name}_editor_type" checked="${bean.customs[fnx:concat(field.name,'_editor_type')]}" default="${field.customs['editorDefault']}" value="editormd" onclick="create_editormd_${field.name}(delete_ueditor_${field.name}());"/><label for="editorRadioEditormd_${field.name}">Editor.md</label>
		</span>
		<script type="text/javascript">$("#editorRadio_${field.name}").buttonset();</script>
  </div>
	<div>
	 <tags:feild_custom bean="${bean}" field="${field}"/>
	</div>
</c:forEach>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb">
  <tr>
    <td colspan="4" class="in-opt">
      <div class="in-btn"><input type="submit" value="<s:message code="save"/>"/></div>
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndReturn"/>" onclick="$('#redirect').val('list');"/></div>
      <c:if test="${oprt=='create'}">
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndCreate"/>" onclick="$('#redirect').val('create');"/></div>
      </c:if>
      <div style="clear:both;"></div>
    </td>
  </tr>
</table>
</form>
</body>
</html>