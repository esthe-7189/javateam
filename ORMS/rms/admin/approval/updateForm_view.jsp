<%@ page contentType = "text/html; charset=utf8"  import="java.util.*"%>
<%@ page pageEncoding = "utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>	
<%@ page import = "mira.approval.ApprovalBeen" %>
<%@ page import = "mira.approval.ApprovalMgr" %>
<%@ page import = "mira.tokubetu.Member" %>
<%@ page import = "mira.tokubetu.MemberManager" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.NumberFormat " %>
<%@ page import = "java.sql.Timestamp" %>
<%! 
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat timeFormat = new SimpleDateFormat("yyyyMMddHH:mmss");
%>

<%
String urlPage=request.getContextPath()+"/";

String id=(String)session.getAttribute("ID");
String seq = request.getParameter("seq");	
String kind=(String)session.getAttribute("KIND");
String kindPg=request.getParameter("kindPg");
String inDate=dateFormat.format(new java.util.Date());


if(id.equals("candy")){
%>			
	<jsp:forward page="/rms/template/tempMain.jsp">		    
		<jsp:param name="CONTENTPAGE3" value="/rms/home/home.jsp" />	
	</jsp:forward>
<%
	}
if(kind!=null && ! kind.equals("bun")){
%>			
	<jsp:forward page="/rms/template/tempMain.jsp">		    
		<jsp:param name="CONTENTPAGE3" value="/rms/home/home.jsp" />	
	</jsp:forward>
<%
	}

int mseq=0; int levelVal=0;
String title=""; 

MemberManager managermem = MemberManager.getInstance();	
Member member=managermem.getMember(id);
	if(member!=null){		 
		 mseq=member.getMseq();		 
	}

ApprovalMgr mana = ApprovalMgr.getInstance();
ApprovalBeen board = mana.select(Integer.parseInt(seq));  ;                     
        String kanri_no=board.getKanri_no();  
        String cate=board.getCate();   
        int genan_mseq=board.getGenan_mseq();  
        int gian_mseq=board.getGian_mseq();            
        int bseq=board.getBseq(); 	
 
String nmMseq="";      
Member  memseq=managermem.getDbMseq(board.getMseq());
 if(memseq!=null){nmMseq=memseq.getNm();}else{nmMseq="--";}         
 
 //ApprovalBeen codeItem=mana.getCodeLimit();
 
 List listCode=mana.listCode();  
 List listCate=mana.listCate();
 List listFollow=managermem.selectListSchedule(1,6);  //level 2부터
%>
<c:set var="board" value="<%= board %>" />
<c:set var="member" value="<%= member %>" />	
<c:set var="listCode" value="<%= listCode %>" />
<c:set var="listCate" value="<%= listCate %>" />
<c:set var="listFollow" value="<%= listFollow %>" />
<c:set var="kanri_no" value="<%= kanri_no %>" />
<c:set var="cate" value="<%= cate %>" />
<c:set var="genan_mseq" value="<%= genan_mseq %>" />
<c:set var="gian_mseq" value="<%= gian_mseq %>" />
<c:set var="bseq" value="<%= bseq %>" />	
 
	
<link href="<%=urlPage%>rms/css/jquery-ui.css" rel="stylesheet" type="text/css"/>
<script src="<%=urlPage%>rms/js/jquery.min.js"></script>
<script src="<%=urlPage%>rms/js/jquery-ui.min.js"></script>	
<script>
$(function() {
   $("#date_submit").datepicker({monthNamesShort: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],dayNamesMin: ['日','月','火','水','木','金','土'],weekHeader: 'Wk', dateFormat: 'yy-mm-dd', 
    autoSize: false, changeMonth: true,changeYear: true, showMonthAfterYear: true, buttonImageOnly: true, buttonImage: '<%=urlPage%>rms/image/icon_cal.gif', showOn: "both", yearRange: 'c-10:c+10' ,showAnim: "slide"}); });

$(function() {
   $("#date_sign").datepicker({monthNamesShort: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],dayNamesMin: ['日','月','火','水','木','金','土'],weekHeader: 'Wk', dateFormat: 'yy-mm-dd', 
    autoSize: false, changeMonth: true,changeYear: true, showMonthAfterYear: true, buttonImageOnly: true, buttonImage: '<%=urlPage%>rms/image/icon_cal.gif', showOn: "both", yearRange: 'c-10:c+10' ,showAnim: "slide"}); });
    
