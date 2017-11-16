/**
 * Created by NEU on 2017/7/4.
 */
function main(context) {
    if(getsession(context,"sessionUserType")=="学生"){
        return {result:false,errormessage:"无权限"};
    }
    var r= querypagedata(function () {/*
     select * from major
     where  (isDelete is null or isDelete='否')  AND checkStatus='已通过'
     order by convert(majorName USING gbk) COLLATE gbk_chinese_ci

     */},context,"",context.pageNum,context.pageSize);
    return r;
}