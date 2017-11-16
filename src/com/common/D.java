package com.common;


import javax.servlet.http.HttpServletRequest;
import java.text.DecimalFormat;

/**
 * F
 * Created by szy on 15/11/23.
 */
public class D {
    public static String WEB_ROOT_DIR = "";
    public static boolean DEBUG = false;
    public static String clientIP = "";

    public static HttpServletRequest REQUEST;

    public static String randNumber(int length) {
        return (Math.random() + "").substring(3, 3 + length);
    }

    public static String formatMoney(String amount) {
        return formatNumber(amount, "###,###.00");
    }
    public static String formatMoney2(String amount) {
        return formatNumber(amount, "#.00");
    }

    public static String formatNumber(String amount, String pattern) {
        String ret = "0";

        try {
            double iAmount = Double.valueOf(amount);

            DecimalFormat myFormat = new DecimalFormat();
            myFormat.applyPattern(pattern);
            ret = myFormat.format(iAmount);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ret;
    }

    public static String CURRENT_DATETIME() {
        return DDateUtil.getCurrentDateTime();
    }

    public static String  CURRENT_DATETIME_ALL(){
        return DDateUtil.getCurrentDateTimeAll();
    }

    /**
     * 获得当前世间戳
     *
     * @return 当前世间戳
     */
    public static long getCurrentTimestamp() {
        return System.currentTimeMillis() / 1000;
    }


    @SuppressWarnings("unchecked")
    public static <T> T cast(Object obj) {
        return (T) obj;
    }

}