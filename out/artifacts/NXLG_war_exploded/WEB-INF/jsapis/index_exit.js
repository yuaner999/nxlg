/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //退出登录，清除Session
    setsession(context,"sessionUserName",null);
    setsession(context,"sessionUserID",null);
}
