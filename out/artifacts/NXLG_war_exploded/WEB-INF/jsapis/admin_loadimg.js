/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //加载图片和用户名
    var result = query(function () {/*
     SELECT admin.adminIcon,user.userName
     FROM admin 
     LEFT JOIN user ON admin.adminId = user.typeId
     WHERE adminId=${adminId}
    */},context,"");
    return result;
}