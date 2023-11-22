
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "mira.approval.ApprovalBeen" %>
<%@ page import = "mira.approval.ApprovalMgr" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "java.io.File" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "mira.fileupload.FileUploadRequestWrapper" %>
<%@ page import = "java.util.Hashtable"%>
<%@ page import = "java.util.*,java.text.*,java.io.*,javax.servlet.*,javax.servlet.http.*" %>
<%
String urlPage=request.getContextPath()+"/";
String ip_add=(String)request.getRemoteAddr();	
	
	//String saveFoldTemp="C:\\dev\\tomcat5\\webapps\\orms\\orms\\temp";
	//String saveFold="C:\\dev\\tomcat5\\webapps\\orms\\tokubetu\\fileList\\approval";
	String saveFoldTemp="/home/user/orms/public_html/rms/temp";
	String saveFold="/home/user/orms/public_html/tokubetu/fileList/approval";


FileUploadRequestWrapper requestWrap=new FileUploadRequestWrapper(request,-1,-1,saveFoldTemp,"utf-8");
HttpServletRequest tempRequest=request;
request=requestWrap;

String kanri_no=request.getParameter("kanri_no");
ApprovalMgr mgr=ApprovalMgr.getInstance();
int dbNo=mgr.checkKanri(kanri_no); 
//관리번호 중복 체크      	
if(dbNo==-1){	
%>
<jsp:useBean id="pds" class="mira.approval.ApprovalBeen" >
	<jsp:setProperty name="pds" property="*"  />
</jsp:useBean>
<%
		
		FileItem frmFileItem=requestWrap.getFileItem("fileNm");
		String fil="";
		String file_manualVal = request.getParameter("file_manualVal");
		if (frmFileItem.getSize() >0){
			int idx=frmFileItem.getName().lastIndexOf("\\");
			if (idx==-1){
				idx=frmFileItem.getName().lastIndexOf("/");
			}
			fil=frmFileItem.getName().substring(idx+1);

			//파일을 지정한 경로에 저장
			File fileNm=new File( saveFold,fil);
			
			//같은 이름의 파일 처리
			if (fileNm.exists())	{
				for (int i=0;true ;i++ ){
					fileNm=new File(saveFold,"("+i+")"+fil);
					if (!fileNm.exists()){
						fil="("+i+")"+fil;
						break;
					}
				}
			}
			frmFileItem.write(fileNm);
		}
		%>

		<%  
		pds.setRegister(new Timestamp(System.currentTimeMillis()));
		pds.setFile_nm(fil);		
		mgr.insert(pds);	
		response.sendRedirect(urlPage+"rms/admin/approval/listForm.jsp");
}else{
%>
	<script language="JavaScript">
		alert("既に登録された管理番号です。もう一度確認して下さい。");
	  	location.href = "<%=urlPage%>rms/admin/approval/addForm.jsp";		
	</script>
<%}%>
