
<%@ page contentType = "text/html; charset=utf8" %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "mira.notice.NewsBean" %>
<%@ page import = "mira.notice.NewsManager" %>

<jsp:useBean id="notice" class="mira.notice.NewsBean">
    <jsp:setProperty name="notice" property="*" />
</jsp:useBean>


<%
String urlPage=request.getContextPath()+"/";
   notice.setRegister(new Timestamp(System.currentTimeMillis()));     
   NewsManager manager = NewsManager.getInstance();    
   if(notice.getContent()==null){
   	   notice.setContent("No Data");
    }
   manager.insert(notice);
%>

<script language="JavaScript">
alert("処理しました。");
location.href = "<%=urlPage%>rms/admin/notice/listForm.jsp";
</script>
