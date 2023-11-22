<%@ page contentType = "text/html; charset=utf8"  import="java.util.*"%>
<%@ page pageEncoding = "utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%	
String urlPage=request.getContextPath()+"/";	


%>


<html>
<head>
<title>OLYMPUS-RMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=urlPage%>rms/css/eng_text.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=urlPage%>rms/css/main.css" type="text/css">
<script  src="<%=urlPage%>rms/js/common.js" language="JavaScript"></script>
<script  src="<%=urlPage%>rms/js/Commonjs.js" language="javascript"></script>

<script language="javascript">
function resize(width, height){	
	window.resizeTo(width, height);      
}
</script>	

</head>
<body LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" background="" BORDER=0  align="center"  onLoad="javascript:resize('760','550');">
<center>
<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0" > 	
  <tr>
    <td style="padding: 2 0 2 0;">
    	<img src="<%=urlPage%>rms/image/admin/listDownExplain.gif" align="absmiddle">        	
    </td>
  </tr>   
</table>
</center>

