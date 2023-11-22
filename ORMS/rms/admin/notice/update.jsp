<%@ page contentType = "text/html; charset=utf8"  %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "mira.notice.NewsBean" %>
<%@ page import = "mira.notice.NewsManager" %>

<jsp:useBean id="news" class="mira.notice.NewsBean">
    <jsp:setProperty name="news" property="*" />
</jsp:useBean>
<%
	String urlPage=request.getContextPath()+"/";	

	String seq=request.getParameter("seq");	
	
	NewsManager manager = NewsManager.getInstance();
	NewsBean oldBean= manager.select(news.getSeq());	
	 if(news.getContent()==null){
   	   news.setContent("No Data");
    }

if (seq != null){	
       manager.update(news);  
%>


<script language="JavaScript">
alert("処理しました。");
location.href = "<%=urlPage%>rms/admin/notice/listForm.jsp";
</script>

<%
    } else {
%>
<script>
alert("System error ");
history.go(-1);
</script>
<%
    }
%>
