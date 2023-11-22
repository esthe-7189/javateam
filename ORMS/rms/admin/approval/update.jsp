<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page pageEncoding = "utf-8" %>
<%@ page import = "mira.approval.ApprovalBeen" %>
<%@ page import = "mira.approval.ApprovalMgr" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "java.io.File" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "mira.fileupload.FileUploadRequestWrapper" %>
<%@ page import=  "com.oreilly.servlet.MultipartRequest" %>
<%@ page import=  "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.Hashtable"%>
<%@ page import = "java.util.*,java.text.*,java.io.*,javax.servlet.*,javax.servlet.http.*" %>

<%
String urlPage=request.getContextPath()+"/";	
	
	//String saveFoldTemp="C:\\dev\\tomcat5\\webapps\\orms\\orms\\temp";
	//String saveFold="C:\\dev\\tomcat5\\webapps\\orms\\tokubetu\\fileList\\approval";
	String saveFoldTemp="/home/user/orms/public_html/rms/temp";
	String saveFold="/home/user/orms/public_html/tokubetu/fileList/approval";

FileUploadRequestWrapper requestWrap=new FileUploadRequestWrapper(request,-1,-1,saveFoldTemp,"utf-8");
HttpServletRequest tempRequest=request;
request=requestWrap;

String kanri_no = request.getParameter("kanri_no");
String bseq = request.getParameter("bseq");

ApprovalMgr mgr=ApprovalMgr.getInstance();
int allCnt=mgr.checkKanriUpCnt(kanri_no); 
int seqCnt=mgr.checkKanriUpBseq(kanri_no,Integer.parseInt(bseq)); ;
//관리번호 중복 체크, dbNo=모든 관리번호 수 ,  seqCnt=seq에 해당하는 번호인지 확인 1이면 일치    	
if(allCnt==1 && seqCnt==1 || allCnt==0){	

%>
<jsp:useBean id="pds" class="mira.approval.ApprovalBeen" >
	<jsp:setProperty name="pds" property="*"  />
</jsp:useBean>
<%	

FileItem frmFileItem=requestWrap.getFileItem("fileNm");
String file_manualMoto = request.getParameter("file_manualMoto");
String fileExist = request.getParameter("file_manual");
String fil="";
if(fileExist.equals("NO")){		
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
		pds.setFile_nm(fil);		
		pds.setKanri_no("契-"+kanri_no);	
		mgr.update1(pds);

	}else{		
		pds.setKanri_no("契-"+kanri_no);	
		mgr.update2(pds);
	}

%>
	<script language="JavaScript">
		alert("修正しました。");
	  	location.href = "<%=urlPage%>rms/admin/approval/listForm.jsp";		
	</script>
<%}else{%>
	<script language="JavaScript">
		alert("既に登録された管理番号です。もう一度確認して下さい。");
	  	location.href = "<%=urlPage%>rms/admin/approval/updateForm.jsp?seq=<%=bseq%>&kindPg=update";		
	</script>	
<%}%>
