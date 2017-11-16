/**
 * Created by NEU on 2017/4/21.
 * 修改教材信息
 */
function main(context) {
    //数据非空判断
    if(context.booknumber == null ||context.name == null ||context.press == null ||context.edition == null ||
        context.price == null||context.tmId == null){
        return false;
    }
    var r=query(function () {/*
     SELECT tmId
     FROM teachingmaterials
     WHERE name=${name} AND press=${press} AND edition=${edition} AND booknumber=${booknumber} AND price=${price} AND isdelete = '0'
     */},context,"");
    if(r.length>0&&r[0].tmId!=context.tmId){
        return 1;
    }
    var result = exec(function () {/*
     UPDATE
     `teachingmaterials`
     SET
     `name` = ${name},
     `press` = ${press},
     `edition` = ${edition},
     `booknumber` = ${booknumber},
     `price` = ${price}
     WHERE `tmId` = ${tmId}
     */},context);
    return result;
}