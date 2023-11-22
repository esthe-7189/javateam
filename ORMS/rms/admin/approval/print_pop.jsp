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
<link href="<%=urlPage%>rms/css/eng_text.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=urlPage%>rms/css/main.css" type="text/css">
<script  src="<%=urlPage%>rms/js/common.js" language="JavaScript"></script>
<script  src="<%=urlPage%>rms/js/Commonjs.js" language="javascript"></script>

<script language="javascript">
function resize(width, height){	
	window.resizeTo(width, height);
}
function printa(){
	window.print();
}
function printExplain(){		
	openNoScrollWin("<%=urlPage%>rms/admin/printExplain_pop.jsp", "print", "print", "730", "585","");
}
</script>	

</head>
<body LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" background="" BORDER=0  align="center"  onLoad="javascript:resize('700','600') ;">
<center>

	<table width="100%"  border="0" cellpadding=1 cellspacing=0 >
			<tr>
				<td align="center"  class="calendar15" style="padding: 10px 0px 0px 0px">決裁書一覧</td>							
			</tr>		
	</table>
<table width="100%"  border=0 >
	<tr>
		<td align="right" >
<input type="button" class="cc" onClick="printExplain();" onfocus="this.blur();" style=cursor:pointer value=" 印刷方法 >>">
<input type="button" class="cc" onClick="printa();" onfocus="this.blur();" style=cursor:pointer value=" 印刷 >>">
<input type="button" class="cc" onClick="window.close();" onfocus="this.blur();" style=cursor:pointer value=" 閉じる >>">
		</td>							
	</tr>		
</table>
<table width="98%"  border=1 cellpadding=1 cellspacing=0 bordercolor=#FFFFFF bordercolorlight=#000000>
	<tr bgcolor=#F1F1F1 align=center height=29>	
	    	<td  width="8%" class="title_list_all">管理No.</td>	    
	   	<td  width="15%" class="title_list_m_r">決裁項目</td>    
	    	<td  width="20%" class="title_list_m_r">件名</td>	    	
	    	<td  width="9%" class="title_list_m_r">起案者</td>
		<td  width="9%" class="title_list_m_r">原案作成者</td>
		<td  width="13%" class="title_list_m_r">受付日</td>
	    	<td  width="13%" class="title_list_m_r">決裁日</td>
		<td  width="13%" class="title_list_m_r">決裁書</td>	    		
	</tr>
<c:if test="${empty list}">
				<td colspan="8" >---</td>			
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
				
	<tr>	    
	    <td ><%=db.getKanri_no()%></td>	    
	    <td ><%=db.getCate()%></td>    
	    <td > <%=db.getTitle()%></td>
	    <td ><%memseq=managermem.getDbMseq(db.getGian_mseq()); if(memseq!=null){nmMseq=memseq.getNm();}else{nmMseq="--";} %> 	<%=nmMseq%></td>
	    <td ><%memseq=managermem.getDbMseq(db.getGenan_mseq()); if(memseq!=null){nmMseq=memseq.getNm();}else{nmMseq="--";} %> <%=nmMseq%>   </td>
	    <td><%=db.getDate_submit()%></td>
	    <td ><font color="#007AC3"><%=db.getDate_sign()%></font>  </td>    
	    <td ><%=db.getFile_nm()%> </td>		    	    
	</tr>
<%
i++;	
}
%>				
</c:if>
</table>
<table width="100%"  border=0 >
	<tr>
		<td align="right" >
<input type="button" class="cc" onClick="printExplain();" onfocus="this.blur();" style=cursor:pointer value=" 印刷方法 >>">
<input type="button" class="cc" onClick="printa();" onfocus="this.blur();" style=cursor:pointer value=" 印刷 >>">
<input type="button" class="cc" onClick="window.close();" onfocus="this.blur();" style=cursor:pointer value=" 閉じる >>">
		</td>							
	</tr>		
</table>
</body>
</html>													