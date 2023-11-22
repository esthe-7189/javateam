<%@ page contentType="text/html; charset=utf-8"%>
<%@ page pageEncoding = "utf-8" %>
<%  String castleJSPVersionBaseDir = "/rms/hoan-jsp"; %>
<%@ include file = "/rms/hoan-jsp/castle_policy.jsp" %>
<%@ include file = "/rms/hoan-jsp/castle_referee.jsp" %>

<%
String contentPage3 = request.getParameter("CONTENTPAGE3");
String contextPath=request.getContextPath()+"/";	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title>OLYMPUS RMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%=contextPath%>rms/css/style.css" type="text/css">
<script type="text/javascript" src="<%=contextPath%>rms/js/fadeEffects.js"></script>
<script type="text/javascript" language="javascript" src="<%=contextPath%>rms/js/drag.js"></script>
<link rel="stylesheet" href="<%=contextPath%>fckeditor/_sample/sample.css" type="text/css">
<script  src="<%=contextPath%>fckeditor/fckeditor.js" type="text/javascript"></script>
<script  src="<%=contextPath%>rms/js/common.js" language="JavaScript"></script>
<script  src="<%=contextPath%>rms/js/Commonjs.js" language="javascript"></script>
<script language="javascript" type="text/javascript" src="<%=contextPath%>rms/js/calendar_rms.js"></script>
<script language="javascript" type="text/javascript" src="<%=contextPath%>rms/js/QuickView.js"></script>
<script type="text/javascript" src="<%=contextPath%>rms/hoan-jsp/castle.js"></script>
<Link rel="shortcut icon"  href="<%=contextPath%>orms/common/favicon.ico" />
<style type="text/css">
	input.calendar { behavior:url(calendar.htc); }
</style>
	
</head>

<body  leftmargin="0"  topmargin="0"  marginwidth="0"  marginheight="0"  border="0" align="center" oncontextmenu="return true" onselectstart="return true" ondragstart="return true">
<script src="http://weblog.olympus-rms.com/hanbiro.js"></script> 
<div id="loadingBar" >
	<img src="<%=contextPath%>rms/image/loader.gif"> 
	<div class="clear"></div>
	<span class="titlename">少々おまちください。</span>
	<div class="clear_margin"></div>
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value="後ろに戻る。" onClick="javascript:window.history.back();" >	
</div>
<div id="main_container">	
	<div id="myheader" onmousedown="dropMenu()" >
		<jsp:include page="/rms/module/top_admin_toku.jsp" flush="false"/>
	</div>
	<div id="restofpage"  style="display:none">
		<jsp:include page="<%= contentPage3 %>" flush="false"/>	
	</div>	
</div>

<script language="JavaScript">
document.getElementById('loadingBar').style.display="none";
document.getElementById('restofpage').style.display="";
</script>
</body>
</html>