</script>		
<script language="javascript">
 function numbertogo(n){
   n=n.replace(/,/g,"");   if(isNaN(n)){return 0;} else{return n;}
  }
function formSubmit(){        
	  var frm = document.forminput;			
	  var genanMseq=frm.genan_nm.options[frm.genan_nm.selectedIndex].value;
	  var gianMseq=frm.gian_nm.options[frm.gian_nm.selectedIndex].value;			  	  
	  
 	  if(isEmpty(frm.kanri_no, "管理番号を記入して下さい。")) return ; 	
 	  if(isEmpty(frm.date_submit, "受付日を記入して下さい。")) return ;    	    	   	  	  
	  if(isEmpty(frm.cate, "決裁項目を記入して下さい。")) return ;	  
	  if(isEmpty(frm.title, "件名を記入して下さい。")) return ;	  
	  if(isEmpty(frm.date_sign, "決裁日、或いは決裁予定日を記入して下さい。")) return ;    	    
	 if(genanMseq=="0"){alert("原案作成者を選択して下さい。"); return ;}						
	 if(gianMseq=="0"){alert("起案者を選択して下さい。"); return ;}
	  frm.genan_mseq.value=genanMseq;
	  frm.gian_mseq.value=gianMseq;	 
	
	with (document.forminput) {
    	    if(fellow_yn[0].checked==true){         	     	    	
		file_manual.value="<%=board.getFile_nm()%>";		
	    }	  
	    if(fellow_yn[1].checked==true){         	 
		if (fileNm.value=="") {
	            alert("ファイルを選択して下さい。あるいは「決裁書修正」の「しない」をチェックしてください。");
	            fileNm.focus();   return;	
	        }else{
	            file_manual.value="NO";	
	            file_manualMoto.value="<%=board.getFile_nm()%>";
	        }
	   }	 
	 } 	 

	  if(frm.date_submit.value !=""){
	 	if(frm.date_submit.value.length >10){frm.date_submit.value=frm.date_submit.value.substring(0,10);}
	 	var yyyymmdd    = frm.date_submit.value.replace(/-/g, "");
	    	var week        = new Array("日", "月", "火", "水", "木", "金", "土");
	    	var yyyy        = yyyymmdd.substr(0, 4);
	    	var mm          = yyyymmdd.substr(4, 2);
	    	var dd          = yyyymmdd.substr(6, 2);
	    	var date        = new Date(yyyy, mm - 1, dd);
	    	frm.date_submit.value=frm.date_submit.value+"("+week[date.getDay()]+")";	    	
	 }
	 if(frm.date_sign.value !=""){
	 	 if(frm.date_sign.value.length >10){frm.date_sign.value=frm.date_sign.value.substring(0,10);}	 
	 	var yyyymmdd2    = frm.date_sign.value.replace(/-/g, "");
	    	var week2        = new Array("日", "月", "火", "水", "木", "金", "土");
	    	var yyyy2        = yyyymmdd2.substr(0, 4);
	    	var mm2          = yyyymmdd2.substr(4, 2);
	    	var dd2          = yyyymmdd2.substr(6, 2);
	    	var date2        = new Date(yyyy2, mm2 - 1, dd2);
	    	frm.date_sign.value=frm.date_sign.value+"("+week2[date2.getDay()]+")";	    	
	 } 	
      if ( confirm("修正しますか?") != 1 ) { return; }	
     	frm.action = "<%=urlPage%>rms/admin/approval/update.jsp";	
	frm.submit(); 
   }   

 function dataServ(id){
  var frm = document.forminput;
   	if(id=="cateVal"){	  
	  var cate = frm.cateVal.options[frm.cateVal.selectedIndex].text; 
	  frm.cate.value=cate;	  
	}
  }
   
function goInit(){
	document.forminput.reset();
}
</script>	
<img src="<%=urlPage%>rms/image/icon_ball.gif" >
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=60);">
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=30);">  
	<span class="calendar7">決裁書リスト管理<font color="#A2A2A2">    >   </font>
		<%if(kindPg.equals("update")){%> 修正する <%}%>
		<%if(kindPg.equals("read")){%> 内容 <%}%>
	</span> 
		
<div class="clear_line_gray"></div>
<p>
<div id="botton_position">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value=" 全体目録 " onClick="location.href='<%=urlPage%>rms/admin/approval/listForm.jsp'">	
	<!--<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value=" 新規登録 " onClick="location.href='<%=urlPage%>rms/admin/approval/addForm.jsp'">-->			
