/**
 * Created by NEUNB_Lisy on 2017/5/23.
 */
function main(context) {
    //得到用户id
    var userId = getsession(context,"sessionUserID");
    return userId;
}