package com.common;

/**
 * Created by szy on 15/11/9.
 */
public class DString {
    public static final char UNDERLINE = '_';

    public static String camelToUnderline(String param) {
        if (param == null || "".equals(param.trim())) {
            return "";
        }
        int len = param.length();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c = param.charAt(i);
            if (Character.isUpperCase(c)) {
                sb.append(UNDERLINE);
                sb.append(Character.toLowerCase(c));
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    public static String toBigCamelCase(String param) {
        if (param == null || "".equals(param.trim())) {
            return "";
        }
        int len = param.length();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c = param.charAt(i);
            if (c == UNDERLINE) {
                if (++i < len) {
                    sb.append(Character.toUpperCase(param.charAt(i)));
                }
            } else {
                sb.append(c);
            }
        }
        return ucFirst(sb.toString());
    }

    public static String toLittleCamelCase(String param) {
        return lcFirst(toBigCamelCase(param));
    }


    public static String lcFirst(String s) {
        if (Character.isLowerCase(s.charAt(0)))
            return s;
        else
            return (new StringBuilder()).append(Character.toLowerCase(s.charAt(0))).append(s.substring(1)).toString();
    }

    //首字母转大写
    public static String ucFirst(String s) {
        if (Character.isUpperCase(s.charAt(0)))
            return s;
        else
            return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();
    }

    public static void main(String[] args) {
//        System.out.println(DString.toBigCamelCase("xy_article"));
//        System.out.println(DString.toLittleCamelCase("xy_article"));
    }

    public static String stripTags(String origStr) {
        if (origStr == null || !origStr.contains("<")) {
            return origStr;
        }

        origStr = origStr.replaceAll("<[^>]*>", "");
        if (origStr.contains("&")) {
            origStr = origStr.replaceAll("&[a-zA-Z]{1,10};", "");
        }
        return origStr;
    }

    // 截取字符串
    public static String cutStr(String input, int length) {

        input = stripTags(input);

        int len = input.length();
        if (len <= length) {
            return input;
        } else {
            input = input.substring(0, length);
            input += "...";
        }
        return input;
    }

    /**
     * 当浮点型数据位数超过10位之后，数据变成科学计数法显示。用此方法可以使其正常显示。
     * @param value
     * @return Sting
     */
    public static String formatFloatNumber(double value) {
        if(value != 0.00){
            java.text.DecimalFormat df = new java.text.DecimalFormat("#######0.00");
            return df.format(value);
        }else{
            return "0.00";
        }

    }
    public static String formatFloatNumber(Double value) {
        if(value != null){
            if(value.doubleValue() != 0.00){
                java.text.DecimalFormat df = new java.text.DecimalFormat("#######0.00");
                return df.format(value.doubleValue());
            }else{
                return "0.00";
            }
        }
        return "";
    }
    public static String formatFloatNumber(double value,int length) {
        if(value != 0.00){
            String format="#######0";
            if(length>0){
                format=format+".";
            }
            for(int i=0;i<length;i++){
                format=format+"0";
            }
            java.text.DecimalFormat df = new java.text.DecimalFormat(format);
            return df.format(value);
        }else{
            return "0.00";
        }

    }
    public static String formatFloatNumber(Double value,int length) {
        if(value != null){
            if(value.doubleValue() != 0.00){
                String format="#######0";
                if(length>0){
                    format=format+".";
                }
                for(int i=0;i<length;i++){
                    format=format+"0";
                }
                java.text.DecimalFormat df = new java.text.DecimalFormat(format);
                return df.format(value.doubleValue());
            }else{
                return "0.00";
            }
        }
        return "";
    }

    public static String SubString(String str,Integer length){
        if(length>=str.length()){
            return str;
        }
        return str.substring(0,length)+"...";
    }
}