/**
 * Created by NEU on 2017/4/13.
 */
function main(context) {
    //基础数据非空判断
    if(context.userName == null||context.phone == null){
        return false;
    }
    //验证码
    context.content = Math.floor(Math.random()*1000000);
    if(context.content<100000) context.content = "0"+context.content;
    context.content ="您的验证码是"+context.content;
    //手机号验证码当天只能发送5条
    var r = query(function () {/*
     SELECT
     COUNT(`codeCreatDate`) as sendcout
     FROM
     `codephone`
     WHERE TIMESTAMPDIFF(HOUR,`codeCreatDate`,NOW())<24 and phone=${UCphone}
     */},context,"");
    if(r[0].sendcout<5){
        var rrr=webchinesesms.sendSms(context.UCphone,context.content);
        if(rrr){
            var rr =  exec(
                function () {/*
                 UPDATE `user`
                 SET
                 `codePhone` = ${content},
                 `codePhoneDate` = NOW()
                 WHERE `userName` = ${userName};

                 INSERT INTO `codephone` (
                 `codeId`,
                 `phone`,
                 `codeContent`,
                 `codeCreatDate`
                 )
                 VALUES
                 (
                 UUID(),
                 ${UCphone},
                 ${content},
                 NOW()
                 ) ;
                 */},
                context);
            if(rr){
                return {result:rr,errormessage:"手机验证码更新失败"};
            }else {
                return {result:false,errormessage:"系统错误"};
            }
        }else{
            return {result:false,errormessage:"手机验证码发送失败"};
        }
    }else{
        return{result:false,errormessage:"手机号验证码当天只能发送5条"}
    }
}

inputsamples=[
    {
        userName:"test1",
        phone:"111111111111"
    }
];
