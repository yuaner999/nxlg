/**
 * Created by NEU on 2017/4/13.
 */
function main(context) {
    var lasttime;
    //验证码
    context.content = Math.floor(Math.random()*1000000);
    if(context.content<100000) context.content = "0"+context.content;
    context.content ="您的验证码是"+context.content;
    //发送间隔，1小时。
    var r = query(function () {/*
     SELECT *
     FROM `user` WHERE `userName` = ${userName} AND userEmail=${UCemail}
     */},context,"");
    if(r.length>0){
        if(r[0].codeEmailDate==null){
            lasttime=0;
        }else{
            lasttime=r[0].codeEmailDate.getTime();
        }
    }
    var nowtime = new Date();
    nowtime=nowtime.getTime();
    if((nowtime-lasttime)>3600000){
        var rrr=email.SendTextEmail("15698841009@139.com","zhangyuan410183","15698841009@139.com",context.userEmail,"smtp.139.com",context.content,"找回密码");
        var rrr=true;
        if(rrr){
            var rr =  exec(
                function () {/*
                 UPDATE `user`
                 SET
                 `codeEmail` = ${content},
                 `codeEmailDate` = NOW()
                 WHERE `userName` = ${userName};

                 INSERT INTO `codeemail` (
                 `codeId`,
                 `email`,
                 `codeContent`,
                 `codeCreatDate`
                 )
                 VALUES
                 (
                 UUID(),
                 ${UCemail},
                 ${content},
                 NOW()
                 ) ;
                 */},
                context);
            if(rr){
                return {result:rr,errormessage:"邮箱验证码更新失败"};
            }else {
                return {result:false,errormessage:"系统错误"};
            }
        }else{
            return {result:false,errormessage:"邮箱验证码发送失败"};
        }
    }else{
        return{r:true,errormessage:"1小时内不能重复发送，请查看邮箱验证码"}
    }

}

inputsamples=[
    {
        userName:"test1",
        phone:"111111111111"
    }
];
