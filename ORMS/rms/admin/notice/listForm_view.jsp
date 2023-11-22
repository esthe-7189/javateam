<%@ page contentType = "text/html; charset=utf8" %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "java.util.List,java.io.*,javax.servlet.*,javax.servlet.http.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "mira.notice.NewsBean " %>
<%@ page import = "mira.notice.NewsManager" %>
<%@ page import = "mira.member.Member" %>
<%@ page import = "mira.member.MemberManager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import = "java.text.SimpleDateFormat" %>	
<%! 
static int PAGE_SIZE=50; 
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");	
%>
<%	
		
MemberManager memmgr = MemberManager.getInstance();
	String id=(String)session.getAttribute("ID");	
	Member member2=memmgr.getMember(id);
	String kind=(String)session.getAttribute("KIND");
	
if(kind!=null && ! kind.equals("bun")){
%>			
	<jsp:forward page="/rms/template/tempMain.jsp">		    
		<jsp:param name="CONTENTPAGE3" value="/rms/home/home.jsp" />	
	</jsp:forward>
<%
	}
	String urlPage=request.getContextPath()+"/";		
	String pageNum = request.getParameter("page");	
    if (pageNum == null) pageNum = "1";
    int currentPage = Integer.parseInt(pageNum);	

	String[] searchCond=request.getParameterValues("search_cond");
	String searchKey=request.getParameter("search_key");

	List whereCond = null;
	Map whereValue = null;

	boolean searchCondTitle = false;	
	boolean searchCondView_ok=false;
	boolean searchCondView_no=false;

	if (searchCond != null && searchCond.length > 0 && searchKey != null){	
		whereCond = new java.util.ArrayList();
		whereValue = new java.util.HashMap();

		for (int i=0;i<searchCond.length ;i++ ){
			if (searchCond[i].equals("title")){
				whereCond.add("title LIKE '%"+searchKey+"%'");		
				searchCondTitle = true;
			}else if (searchCond[i].equals("view_ok")){
				whereCond.add("view_yn=1");		
				searchCondView_ok = true;
			}else if (searchCond[i].equals("view_no")){
				whereCond.add("view_yn=2");		
				searchCondView_no = true;
			}	
		}
	}

	NewsManager manager = NewsManager.getInstance();	
	int count = manager.count(whereCond, whereValue);
	int totalPageCount = 0; //전체 페이지 개수를 저장
	int startRow=0, endRow=0;
	if (count>0){
		totalPageCount=count/PAGE_SIZE;
		if (count % PAGE_SIZE > 0)totalPageCount++;
		
		startRow=(currentPage-1)*PAGE_SIZE+1;
		endRow=currentPage*PAGE_SIZE;
		if(endRow > count) endRow = count;
	}
	if(count<=0){
		startRow=startRow-0;
		endRow=endRow-0;
	}else if(count>0){
		startRow=startRow-1;
		endRow=endRow-1;
	}
	List  list=manager.selectList(whereCond, whereValue,startRow,endRow);	
	
%>
<c:set var="list" value="<%= list %>" />


<script language="javascript">
// 한줄쓰기 토글 함수
function ShowHidden(MenuName, ShowMenuID){
	for ( i = 1; i <= 30;  i++ ){
		menu	= eval("document.all.itemData_block" + i + ".style");		
		if ( i == ShowMenuID ){
			if ( menu.display == "block" )
				menu.display	= "none";
			else 
				menu.display	= "block";
		} 
		else 
			menu.display	= "none";
	}
	frame_init();
} 
</script>		
<img src="<%=urlPage%>rms/image/icon_ball.gif" >
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=60);">
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=30);"><span class="calendar7">お知らせ<font color="#A2A2A2">></font>全体目録</span> 
<div class="clear_line_gray"></div>
<p>
<div id="botton_position">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value="新規登録 >>" onClick="location.href='<%=urlPage%>rms/admin/notice/addForm.jsp'">
</div>

<table  width="80%"  class="box_100" cellspacing="2" cellpadding="2" >	
<form name="search"  action="<%=urlPage%>rms/admin/notice/listForm.jsp?page=1" method="post">	
								<tr>
								<td >
						<div  class="f_left" style="padding:2px;background:#EFEBE0;margin:0px 0px 0 0;">
							<select name="search_cond" class="select_type3" >								
									 <option name="search_cond" VALUE="" >:::Search:::</OPTION>	
							            	<option name="search_cond" VALUE="view_ok" >展示中</OPTION>	
							          		<option name="search_cond" VALUE="view_no" >展示してない</OPTION>			          	
										<option name="search_cond" VALUE="title"  >タイトル</OPTION>												
								</select>
						</div>
								<input type=text  name="search_key" size=25  class="input02" >
								<input type="submit"  style=cursor:pointer align=absmiddle value="検索 >>" class="cc" onfocus="this.blur();" >
								<input type="button"   style=cursor:pointer align=absmiddle value="全体目録 >>" class="cc" onfocus="this.blur();"  onClick="location.href='<%=urlPage%>rms/admin/notice/listForm.jsp?page=1'">		
								</td>								
							</tr>
	</form>
