package com.utils;

import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 * 常用的加密、解密工具(md5,AES)、异或运算来合并字符串
 * @author hong
 * Created by admin on 2015/12/5.
 */
public final class PwdUtil {
    private final static String HEX_NUMS_STR = "0123456789ABCDEF";
    private static final String ALGORITHM_MD5 = "MD5";
    private static final String pwd="99fd359f98480732304661b06ecb4d24";

    /**
     * 字符串合并计算，应用字符串转byte[]，然后进行位异或运算，再输出字符串，输出结果再次与同一key调用该方法则得到原字符串
     * ^ 为异或运算符
     * @param str   要合并计算的字符串
     * @param key   合并计算的key，输出结果和原key再次传入该方法，则得到合并前的字符串
     * @return      合并后的字符串
     * @throws UnsupportedEncodingException     MD5运算的异常
     * @throws NoSuchAlgorithmException     MD5运算的异常
     */
    public static String mergeStringWithXOROperation(String str,String key) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        byte[] strBytes=str.getBytes();
        byte[] keyBytes=getPassMD5(key).getBytes();
        byte[] result=new byte[strBytes.length];
        for(int i=0,j=0;i<strBytes.length;i++,j++){
            //如果str的长度比加密之后的key长，则循环和加密后的key计算
            if(i>=keyBytes.length) j=0;
            byte num= keyBytes[j];
            int temp=strBytes[i]^num;
            //判断计算的结果是否是ascii码中的打印字符（不算空格【32】和backspace【127】）如果是的话就再异或一次得到原字符；
            if(temp<33 || temp>126) temp=temp^num;
            result[i]= (byte) temp;
        }
        return new String(result);
    }

    /**
     * 用md5算法加密 密码
     * @param pass the password to encryption
     * @return encryption string
     */
    public static String getPassMD5(String pass) throws NoSuchAlgorithmException,UnsupportedEncodingException {
        String keys;

            MessageDigest md = MessageDigest.getInstance(ALGORITHM_MD5);
            if (pass == null) {
                pass = "";
            }
            byte[] bPass = pass.getBytes("UTF-8");
            md.update(bPass);
            keys = bytesToHexString(md.digest());

        return keys;
    }

    /**
     * 将文本AES加密后返回十六进制字符串，外面调用此方法即可
     * @param content 要加密的文本
     * @return
     */
    public static String AESEncoding(String content){
        if(content==null) return null;
        if(content.equals("")) return "";
        byte[] bytes=encrypt(content,pwd);
        return bytesToHexString(bytes);
    }

    /**
     * AES解密，将加密后的十六进制字符串解密成原文，外面调用此方法
     * @param ciphertext    加密后的密文
     * @return
     */
    public static String AESDecoding(String ciphertext){
        if(ciphertext==null) return null;
        if(ciphertext.equals("")) return "";
        if(ciphertext.length()<16) return ciphertext;
        byte[] bytes=hexStringToByte(ciphertext);
        byte[] result=decrypt(bytes,pwd);
        String re = null;
        try {
            re= new String(result,"utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return re;
    }

    /**
     * AES加密
     * @param content 需要加密的内容
     * @param password  加密密码
     * @return
     */
    public static byte[] encrypt(String content, String password) {
        try {
            KeyGenerator kgen = KeyGenerator.getInstance("AES");
            kgen.init(128, new SecureRandom(password.getBytes()));
            SecretKey secretKey = kgen.generateKey();
            byte[] enCodeFormat = secretKey.getEncoded();
            SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
            Cipher cipher = Cipher.getInstance("AES");// 创建密码器
            byte[] byteContent = content.getBytes("utf-8");
            cipher.init(Cipher.ENCRYPT_MODE, key);// 初始化
            byte[] result = cipher.doFinal(byteContent);
            return result;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * AES解密
     * @param content  待解密内容
     * @param password 解密密钥
     * @return
     */
    public static byte[] decrypt(byte[] content, String password) {
        try {
            KeyGenerator kgen = KeyGenerator.getInstance("AES");
            kgen.init(128, new SecureRandom(password.getBytes()));
            SecretKey secretKey = kgen.generateKey();
            byte[] enCodeFormat = secretKey.getEncoded();
            SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
            Cipher cipher = Cipher.getInstance("AES");// 创建密码器
            cipher.init(Cipher.DECRYPT_MODE, key);// 初始化
            byte[] result = cipher.doFinal(content);
            return result;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 将beye[]转换为十六进制字符串
     * @param bArray
     * @return
     */
    public static final String bytesToHexString(byte[] bArray) {
        StringBuffer sb = new StringBuffer(bArray.length);
        String sTemp;
        for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2){
                sb.append(0);
            }
            sb.append(sTemp.toUpperCase());
        }
        return sb.toString();
    }

    /**
     * 将16进制字符串转换成数组
     *
     * @return byte[]
     * @author jacob
     */
    public static byte[] hexStringToByte(String hex) {
        /* len为什么是hex.length() / 2 ?
         * 首先，hex是一个字符串，里面的内容是像16进制那样的char数组
         * 用2个16进制数字可以表示1个byte，所以要求得这些char[]可以转化成什么样的byte[]，首先可以确定的就是长度为这个char[]的一半
         */
        int len = (hex.length() / 2);
        byte[] result = new byte[len];
        char[] hexChars = hex.toCharArray();
        for (int i = 0; i < len; i++) {
            int pos = i * 2;
            //第i个字符转换成高位二进制的四位数，再拼接上i+1个字符形成一个8位有效的二进制位
            result[i] = (byte) (HEX_NUMS_STR.indexOf(hexChars[pos]) << 4 | HEX_NUMS_STR.indexOf(hexChars[pos + 1]));
        }
        return result;
    }
}
