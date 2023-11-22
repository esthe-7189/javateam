<%@ page contentType = "text/html; charset=utf8"  %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "mira.notice.NewsBean " %>
<%@ page import = "mira.notice.NewsManager" %>
<%
 String urlPage=request.getContextPath()+"/";	
%>
<jsp:useBean id="news" class="mira.notice.NewsBean">
	<jsp:setProperty name="news" property="*" />
</jsp:useBean>

<%
    NewsManager manager=NewsManager.getInstance();
	NewsBean oldBean = manager.select(news.getSeq());
	manager.delete(news.getSeq());
%>
<SCRIPT LANGUAGE="JavaScript">
alert("処理しました。");
location.href="<%=urlPage%>rms/admin/notice/listForm.jsp";
</SCRIPT>