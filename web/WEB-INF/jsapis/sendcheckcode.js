/**
 * Created by NEU on 2017/4/7.
 */
function main(context) {
    var lasttime;
    //验证码
    context.content = Math.floor(Math.random()*1000000);
    if(context.content<100000) context.content = "0"+context.content;
    context.content ="您的验证码是"+context.content;
    var r = query(function () {/*
     SELECT *
     FROM `user` WHERE `userName` = ${userName} AND userEmail=${userEmail}
     */},context,"");
    if(r.length>0){
        if(r[0].codeCreateDate==null){
            lasttime=0;
        }else{
            lasttime=r[0].codeCreateDate.getTime();
        }
    }
    var nowtime = new Date();
    nowtime=nowtime.getTime();
    // 两次发送邮件的时间间隔是(nowtime-lasttime.getTime())/1000+"s")
    if((nowtime-lasttime)>3600000){
        var rrr=email.SendTextEmail("15698841009@139.com","zhangyuan410183","15698841009@139.com",context.userEmail,"smtp.139.com",context.content,"宁夏理工选课系统-用户密码找回");
        console("哈哈哈"+rrr);
        if(rrr){
            var rr =  exec(
                function () {/*
                 UPDATE `user`
                 SET
                 `codeContent` = ${content},
                 `codeCreateDate` = NOW()
                 WHERE `userName` = ${userName} AND userEmail=${userEmail}
                 */},
                context);
            if(rr){
                return {result:rr};
            }else return {result:false,errormessage:"系统错误"};
        }else{
            return {result:false,errormessage:"验证码发送失败"};
        }
    }else{
        return{result:false,errormessage:"1小时内不能重复发送，请查看邮箱验证码"}
    }

}

inputsamples=[
    {
        userName:"test1",
        userEmail:"2854478196@qq.com"
    }
];