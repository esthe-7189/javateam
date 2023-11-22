package mira.util;

import javax.servlet.http.HttpServletRequest; 
import java.io.*; 

/**
 * multipart/form-data 형식으로 전달되는 HTML 폼 데이터를
 * 읽어올 때 사용되는 유틸리티 클래스이다.<br>
 * 사용자가 전송한 파일을 특정한 출력 스트림(일반적으로 FileOutputStream)에
 * 저장하기 위해 사용된다.
 */

public class MultiPartUtil {
	
	private String delimeter;
	private String delimeterEnd;
	private BufferedReader is;
	private DataInputStream d ;

	private String filename;
	
	public MultiPartUtil(HttpServletRequest req) throws IOException {
		this.is = new BufferedReader(new InputStreamReader(req.getInputStream()));
		delimeter = is.readLine();
		delimeterEnd = delimeter + "--";
	}
	
	public String getDelimeter() { 
		return delimeter; 
	}
	
	/**
	 * 지정한 이름을 가진 파라미터의 값을 구한다.
	 *
	 * @param name 읽어올 파라미터의 이름
	 * @return 지정한 이름을 갖는 파라미터의 값. 없을 경우 null을 리턴한다.
	 */
	public String getParameter(String name) throws IOException {
		String str = null; 
		String param = null; 
		StringBuffer sb = null; 
		
		while( (str=is.readLine()) != null ) { 
			if (str.indexOf("name=") != -1) { 
				int startIndex = str.indexOf("name="); 
				int endIndex = str.indexOf("\"", startIndex+6); 
				
				param = str.substring(startIndex+6, endIndex); 
				
				if (param.equals(name)) { 
					str = is.readLine(); 
					sb = new StringBuffer(512); 
					
					do {
						sb.append(str).append("\r\n"); 
						str = is.readLine(); 
					} while( !str.equals(delimeter) && !str.equals(delimeterEnd) ); 
					
					String ret = sb.toString();
					
					int len = ret.length();
					
					if (len > 4) ret = ret.substring(2, len-2);
					else ret="";
					return ret;
				}
			}
		}
		return null;
	}
	
	/**
	 * 전송한 파일의 이름을 구한다.<br>
	 * filename="" 으로 전송될 경우 ""를 리턴한다.<br>
	 *
	 * @return 전송한 파일 이름. 파일이름이 없을 경우 null을 리턴한다.
	 */
	public String getFilename() throws IOException { 
		String str = null; 
		int startIndex; 
		int endIndex; 
		String filename = null; 
	
		while( (str = is.readLine()) != null ) { 
			if (str.indexOf("filename=\"\"") != -1) {  // filename="" 인 경우
				str = is.readLine(); 
				return ""; 
			} 
			
			if (str.indexOf("filename=") != -1) {
				startIndex = str.indexOf("filename="); 
				endIndex = str.indexOf('\"', startIndex+10);
				filename = str.substring(startIndex+10, endIndex);
				
				if(filename.lastIndexOf("\\") != -1) { 
					filename = filename.substring( filename.lastIndexOf("\\") + 1); 
				}
				return filename;
			}
		}
		return null;
	}
	
	/**
	 * 사용자가 전송한 파일을 특정한 출력 스트림에 저장한다.
	 * 내부적으로 writeFile(OutputStream) 메소드를 호출한다.
	 *
	 * @param out 전송한 파일을 저장할 출력 스트림
	 * @return 사용자가 전송한 파일이 존재하는 경우 파일을 출력 스트림
	 *	out에 전송한 후 true를 리턴하고, 그렇지 않은 경우 false를 리턴한다.
	 */
	public boolean upload(OutputStream out) throws IOException { 
		String str; 
		
		while( (str=is.readLine()) != null ) {
			if (str.indexOf("Content-Type") != -1) {
				str = is.readLine();
				writeFile(out);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 사용자가 전송한 파일을 특정한 출력 스트림에 저장한다.
	 *
	 * @param out 전송한 파일을 저장할 출력 스트림
	 * @return 사용자가 전송한 파일이 존재하는 경우 파일을 출력 스트림 out에
	 * 전송한 후 true를 리턴하고, 그렇지 않은 경우 false를 리턴한다.
	 */
	public void writeFile(OutputStream out) throws IOException {
		byte[] buffer = new byte[1024];		

		byte tm; // 읽어들인 문자를 저장
		byte tempbyte; // 임시로 저장하기 위해 사용
		int x = 0; // buffer에서의 인덱스
		
		while (true) {
			buffer[x++] = tm = d.readByte();
			
			if ( x == delimeter.length()+3) {
				int y = 0;
				String temp = new String(buffer, 0, x);
				
				if ( ( y = temp.indexOf(delimeter) ) != -1) {
					x = y;
					if (x != 0 && x != 2)
						out.write(buffer, 0, x-1);
					return;
				}
			} else {
				if (x == 1023 &&  !(tm == '\n' && buffer[x-2] == '\r' && tm == '\r') ) {
					out.write(buffer, 0, x);
					x = 0;
				} else if ( x > 1 && tm == '\n' && buffer[x-2] == '\r') {
					// \r\n을 입력받는 경우, 마지막에 입력받은 것일 수도 있다.
					// 마지막에 입력받은 \r\n은 추가해서는 안 되므로,
					// 다음 번 추가할 때, 먼저 \r\n을 추가해주는 방향으로 처리한다.
					// \r\n 이전에 입력받은 내용은 모두 OutStream에 출력해준다.
					out.write(buffer, 0, x-2);
					buffer[0] = '\r';
					buffer[1] = '\n';
					x = 2;
				} else if ( x == 1023 && tm == '\r') {
					// \r이 온 경우 다음글자가 \n일 수도 있다. 따라서 확인해봐야 한다.
					tempbyte =d.readByte();
					if (tempbyte == '\n') {
						// \r\n이므로 알맞게 처리한다.
						out.write(buffer, 0, x-1);
						buffer[0] = '\r';
						buffer[1] = '\n';
						x = 2;
					} else {
						out.write(buffer, 0, x);
						buffer[0] = tempbyte;
						x = 1;
					}
				}
			}
		}
	}
}