</table>
									
									
	<table width="80%"   class="box_100" cellpadding="2" cellspacing="2" >
			<tr bgcolor=#F1F1F1 align=center height=26>	        
				<td  width="15%" class="clear_dot">登録日</td>				
				<td  width="45%"  class="clear_dot">タイトル</td>							
				<td   width="10%" class="clear_dot">展示可否</td>				
				<td   width="10%" class="clear_dot">修正</td>
				<td   width="10%" class="clear_dot">削除</td>				
			</tr>			
			<c:if test="${empty list}">
			<tr onMouseOver=this.style.backgroundColor="#EFF5F9" onMouseOut=this.style.backgroundColor=""><td colspan="7">登録された内容がありません。</td></tr>
			</c:if>
			<c:if test="${! empty list}">
			<c:forEach var="news" items="${list}" varStatus="idx">
			<tr  height="20">				
				<td align="center" class="clear_dot_gray"><fmt:formatDate value="${news.register}" pattern="yyyy-MM-dd" /></td>				
				<td  align="left" class="clear_dot_gray">					
					<a href="javascript:ShowHidden('itemData_block','${idx.index+1}');"  onFocus="this.blur()">
					${news.title}</a>
				</td>					
				<c:if test="${news.view_yn==1}"><td  align="center" class="clear_dot_gray">はい</td></c:if>
				<c:if test="${news.view_yn==2}"><td  align="center" class="clear_dot_gray">いいえ</td></c:if>				
				<td align="center" class="clear_dot_gray">
					<a href="javascript:goModify(${news.seq})" onfocus="this.blur()">
					<img src="<%=urlPage%>rms/image/admin/btn_cate_pen.gif" alt="Modify" >
					</a></td>
				<td align="center" class="clear_dot_gray">
					<a href="javascript:goDelete('${news.seq}')"  onfocus="this.blur()">
					<img src="<%=urlPage%>rms/image/admin/btn_cate_x.gif" alt="Cancel">
					</a></td>
			</tr>
				<td  style="padding-top: 0px;" colspan="5" align="center" width="90%" valign="top">
					<span id="itemData_block${idx.index+1}" style="DISPLAY:none; xCURSOR:hand">								
						<table width="85%"  cellpadding="2" cellspacing="2" bordercolor=#FFFFFF bordercolorlight="#666666" bgcolor="#EEFFF5">
						<tr>	
							<td style="padding: 3px 3px 3px 5px"   align="left">${news.content}</td>
						</tr>
						</table>
					</span>
				</td>
			</tr>						
			</c:forEach>
			</c:if>
		</table>
							
	<table  width="80%"  class="box_100" cellspacing="2" cellpadding="2" >	
		<tr>
			<td >													
<!-- *****************************page No begin******************************-->			
		<div class="paging_topbg"><p class="mb60  mt7"><div class="pagingHolder module ">				
			<c:set var="count" value="<%= Integer.toString(count) %>" />
			<c:set var="PAGE_SIZE" value="<%= Integer.toString(PAGE_SIZE) %>" />
			<c:set var="currentPage" value="<%= Integer.toString(currentPage) %>" />
				<span class="defaultbold ml20">      Page No : </span>				
				<span >
			<c:if test="${count > 0}">
			    <c:set var="pageCount" value="${count / PAGE_SIZE + (count % PAGE_SIZE == 0 ? 0 : 1)}" />
			    <c:set var="startPage" value="${currentPage - (currentPage % 10) + 1}" />
			    <c:set var="endPage" value="${startPage + 10}" />    
			    <c:if test="${endPage > pageCount}">
			        <c:set var="endPage" value="${pageCount}" />
			    </c:if>    			
				<c:if test="${startPage > 10}">        	
						<a href="javascript:goPage(${startPage - 10})" onfocus="this.blur()" ><<</a>		
			    	</c:if>  		
				<c:forEach var="pageNo" begin="${startPage}" end="${endPage}">
			        	<c:if test="${currentPage == pageNo}"><span class="active">${pageNo}</span></c:if>
			        	<c:if test="${currentPage != pageNo}"><a href="javascript:goPage(${pageNo})" onfocus="this.blur()" >${pageNo}</a></c:if>        		
			    	</c:forEach>
			    					
				<c:if test="${endPage < pageCount}">        	
						<a href="javascript:goPage(${startPage + 10})" onfocus="this.blur()" >>></a>		
			    	</c:if>				
			</c:if>			
				</span>				
			</div><p class="mb20"></div>			
<!-- ************************page No end***********************************-->									
			</td>
		</tr>
	</table>
<form name="move" method="post">
    <input type="hidden" name="seq" value="">    
    <input type="hidden" name="page" value="${currentPage}">    
    <c:if test="<%= searchCondView_ok%>">
    <input type="hidden" name="search_cond" value="view_ok">
    </c:if>	
    <c:if test="<%= searchCondView_no%>">
    <input type="hidden" name="search_cond" value="view_no">
    </c:if>	
    <c:if test="<%= searchCondTitle%>">
    <input type="hidden" name="search_cond" value="title">
    </c:if>	
    <c:if test="${! empty param.search_key}">
    <input type="hidden" name="search_key" value="${param.search_key}">
    </c:if>
</form>
<script language="JavaScript">
function goPage(pageNo) {
    document.move.action = "<%=urlPage%>rms/admin/notice/listForm.jsp";
    document.move.page.value = pageNo;
    document.move.submit();
}

function goModify(seq) {
	document.move.action = "<%=urlPage%>rms/admin/notice/updateForm.jsp";
	document.move.seq.value=seq;
    	document.move.submit();
}
function goDelete(seq) {
	document.move.seq.value=seq;	
	
	if ( confirm("本内容を削除しますか?") != 1 ) {
		return;
	}
    	document.move.action = "<%=urlPage%>rms/admin/notice/deleteForm.jsp";	
    	document.move.submit();
}

</script>

