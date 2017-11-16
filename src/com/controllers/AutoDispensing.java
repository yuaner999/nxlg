package com.controllers;

import com.common.DLog;
import com.common.DTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 *平台选课结束后第一天02:00自动智能排课
 * @author zcy
 * Created by zcy on 2017/5/23.
 */
@Service
public class AutoDispensing {
    @Autowired
    private AutoDispensingController AutoDispensingController;
    //每分钟执行一次
//    @Scheduled(fixedDelay = 60000)
    @Scheduled(cron = "0 0 2 * * ?")     //每天2点执行
    public void autoExec() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");//设置日期格式
        String result = "{}";
        try {
            DTable bllWordbook = new DTable("wordbook");
            String a = "其他专业课程选课结束时间";
            Map<String, String> tblWordbook = bllWordbook.where("1=1 and wordbookKey=?", new ArrayList<String>() {{
                add(a);
            }}).find();
            SimpleDateFormat auto_time = new SimpleDateFormat("yyyy-MM-dd 02:00");//设置时间为第二天02:00
            String time = tblWordbook.get("wordbookValue");
            Date date=df.parse(time);
            Calendar calendar=new GregorianCalendar();//获得
            calendar.setTime(date);
            calendar.add(calendar.DATE,1);//后一天
            date=calendar.getTime();
            String c=auto_time.format(date);
            String b=df.format(new Date());
            if(b.equals(c)){
                Object re = AutoDispensingController.Dispensing();
                //result =  "{'result':\" + re + \",'msg':'执行成功'}";
            }
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
           // result = "{'result':0,'msg':'执行错误:" + ex.getMessage() + "'}";
        }

    }
}
