package com.common;

/**
 * DLog
 * Created by szy on 15/11/21.
 */
public class DLog {
    public static int LOG_LEVEL_ALERT = 1;
    public static int LOG_LEVEL_ERROR = 3;
    public static int LOG_LEVEL_WARNING = 4;
    public static int LOG_LEVEL_NOTICE = 5;
    public static int LOG_LEVEL_INFO = 6;
    public static int LOG_LEVEL_DEBUG = 7;
    static String logDir = D.WEB_ROOT_DIR+"/log/";

    public static void w(Object o) {
//        int level = Integer.parseInt(DConfig.get("global.log_level") + "");
        w(o, 7,"");
    }

    public static void w(Object o,String method) {
//        int level = Integer.parseInt(DConfig.get("global.log_level") + "");
        w(o, 7,method);
    }

    public static void w(Object o,Exception method) {
//        int level = Integer.parseInt(DConfig.get("global.log_level") + "");
        w(o, 7,"");
    }

    public static void w(Object o, int LOG_LEVEL,String method) {
        try {
            if(D.WEB_ROOT_DIR.equals("")){
                logDir="C://log/";
            }else {
                if(D.WEB_ROOT_DIR.endsWith("/")){
                    logDir = D.WEB_ROOT_DIR+"log/";
                }else
                {
                    logDir = D.WEB_ROOT_DIR+"/log/";
                }

            }
            String currentDataTime = D.CURRENT_DATETIME_ALL();

            String logFilePath = logDir + currentDataTime.substring(0, 7) + "/" + currentDataTime.substring(0, 10) + ".log";

            DFile f = new DFile(logFilePath);
            String uri="none";
            if(D.REQUEST!=null&&D.REQUEST.getRequestURI()!=null){
                uri=D.REQUEST.getRequestURI();
            }
            f.append(currentDataTime.substring(11) + "\t" + o + "----(" + uri + ")-----"+method+"-----\r\n");
            if (LOG_LEVEL == LOG_LEVEL_ERROR) {
                System.err.println("----------\n" + o + "\n----------");
            } else{
//                System.out.println(o);
            }
            if(f.getLength()>1100000) {
                f.rename(logDir + currentDataTime.substring(0, 7) + "/" + currentDataTime.substring(0, 10) +"-"+ currentDataTime.substring(11, 13)+ currentDataTime.substring(14, 16)+ currentDataTime.substring(17, 19) +".log");
            }
        }
        catch (Exception ex){

        }
    }



    public static void setLogDir(String dir) {
        DLog.logDir = dir;
    }


    public static void error(Object o) {
        w(o, LOG_LEVEL_ERROR,"");
    }
    public static void error(Object o,String method) {
        w(o, LOG_LEVEL_ERROR,method);
    }
}
