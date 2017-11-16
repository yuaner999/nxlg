package com.controllers;

import com.common.DLog;
import com.common.DTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import sun.java2d.pipe.SpanShapeRenderer;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 *教材自助缴费开始前一个小时自动生成缴费表
 * @author zcy
 * Created by zcy on 2017/5/23.
 */
@Service
public class AutoPaymentInfo {
    @Autowired
    private PaymentInfoController paymentInfoController;
    //每天23：15执行一次，判断第二天是不是缴费开始日期 是的话执行if语句
    @Scheduled(cron = "0 15 23 * * *")
    public static void autoExec(){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
        String result = "{}";
        try {
            DTable bllWordbook = new DTable("wordbook");
            String a = "教材自助缴费开始时间";

            Map<String, String> tblWordbook = bllWordbook.where("1=1 and wordbookKey=?", new ArrayList<String>() {{
                add(a);
            }}).find();

            String time = tblWordbook.get("wordbookValue");

            Date date=df.parse(time);

            String b=df.format(new Date());
            String c=df.format(date.getTime()-24*60*60*1000);

            if(b.equals(c)){
                PaymentInfoController.getInfo();
                PaymentInfoController.getbuyingbeforeinfo();
            }
//           注释了 统计教材购买数量 不用等到缴费结束，允许欠费，挪到上一行缴费之前一小时执行了
           /* if(timeend.equals(df.format(new Date()))){
                PaymentInfoController.getbuyingbeforeinfo();
            }*/
        }catch (Exception ex) {
            DLog.w(ex.getMessage());
        }
    }

}
