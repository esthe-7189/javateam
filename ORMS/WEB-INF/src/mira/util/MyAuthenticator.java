package mira.util;

import javax.mail.*;
import javax.mail.internet.*;
import com.sun.mail.smtp.*;

public  class MyAuthenticator extends javax.mail.Authenticator {

    private String userid;
    private String passwd;

    public   MyAuthenticator(String userid, String passwd) {
        this.userid = userid;
        this.passwd = passwd;
    }

    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
        return new javax.mail.PasswordAuthentication(userid, passwd);
    }

}
