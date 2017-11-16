/**
 * Created by NEU on 2017/5/3.
 */
function main(context) {
    //验证是否是教师用户
    var Type = getsession(context,"sessionUserType");
    return Type;
}
