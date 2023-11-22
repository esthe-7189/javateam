<%@ page contentType="text/html; charset=utf-8"%>
<%  String castleJSPVersionBaseDir = "/rms/hoan-jsp"; %>
<%@ include file = "/rms/hoan-jsp/castle_policy.jsp" %>
<%@ include file = "/rms/hoan-jsp/castle_referee.jsp" %>
<%
String contentPage3 = request.getParameter("CONTENTPAGE3");
String urlPage=request.getContextPath()+"/";	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">	
<head>
<title>OLYMPUS RMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%=urlPage%>rms/css/style.css" type="text/css">
<script type="text/javascript" src="<%=urlPage%>rms/js/fadeEffects.js"></script>
<script language="javascript" src="<%=urlPage%>rms/js/Commonjs.js"></script>
<script type="text/javascript" src="<%=urlPage%>rms/hoan-jsp/castle.js"></script>
<Link rel="shortcut icon"  href="<%=urlPage%>orms/common/favicon.ico" />

<style type="text/css">
	input.calendar { behavior:url(calendar.htc); }
</style>
<script language="JavaScript">
function setCookie( name, value, expiredays ) {
    var todayDate = new Date();
        todayDate.setDate( todayDate.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
    }

function closeWin() {
    if ( document.notice_form.chkbox.checked ){
        setCookie( "maindiv", "done" , 1 );
    }
    document.all['divpop'].style.visibility = "hidden";
}
</script>


</head>

<body  leftmargin="0"  topmargin="0"  marginwidth="0"  marginheight="0"  border="0" >
<script src="http://weblog.olympus-rms.com/hanbiro.js"></script> 	

<!-- POPUP 
<div id="divpop" style="position:absolute;left:95px;top:190;z-index:200;visibility:hidden;">
<table width=330 height=400 cellpadding=0 cellspacing=0>
<tr>
    <td style="border:0px #666666 solid" height=400 align=center bgcolor=white>
    <img src="<%=urlPage%>rms/image/pop_img201101.jpg" width="330" height="400" border="0" >
    </td>
</tr>
<tr>
        <form name="notice_form">
    <td align=right bgcolor=white>
        <input type="checkbox" name="chkbox" value="checkbox">오늘 하루 이 창을 열지 않음
        <a  onclick="closeWin();"  style="CURSOR: pointer;"  ><B>[닫기]</B></a>
    </td>
</tr>
        </form>
</table>
</div>  
<script language="Javascript">
cookiedata = document.cookie;    
if ( cookiedata.indexOf("maindiv=done") < 0 ){      
    document.all['divpop'].style.visibility = "visible";
    }
    else {
        document.all['divpop'].style.visibility = "hidden";
}
</script>
-->
<div id="loadingBar" >
	<img src="<%=urlPage%>rms/image/loader.gif"> 
	<div class="clear"></div>
	<span class="titlename">少々おまちください。</span>
	<div class="clear_margin"></div>
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value="後ろに戻る。" onClick="javascript:window.history.back();" >	
</div>
	
<div id="login_container" >	
	<div id="login_top" >
		<jsp:include page="/rms/module/topCojp.jsp" flush="false"/>
	</div>
	<div id="login_restofpage" style="display:none">
		<jsp:include page="<%= contentPage3 %>" flush="false"/>	
	</div>	
</div>

<div id="login_footer_container">
	<jsp:include page="/rms/module/footer.jsp" flush="false"/>
</div>
<script language="JavaScript">
document.getElementById('loadingBar').style.display="none";
document.getElementById('login_restofpage').style.display="";
</script>


</body>
</html>

