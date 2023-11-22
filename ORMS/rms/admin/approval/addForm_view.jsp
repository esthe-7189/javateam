<%@ page contentType = "text/html; charset=utf8"  import="java.util.*"%>
<%@ page pageEncoding = "utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>	
<%@ page import = "mira.approval.ApprovalBeen" %>
<%@ page import = "mira.approval.ApprovalMgr" %>
<%@ page import = "mira.member.Member" %>
<%@ page import = "mira.member.MemberManager" %>
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
String kind=(String)session.getAttribute("KIND");
String inDate=dateFormat.format(new java.util.Date());
String yyVal=inDate.substring(2,4);

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

int mseq=0; int levelVal=0; int bseq=0; 
String title=""; String wname="";

MemberManager managermem = MemberManager.getInstance();	
Member member=managermem.getMember(id);
	if(member!=null){		 
		 mseq=member.getMseq();		 
		 wname=member.getNm();		 
	}

 ApprovalMgr mana = ApprovalMgr.getInstance();  
 ApprovalBeen codeItem=mana.getCodeLimit();
 String conCode="";  int conCodeInt=0;
 if (codeItem != null) {                
        String conCodeArray[]=codeItem.getKanri_no().split("-");              
        conCodeInt=(Integer.parseInt(conCodeArray[1])+1);
         if(conCodeInt<10){
		conCode="決"+yyVal+"-00"+conCodeInt;
	   }else if(conCodeInt>=10 &&  conCodeInt<100){
	      	conCode="決"+yyVal+"-0"+conCodeInt;
	   }else if(conCodeInt>=100 ){
	      	conCode="決"+yyVal+"-"+conCode;				       
	   }
 }else{
 	conCode="決"+yyVal+"-001";
 }
 
  
 List listCode=mana.listCode();  
 List listCate=mana.listCate();
 List listFollow=managermem.selectListSchedule(1,6);  //level 2부터
%>

