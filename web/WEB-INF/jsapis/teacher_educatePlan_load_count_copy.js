/**
 * Created by NEU on 2017/9/15.
 * user : songjian
 */
function main(context){
    //这个参数用于判断从哪个位置进入的接口 if v = _copy 执行第一个，if v = _select 执行第二个
    var flag = context.v;
    //用于存放返回的信息(包含要被复制的信息和一级菜单的信息)
    if(flag == "_copy"){
        var showMessage = "";
            //查询当前要被复制的内容
        var copyResult = query(function(){/*
            SELECT  educateplane.*,course.*
            FROM    educateplane LEFT JOIN course ON
                (educateplane.ep_courseid = course.`courseId`)
            WHERE   educateplane.`ep_college` = ${majorCollege}
                AND
                educateplane.`ep_major` = ${majorName}
                AND
                educateplane.`ep_grade` = ${gradeName}
                AND
                (educateplane.`ep_checkStatus` = '已通过'
                OR
                educateplane.`ep_checkStatus` = '待审核')
         */},context,"");

         //如果没有查询到已通过的信息，那么不允许复制，返回提示信息
        if(copyResult.length == 0){
            showMessage = "没有已通过的信息，无法复制";
            return {result:false,errormessage:showMessage};
         };

        //返回查询到的信息
        return {result:true,_copyInf:copyResult}
    }
}