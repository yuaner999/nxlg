/**
 * Created by NEU on 2017/3/24.
 */
function main(context) {
    //数据非空判断
    if(context.userId == null||context.password == null){
        return false;
    }
    var result=exec(function () {/*
      update user set  password=ENCODE(${password},'371df050-00b3-11e7-829b-00ac2794c53f') where userId=${userId}
    */},context,"")
    return result;
}