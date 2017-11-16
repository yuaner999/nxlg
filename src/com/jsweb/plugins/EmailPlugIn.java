package com.jsweb.plugins;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;
/**
 * Created by liuzg on 2017/2/21.
 */
public class EmailPlugIn {
        /**
         * 发送Text格式邮件
         * @param username 帐号
         * @param password 密码
         * @param from 发信人
         * @param to 收信人
         * @param smtp 服务器
         * @param content   邮件内容
         * @param subject 邮件标题
         * @return
         */
        public boolean SendTextEmail(String username,String password,String from,String to, String smtp,String content,String subject){

            Properties prop = new Properties();
            prop.setProperty("mail.smtp.auth", "true");
            prop.setProperty("mail.smtp.host", smtp);
            prop.put("mail.transport.protocol","smtp");
            Session session = Session.getDefaultInstance(prop);
            session.setDebug(true);


            try {
            /*创建邮件模块*/
                Address fromAddress = new InternetAddress(from);
                Address toAddress = new InternetAddress(to);

                Message message = new MimeMessage(session);
                message.setFrom(fromAddress);
                message.setRecipient(Message.RecipientType.TO, toAddress);
                message.setSentDate(new Date());
                message.setSubject(subject);
                message.setText(content);
                message.saveChanges();

            /*发送邮件模块*/
                Transport transport = session.getTransport("smtp");
                transport.connect(smtp, username, password);
                transport.sendMessage(message, message.getAllRecipients());
                transport.close();
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        }
//        public static void main(String[] args){
//            String s = "<a href='http://www.baidu.com'>百度</a>";
//            EmailUtils.SendHtmlEmail("123456@139.com","123456","123456@139.com","3423008307@qq.com","smtp.139.com",s,"激活验证");
//        }

    }