</div>
<div id="boxNoLine_900"  >		
<%if(kindPg.equals("update")){%>
<table  width="950" border="0" cellspacing="2" cellpadding="2" >								
		<tr>
			<td  align="left"  style="padding-left:10px;padding-top:10px" class="calendar16_1">
			<img src="<%=urlPage%>orms/images/common/jirusi.gif" align="absmiddle">  情報入力				
			</td>						
		</tr>	
</table>	
<div class="clear_margin"></div>	
<table width="960" cellpadding="0" cellspacing="0">		
<tr>
    <td style="padding: 0px 0px 2px 15px">    	
   		<font color="#807265">※管理番号： <span class="calendar16_1"> 使っている番号</span>は重ねて使えません。それを参考して管理番号を決めて下さい。</font><br>
      	 	<font color="#807265">※受付日 / 決裁日：特定の日付を指定しない場合は[0000-00-00]のようにして下さい。</font>
    </td>     
    <td align="right" valign="bottom" style="padding: 0px 20px 0px 0px">
    		<font color="#CC0000">※</font>必修です。
    </td>
</tr>
</table>					
				
<%}%>

<table width="950"  class="tablebox" cellspacing="3" cellpadding="3" >				
	<form name="forminput" method=post  action="<%=urlPage%>rms/admin/approval/add.jsp" enctype="multipart/form-data">		
		<input type="hidden" name="mseq" value="<%=mseq%>">  <!--등록자-->		
		<input type='hidden' name="seq" value="<%=seq%>">		
		<input type='hidden' name="file_manual" value="${board.file_nm}">	
		<input type='hidden' name="file_manualMoto" value="${board.file_nm}">				
		<input type='hidden' name="bseq" value="<%=seq%>">					
		<input type='hidden' name="genan_mseq" value="">
		<input type='hidden' name="gian_mseq" value="">											
			<tr >								
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">管理No</span></td>
				<td width="50%" ><span class="calendar16_1"> 使えない番号:</span>
				<select name="codeVal" >
			<c:if test="${empty listCode}">
				<option  value="0">既存データなし</option>									
			</c:if>
			<c:if test="${! empty listCode}">					
				<c:forEach var="code" items="${listCode}" varStatus="index" >
					<c:if test="${kanri_no==code.kanri_no}">
							<option  value="${code.kanri_no}"   selected>${code.kanri_no}</option>
					</c:if>	
					<c:if test="${kanri_no!=code.kanri_no}">
							<option  value="${code.kanri_no}" > ${code.kanri_no}</option>
					</c:if>		
				</c:forEach>
			</c:if>																			
					</select>	&nbsp; &nbsp;&nbsp; <span class="calendar16_1"> 番号:	</span>	
					<input type="text" maxlength="30" name="kanri_no" value="${board.kanri_no}" class="input02" style="width:100px">					
				</td>
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">お名前</span></td>
				<td width="30%"><%=nmMseq%></td>
			</tr>
			<tr >								
				<td ><font color="#CC0000">※</font><span class="titlename">決裁項目</span></td>
				<td >
				<select name="cateVal" onChange="return dataServ('cateVal');">
			<c:if test="${empty listCate}">
				<option  value="0">既存データなし</option>					
				<option  value="0">経費の支出　２０万円以下</option>	
				<option  value="0">経費の支出　２０～１００万円以下</option>
			</c:if>
			<c:if test="${! empty listCate}">						
					<option  value="0">既存データをみる</option>	
					<option  value="0">経費の支出　２０万円以下</option>	
					<option  value="0">経費の支出　２０～１００万円以下</option>					
					
				<c:forEach var="code" items="${listCate}" varStatus="index" >
						<c:if test="${board.cate==code.cate}">
							<option  value="${code.cate}"   selected>${code.cate}</option>
						</c:if>	
						<c:if test="${board.cate!=code.cate}">
							<option  value="${code.cate}" > ${code.cate}</option>
						</c:if>										
				</c:forEach>
			</c:if>									
					</select>	
					<input type="text" maxlength="100" name="cate" value="${board.cate}" class="input02" style="width:280px"> 					
				</td>
				<td ><font color="#CC0000">※</font><span class="titlename">原案作成者</span> </td>
				<td >
					<select name="genan_nm"  id="genan_nm">	
					<option value="0">---選択して下さい---</option>								
				<c:if test="${! empty  listFollow}">
					<c:forEach var="mem" items="${listFollow}"  varStatus="idx"  >		
						<c:if test="${genan_mseq==mem.mseq}">						            							
						<option value="${mem.mseq}" selected>${mem.nm}</option>	
						</c:if>	
						<c:if test="${genan_mseq!=mem.mseq}">						            							
						<option value="${mem.mseq}" >${mem.nm}</option>	
						</c:if>					
					</c:forEach>
				</c:if>				
					</select>						
				</td>				
			</tr>			
			<tr >				
				<td rowspan="3"><font color="#CC0000">※</font><span class="titlename">件名</span></td>
				<td rowspan="3"><textarea class="textarea"  id="title" name="title" rows="5" style="width:400px;">${board.title}</textarea></td>
				<td ><font color="#CC0000">※</font><span class="titlename">起案者</span></td>
				<td >
				<select name="gian_nm"  id="gian_nm">	
					<option value="0">---選択して下さい---</option>								
			<c:if test="${! empty  listFollow}">
				<c:forEach var="mem" items="${listFollow}"  varStatus="idx"  >		
					<c:if test="${gian_mseq==mem.mseq}">						            							
					<option value="${mem.mseq}" selected>${mem.nm}</option>	
					</c:if>	
					<c:if test="${gian_mseq!=mem.mseq}">						            							
					<option value="${mem.mseq}" >${mem.nm}</option>	
					</c:if>					
				</c:forEach>
			</c:if>				
				</select>				
				</td>				
			</tr>						
			<tr>					
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">受付日</span></td>
				<td width="40%"><input type="text" size="12%" name="date_submit" id="date_submit"  value="${board.date_submit}" class="input02"></td>
			</tr>
			<tr>				
				<td  width="10%"><font color="#CC0000">※</font><span class="titlename">決裁日</span></td>
				<td width="40%" ><input type="text" size="12%" name="date_sign" id="date_sign"  value="${board.date_sign}" class="input02"></td>		
			</tr>	
