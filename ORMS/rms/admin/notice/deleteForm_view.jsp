<%@ page contentType = "text/html; charset=utf8"  %>
<%@ page pageEncoding = "utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "mira.notice.NewsBean " %>
<%@ page import = "mira.notice.NewsManager" %>

<%

String urlPage=request.getContextPath()+"/";	
int seq = Integer.parseInt(request.getParameter("seq"));

    NewsManager manager = NewsManager.getInstance();
    NewsBean news = manager.select(seq);
%>
<c:set var="news" value="<%= news %>" />	
<c:if test="${! empty news}"/>	
<img src="<%=urlPage%>rms/image/icon_ball.gif" >
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=60);">
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=30);"><span class="calendar7">お知らせ <font color="#A2A2A2">></font> 削除 </span> 
<div class="clear_line_gray"></div>
<p>
<div id="botton_position">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value="全体目録" onClick="location.href='<%=urlPage%>rms/admin/notice/listForm.jsp'">
</div>

<div id="boxNoLine_850"  >		
<label class="calendar9">
			<img src="<%=urlPage%>rms/image/icon_s.gif" >
			<img src="<%=urlPage%>rms/image/icon_s.gif" style="filter:Alpha(Opacity=60);">
			<img src="<%=urlPage%>rms/image/icon_s.gif" style="filter:Alpha(Opacity=30);">ファイル削除
</label>	
<table width="850"  class="tablebox" cellspacing="2" cellpadding="2">	
	<form action="<%=urlPage%>rms/admin/notice/delete.jsp" method="post"  name="resultform"  >		
		<input type="hidden" name="seq" value="${news.seq}">								
		<tr>
			<td align="center"  class="titlename">						
				<font color="#CC0000">※</font>タイトル : ${news.title}									
				</td>
			</tr>
			<tr>
				<td align="center"  >上の内容を削除しますか?	</td>
			</tr>
	</table>
<table width="880"  cellspacing="5" cellpadding="5">
	<tr>
		<td align="center" style="padding:15px100px 100px 0px;">
			<input type="image"  style=cursor:pointer  src="<%=urlPage%>rms/image/admin/btn_jp_del.gif" onfocus="this.blur()">
			<a href="javascript:javascript:history.go(-1)" onfocus="this.blur()"><img src="<%=urlPage%>rms/image/admin/btn_jp_x.gif"></a>
			
		</td>
	</tr>
</form>
</table>
</div>
			
	
			
			
			
			