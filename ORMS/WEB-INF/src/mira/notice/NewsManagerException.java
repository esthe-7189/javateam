package mira.notice;

/**
 * UserManager  or  AdminManager�� �� �޼ҵ尡 ó�� ��������
 * ������ ���� �� �߻���Ű�� ����
 */
public class NewsManagerException extends Exception {

    public NewsManagerException(String message) {
        super(message);
    }
    
    public NewsManagerException(String message, Throwable cause) {
        super(message, cause);
    }
}