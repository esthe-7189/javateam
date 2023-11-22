package mira.util;

import javax.servlet.http.HttpServletRequest; 
import java.io.*; 

/**
 * multipart/form-data �������� ���޵Ǵ� HTML �� �����͸�
 * �о�� �� ���Ǵ� ��ƿ��Ƽ Ŭ�����̴�.<br>
 * ����ڰ� ������ ������ Ư���� ��� ��Ʈ��(�Ϲ������� FileOutputStream)��
 * �����ϱ� ���� ���ȴ�.
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
	 * ������ �̸��� ���� �Ķ������ ���� ���Ѵ�.
	 *
	 * @param name �о�� �Ķ������ �̸�
	 * @return ������ �̸��� ���� �Ķ������ ��. ���� ��� null�� �����Ѵ�.
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
	 * ������ ������ �̸��� ���Ѵ�.<br>
	 * filename="" ���� ���۵� ��� ""�� �����Ѵ�.<br>
	 *
	 * @return ������ ���� �̸�. �����̸��� ���� ��� null�� �����Ѵ�.
	 */
	public String getFilename() throws IOException { 
		String str = null; 
		int startIndex; 
		int endIndex; 
		String filename = null; 
	
		while( (str = is.readLine()) != null ) { 
			if (str.indexOf("filename=\"\"") != -1) {  // filename="" �� ���
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
	 * ����ڰ� ������ ������ Ư���� ��� ��Ʈ���� �����Ѵ�.
	 * ���������� writeFile(OutputStream) �޼ҵ带 ȣ���Ѵ�.
	 *
	 * @param out ������ ������ ������ ��� ��Ʈ��
	 * @return ����ڰ� ������ ������ �����ϴ� ��� ������ ��� ��Ʈ��
	 *	out�� ������ �� true�� �����ϰ�, �׷��� ���� ��� false�� �����Ѵ�.
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
	 * ����ڰ� ������ ������ Ư���� ��� ��Ʈ���� �����Ѵ�.
	 *
	 * @param out ������ ������ ������ ��� ��Ʈ��
	 * @return ����ڰ� ������ ������ �����ϴ� ��� ������ ��� ��Ʈ�� out��
	 * ������ �� true�� �����ϰ�, �׷��� ���� ��� false�� �����Ѵ�.
	 */
	public void writeFile(OutputStream out) throws IOException {
		byte[] buffer = new byte[1024];		

		byte tm; // �о���� ���ڸ� ����
		byte tempbyte; // �ӽ÷� �����ϱ� ���� ���
		int x = 0; // buffer������ �ε���
		
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
					// \r\n�� �Է¹޴� ���, �������� �Է¹��� ���� ���� �ִ�.
					// �������� �Է¹��� \r\n�� �߰��ؼ��� �� �ǹǷ�,
					// ���� �� �߰��� ��, ���� \r\n�� �߰����ִ� �������� ó���Ѵ�.
					// \r\n ������ �Է¹��� ������ ��� OutStream�� ������ش�.
					out.write(buffer, 0, x-2);
					buffer[0] = '\r';
					buffer[1] = '\n';
					x = 2;
				} else if ( x == 1023 && tm == '\r') {
					// \r�� �� ��� �������ڰ� \n�� ���� �ִ�. ���� Ȯ���غ��� �Ѵ�.
					tempbyte =d.readByte();
					if (tempbyte == '\n') {
						// \r\n�̹Ƿ� �˸°� ó���Ѵ�.
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
