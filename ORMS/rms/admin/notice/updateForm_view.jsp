<%@ page contentType = "text/html; charset=utf8"  %>
<%@ page pageEncoding = "utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://fckeditor.net/tags-fckeditor" prefix="FCK" %>	
<%@ page import = "java.util.List,java.io.*,javax.servlet.*,javax.servlet.http.*,java.text.*" %>
<%@ page import = "mira.notice.NewsBean" %>
<%@ page import = "mira.notice.NewsManager" %>

<%! SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");	%>
<%
String today=formatter.format(new java.util.Date());	
String urlPage=request.getContextPath()+"/";	
String seq=request.getParameter("seq");

NewsManager manager = NewsManager.getInstance();	
NewsBean news=manager.select(Integer.parseInt(seq));
%>
<c:set var="news" value="<%=news%>"/>

<script type="text/javascript">
// 카테고리 코드 가져오기


function goWrite(){
	var frm = document.resultform;	
	if(isEmpty(frm.title, "タイトルを書いて下さい!")) return;	
		
if ( confirm("修正しますか?") != 1 ) {
		return;
	}
frm.action = "<%=urlPage%>rms/admin/notice/update.jsp";	
frm.submit();	
	
	
}	

</script>
<script type="text/javascript">
function FCKeditor_OnComplete( editorInstance ){
	var oCombo = document.getElementById( 'cmbLanguages' ) ;
	for ( code in editorInstance.Language.AvailableLanguages )	{
		AddComboOption( oCombo, editorInstance.Language.AvailableLanguages[code] + ' (' + code + ')', code ) ;
	}
	oCombo.value = editorInstance.Language.ActiveLanguage.Code ;
}	

function AddComboOption(combo, optionText, optionValue){
	var oOption = document.createElement("OPTION") ;
	combo.options.add(oOption) ;
	oOption.innerHTML = optionText ;
	oOption.value     = optionValue ;	
	return oOption ;
}

function ChangeLanguage( languageCode ){
	window.location.href = window.location.pathname + "?code=" + languageCode ;
}
</script>
<%
String autoDetectLanguageStr;
String defaultLanguageStr;
String codeStr=request.getParameter("code");
if(codeStr==null) {
	autoDetectLanguageStr="true";
	defaultLanguageStr="en";
}
else {
	autoDetectLanguageStr="false";
	defaultLanguageStr=codeStr;
}
%>
<img src="<%=urlPage%>rms/image/icon_ball.gif" >
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=60);">
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=30);"><span class="calendar7">お知らせ<font color="#A2A2A2">></font>修正</span> 
<div class="clear_line_gray"></div>
<p>
<div id="botton_position">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value="全体目録 >>" onClick="location.href='<%=urlPage%>rms/admin/notice/listForm.jsp'">
</div>
<c:if test="${! empty news}">		
	
<div id="boxNoLine_900"  >		
<table  width="95%" border="0" cellspacing="2" cellpadding="2" >								
		<tr>
			<td  align="left"  style="padding-left:10px;padding-top:10px" class="calendar16_1">
			<img src="<%=urlPage%>orms/images/common/jirusi.gif" align="absmiddle">  情報入力			
			<font color="#CC0000">※</font>必修です。				
			</td>			
		</tr>	
</table>	

<!-- 내용 시작 *****************************************************************-->
<table width="95%"  class="tablebox" cellspacing="5" cellpadding="5">	
		<form action="<%=urlPage%>rms/admin/notice/update.jsp" method="post"  name="resultform"  >
			<input type="hidden" name="seq" value="${news.seq}">		
	<tr>
	<td align="left"  style="padding-left:10px"   bgcolor="#F1F1F1"><font color="#CC0000">※</font>
				タイトル</td>																	
	<td align="left"  style="padding-left:10px"  >
			<input type="text" NAME="title"  VALUE="${news.title}" maxlength="120"  class="input02" style="width:400px">
			<font color="#807265">(▷100字まで入力できます。)</font>
	</td>
	</tr>									
			<tr>
					<td align="left"  style="padding-left:10px"   bgcolor="#F1F1F1"><img src="<%=urlPage%>rms/image/icon_ball.gif" >
										メインページにて公開</td>																	
					<td align="left"  style="padding-left:10px"  >
						<input type="radio" name="view_yn" value="1" <c:if test="${news.view_yn==1}">checked</c:if>>はい									
						<input type="radio" name="view_yn" value="2" <c:if test="${news.view_yn==2}">checked</c:if> >いいえ					
									
				</td>
			</tr>
	</table>	
<div class="clear_margin"></div>	
<table  width="95%" border="0" cellspacing="2" cellpadding="2" >								
		<tr>			
			<td style="padding-left:10px" >
			<font color="#CC0000">※</font>詳しい内容 				
			</td>			
		</tr>	
</table>	
<table  width="95%" border="0" >					
	<tr>
		<td width="100%" align="center">
		<textarea id="content" name="content" style="width:100%;height:200px;">${news.content}</textarea>

<script type="text/javascript">
//<![CDATA[
CKEDITOR.replace( 'content', {
	customConfig : '<%=urlPage%>ckeditor/config.js',   	
   	width: '100%',
   	height: '200px'
} );
//]]>
</script>							
			
							
			</td>			
		</tr>									 		
</table>
<div class="clear_margin"></div>	
<table  width="95%" border="0" >										   
	<tr align="center">
			<td >
				<A HREF="JavaScript:goWrite()"><img src="<%=urlPage%>rms/image/admin/btn_apply.gif"></A>				
			</td>			
	</tr>
</form>
</table>			
</c:if>
			
			
			