<c:set var="codeItem" value="<%= codeItem %>" />
<c:set var="member" value="<%= member %>" />	
<c:set var="listCode" value="<%= listCode %>" />
<c:set var="listCate" value="<%= listCate %>" />
<c:set var="listFollow" value="<%= listFollow %>" />

	
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
	 if(frm.fileNm.value==""){
	 	if ( confirm("決裁書はありませんか?") != 1 ) { return; }	
	 }	 	 
	 if(frm.fileNm.value==""){
	 	frm.file_manualVal.value="no data";
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
	 
	 	
      if ( confirm("登録しますか?") != 1 ) { return; }	
     	frm.action = "<%=urlPage%>rms/admin/approval/add.jsp";	
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
<img src="<%=urlPage%>rms/image/icon_ball.gif" style="filter:Alpha(Opacity=30);">  <span class="calendar7">決裁書リスト管理 <font color="#A2A2A2">   >   </font> 新規登録</span> 
<div class="clear_line_gray"></div>
<p>
<div id="botton_position">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value=" 全体目録 " onClick="location.href='<%=urlPage%>rms/admin/approval/listForm.jsp'">	
	<input type="button"  class="cc" onfocus="this.blur();" style=cursor:pointer value=" 新規登録 " onClick="location.href='<%=urlPage%>rms/admin/approval/addForm.jsp'">			
</div>
<div id="boxNoLine_900"  >		
<table  width="950" border="0" cellspacing="2" cellpadding="2" >								
		<tr>
			<td align="left"  style="padding-left:10px;padding-top:10px" class="calendar16_1">
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
<table width="950"  class="tablebox" cellspacing="3" cellpadding="3" >				
	<form name="forminput" method=post  action="<%=urlPage%>rms/admin/approval/add.jsp" enctype="multipart/form-data">		
		<input type="hidden" name="mseq" value="<%=mseq%>">  <!--등록자-->						
		<input type='hidden' name="file_manualVal" value="0">	
		<input type='hidden' name="genan_mseq" value="">
		<input type='hidden' name="gian_mseq" value="">											
			<tr >								
				<td width="10%"><img src="<%=urlPage%>rms/image/icon_s.gif" ><span class="titlename">管理番号参考</span></td>
				<td width="50%"  class="calendar16_1" colspan="3">				
					    使っている番号:
				<select name="codeVal" >
				<c:if test="${empty listCode}">
						<option  value="0">既存データなし</option>					
				</c:if>
				<c:if test="${! empty listCode}">
					<c:forEach var="code" items="${listCode}" varStatus="index" >
						<option  value="${code.kanri_no}"  >${code.kanri_no}</option>		
					</c:forEach>
				</c:if>									
					</select>										
				</td>				
			</tr>
			<tr >								
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">管理番号</span></td>
				<td width="50%" >				
					   <span class="calendar16_1"> 推薦番号:	</span>			
					<input type="text" maxlength="30" name="kanri_no" value="<%=conCode%>" class="input02" style="width:100px">					
					<font color="#807265" >(▷例：2013年の場合==>  決13-000)</font>
				</td>
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">お名前</span></td>
				<td width="30%"><%=wname%></td>
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
						<option  value="${code.cate}"  >${code.cate}</option>		
					</c:forEach>
				</c:if>																
					</select>	
					<input type="text" maxlength="100" name="cate" value="" class="input02" style="width:280px"> 					
				</td>
				<td ><font color="#CC0000">※</font><span class="titlename">原案作成者</span> </td>
				<td >
					<select name="genan_nm"  id="genan_nm">	
					<option value="0">---選択して下さい---</option>								
				<c:if test="${! empty  listFollow}">
					<c:forEach var="mem" items="${listFollow}"  varStatus="idx"  >		
						<c:if test="${member.mseq==mem.mseq}">						            							
						<option value="${mem.mseq}" selected>${mem.nm}</option>	
						</c:if>	
						<c:if test="${member.mseq!=mem.mseq}">						            							
						<option value="${mem.mseq}" >${mem.nm}</option>	
						</c:if>					
					</c:forEach>
				</c:if>				
					</select>						
				</td>				
			</tr>			
			<tr >				
				<td rowspan="3"><font color="#CC0000">※</font><span class="titlename">件名</span></td>
				<td rowspan="3"><textarea class="textarea"  id="title" name="title" rows="5" style="width:400px;"></textarea></td>
				<td ><font color="#CC0000">※</font><span class="titlename">起案者</span></td>
				<td >
				<select name="gian_nm"  id="gian_nm">	
					<option value="0">---選択して下さい---</option>								
			<c:if test="${! empty  listFollow}">
				<c:forEach var="mem" items="${listFollow}"  varStatus="idx"  >		
					<c:if test="${member.mseq==mem.mseq}">						            							
					<option value="${mem.mseq}" selected>${mem.nm}</option>	
					</c:if>	
					<c:if test="${member.mseq!=mem.mseq}">						            							
					<option value="${mem.mseq}" >${mem.nm}</option>	
					</c:if>					
				</c:forEach>
			</c:if>				
				</select>				
				</td>				
			</tr>
			<tr>					
				<td width="10%"><font color="#CC0000">※</font><span class="titlename">受付日</span></td>
				<td width="40%"><input type="text" size="12%" name="date_submit" id="date_submit"  value="0000-00-00" class="input02"></td>
			</tr>				
			<tr>				
				<td  width="10%"><font color="#CC0000">※</font><span class="titlename">決裁日</span></td>
				<td width="40%" ><input type="text" size="12%" name="date_sign" id="date_sign"  value="0000-00-00" class="input02"></td>		
			</tr>								
</table>					
<div class="clear_margin"></div>								
<table width="950"   class="tablebox" cellspacing="5" cellpadding="5">				
	<tr>	
		<td><img src="<%=urlPage%>rms/image/icon_s.gif" ><span class="titlename">決裁書</span></td>
		<td colspan="3"><input type="file" size="80"  name="fileNm" class="file_solid"><font color="#807265" >(▷ '&,%,^'などの記号は使わないで下さい!)</font></td>		
	</tr>
	<tr>	
		<td  ><img src="<%=urlPage%>rms/image/icon_s.gif" ><span class="titlename">備　　考</span></td>
		<td  colspan="3"><input type=text size="80" class="input02"  name="comment" maxlength="200"></td>			
	</tr>
</table>						
<table  width="950" border="0" cellspacing="0" cellpadding="0" bgcolor="#ffffff">												
	<tr>				
			<td align="center" style="padding:15px 0px 50px 0px;">
				<a href="JavaScript:formSubmit()"><img src="<%=urlPage%>orms/images/common/btn_off_submit.gif" ></A>		
				&nbsp;
				<a href="javascript:goInit();"><img src="<%=urlPage%>orms/images/common/btn_off_cancel.gif" ></A>
			</td>			
	</tr>
</form>				
</table>	
</div>							
<!-- item end *****************************************************************-->				
<form name="move"  method="post">
	<input type="hidden" name="nameval" value="">
	<input type="hidden" name="groupIdval" value="">
	<input type="hidden" name="parentIdval"  value="">	
</form>			

			