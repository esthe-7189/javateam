package mira.notice;

/**
 * UserManager  or  AdminManager의 각 메소드가 처리 과정에서
 * 문제가 있을 때 발생시키는 예외
 */
public class NewsManagerException extends Exception {

    public NewsManagerException(String message) {
        super(message);
    }
    
    public NewsManagerException(String message, Throwable cause) {
        super(message, cause);
    }
}