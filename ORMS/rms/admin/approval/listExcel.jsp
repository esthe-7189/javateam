<%@ page contentType = "text/html; charset=utf8" %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.util.*,java.text.*,java.io.*,javax.servlet.*,javax.servlet.http.*" %>
<%@ page import = "mira.tokubetu.Member" %>
<%@ page import = "mira.tokubetu.MemberManager" %>
<%@ page import = "mira.approval.ApprovalBeen" %>
<%@ page import = "mira.approval.ApprovalMgr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.NumberFormat " %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "org.apache.poi.*" %>

<%! 
//static int PAGE_SIZE=20; 
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<%	
String kind=(String)session.getAttribute("KIND");
String urlPage=request.getContextPath()+"/";
String id=(String)session.getAttribute("ID");

if(kind!=null && ! kind.equals("bun")){
%>			
	<jsp:forward page="/rms/template/tempMain.jsp">		    
		<jsp:param name="CONTENTPAGE3" value="/rms/home/home.jsp" />	
	</jsp:forward>
<%
	}
        
	int level_mem=0;int mseq=0;
	MemberManager managermem=MemberManager.getInstance();
	Member member=managermem.getMember(id);
	if(member!=null){
		level_mem=member.getLevel();
		mseq=member.getMseq();
	}

	String today=dateFormat.format(new java.util.Date());	
	ApprovalMgr manager=ApprovalMgr.getInstance();			
	List  list=manager.listExcel();		
	Member memseq=null;   
	
%>
<c:set var="list" value="<%= list %>" />	
<html>
<head>
<title>OLYMPUS-RMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="http://olympus-rms.com/rms/css/eng_text.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="http://olympus-rms.com/rms/css/main.css" type="text/css">
<script  src="http://olympus-rms.com/rms/js/common.js" language="JavaScript"></script>
<script  src="http://olympus-rms.com/rms/js/Commonjs.js" language="javascript"></script>	

<%
	response.setHeader("Content-Disposition", "attachment; filename=olympus-rms.xls"); 
    	response.setHeader("Content-Description", "JSP Generated Data"); 	
%>	

<style type="text/css">
	br{mso-data=placement:same-cell;}
</style>
</head>
<body LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" background="" BORDER=0  align="center"  onLoad="javascript:resize('595','860') ;">
<center>	
<table width="98%"  border="0" >
	<tr>
		<td align="center" class="calendarLarge" colspan="8" style="mso-number-format:\@">決裁書一覧</td>							
	</tr>		
</table>				
<table width="98%" border="1"  >	 	 	
	<tr bgcolor=#F1F1F1 align=center height=26>		    
	    <th  align="center" >管理番号</th>	    
	    <th  align="center" >決裁項目</th>    
	    <th  align="center" >件名</th>
	    <th  align="center" >起案者</th>
	    <th  align="center" >原案作成者</th>
	    <th  align="center" >受付日</th>
	    <th  align="center" >決裁日</th>    
	    <th  align="center" >決裁書</th>		    		
	</tr>
<c:if test="${empty list}">
				<td colspan="8" style="mso-number-format:\@">---</td>			
</c:if>
<c:if test="${! empty list}">
<%
int i=1; String nmMseq="";
Iterator listiter=list.iterator();
	while (listiter.hasNext()){				
		ApprovalBeen db=(ApprovalBeen)listiter.next();
		int seq=db.getBseq();
		String aadd=dateFormat.format(db.getRegister());
		int mseqDb=db.getMseq();											
%>								
				
	<tr onMouseOver=this.style.backgroundColor="#EFF5F9" onMouseOut=this.style.backgroundColor="">	    
	    <td style="mso-number-format:\@"><%=db.getKanri_no()%></td>	    
	    <td  align="center" style="mso-number-format:\@"><%=db.getCate()%></td>    
	    <td style="mso-number-format:\@"> <%=db.getTitle()%></td>
	    <td style="mso-number-format:\@"><%memseq=managermem.getDbMseq(db.getGian_mseq()); if(memseq!=null){nmMseq=memseq.getNm();}else{nmMseq="--";} %> 	<%=nmMseq%></td>
	    <td style="mso-number-format:\@"><%memseq=managermem.getDbMseq(db.getGenan_mseq()); if(memseq!=null){nmMseq=memseq.getNm();}else{nmMseq="--";} %> <%=nmMseq%>   </td>
	    <td  align="center"style="mso-number-format:\@"><%=db.getDate_submit()%></td>
	    <td style="mso-number-format:\@"><font color="#007AC3"><%=db.getDate_sign()%></font>  </td>    
	    <td style="mso-number-format:\@"><%=db.getFile_nm()%> </td>		    	    
	</tr>
<%
i++;	
}
%>				
</c:if>
</table>
</body>
</html>
		
	
	
	
