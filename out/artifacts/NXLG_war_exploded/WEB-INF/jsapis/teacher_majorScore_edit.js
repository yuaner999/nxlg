/**
 * Created by NEU on 2017/4/22.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.majorId == null||context.terraceId == null){
        return false;
    }
    //专业平台学分设置
    var r = query(function () {/*
     SELECT * FROM `majorterracescore` WHERE terraceId=${terraceId} AND majorId=${majorId}
     */}, context, "");
    if (r==null||r.length==0) {//添加     //r为空时r.length报错
        var rr = exec(function () {/*
         insert into `majorterracescore` (
         `id`,
         `majorId`,
         `terraceId`,
         `scoreall`,
         `scoretotal`,
         `scorethis`,
         `scoreother`,
         `setman`,
         `setdate`
         )
         values
         (
         UUID(),
         ${majorId},
         ${terraceId},
         ${scoreall},
         ${scoretotal},
         ${scorethis},
         ${scoreother},
         ${sessionUserName},
         NOW()
         );
         */}, context);
        return rr;
    }else {//更新
        context.ID=r[0].id;
        var rr = exec(function () {/*
         UPDATE `majorterracescore`
         SET
         `scoreall` = ${scoreall},
         `scoretotal` = ${scoretotal},
         `scorethis` = ${scorethis},
         `scoreother` =${scoreother},
         `setman` = ${sessionUserName},
         `setdate` = NOW()
         WHERE `id` = ${ID};
         */}, context);
        return rr;
    }
}
var inputsamples=[{
    terraceId:"11fd3def8-2415-11e7-be40-00ac9c2c0afa1",
    majorId:"d795fafd-0e07-11e7-843d-00ac9c2c0afa"
}]