</table>					
<div class="clear_margin"></div>								
<table width="950"   class="tablebox" cellspacing="5" cellpadding="5">					
	<tr>			
		<td  width="10%"><img src="<%=urlPage%>rms/image/icon_s.gif" ><span class="titlename">既存の決裁書</span></td>		
		<td width="90%">
				<font color="#993300">
<c:choose>
	<c:when test="${board.file_nm=='no data'}"> 
	    契約書なし
	</c:when>
	<c:when test="${empty board.file_nm}">
	    契約書なし
	</c:when>
	<c:when test="${!empty board.file_nm}">
	    ${board.file_nm}
	</c:when>
	<c:otherwise>
	    ${board.file_nm}
	</c:otherwise>
</c:choose>		
				===></font>					
			
			決裁書修正 :
			<input type="radio" name="fellow_yn" value="1" onClick="fellow02()" onfocus="this.blur()" checked><font  color="#FF6600">しない</font>
			<input type="radio" name="fellow_yn" value="2" onClick="fellow01()" onfocus="this.blur()"><font  color="#FF6600">修正する</font>
				<br>
				<div id="fellow" style="display:none;overflow:hidden ;border:1px solid #99CC00;width:90%;padding:5px 2px 5px 2px;"  >
				ニュー契約書 : <input type="file" size="80"  name="fileNm" class="file_solid">
				</div>
		</td>		
	</tr>				
	<tr>	
		<td  ><img src="<%=urlPage%>rms/image/icon_s.gif" ><span class="titlename">備　　考</span></td>
		<td  colspan="3"><input type=text size="80" class="input02"  name="comment" maxlength="200" value="${board.comment}"></td>			
	</tr>
</table>
<%if(kindPg.equals("update")){%>						
<table  width="950" border="0" cellspacing="0" cellpadding="0" bgcolor="#ffffff">												
	<tr>				
			<td align="center" style="padding:15px 0px 50px 0px;">
				<a href="JavaScript:formSubmit()"><img src="<%=urlPage%>orms/images/common/btn_off_submit.gif" ></A>		
				&nbsp;
				<a href="javascript:goInit();"><img src="<%=urlPage%>orms/images/common/btn_off_cancel.gif" ></A>
			</td>			
	</tr>			
</table>	
<%}%>
</form>		
</div>					
<!-- item end *****************************************************************-->				
		
<script type="text/javascript">
function fellow01(){document.getElementById("fellow").style.display=''; }
function fellow02(){document.getElementById("fellow").style.display='none'; }

</script> 
			