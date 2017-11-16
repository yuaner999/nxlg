/**
 * Created by Administrator on 2016/12/29.
 */

//批量添加主键约束（更新，插入操作时的动作）
function addpkconstaints(sqlexp) {
    forEach(db.entities,function (i, entity) {
        var pkfieldname = db.getentitypk(entity);
        if(pkfieldname!=null){
            db.constraint(entity.entityname,pkfieldname,"UUID()","UUID()");
        }
    })

}

//构建更新字符串
function buildupdateentitysql(entityname,entitydata,wherestr) {
    var entity = db.getentity(entityname);
    var pkfieldname = db.getentitypk(entity);
    var pairs = []
    var pairstr = ""

    var paramsnames = {}
    for(var p in entitydata) paramsnames[p]=null;
    
    forEach(entity.properties,function (i, property) {
        if(property.fieldname in paramsnames ){
            pairs.push({fieldname:property.fieldname,varname:property.fieldname})
        }
    })

    forEach(pairs,function (i, pair) {
        if(pkfieldname==pair.fieldname) return false;
        var value = "${"+pair.varname+"}"
        var constaint = db.getconstaint(entityname,pair.fieldname);
        if(constaint&&constaint.updatefunc) value = constaint.updatefunc();
        pairstr+=pair.fieldname+"="+value;
        if(i<pairs.length-1) {
            pairstr+=",\r\n"
        }else{
            pairstr+="\r\n"
        }
    })
    
    var sql = "UPDATE "+entityname+" SET\r\n";
    sql+=pairstr;
    
    if(wherestr){
        sql+= "WHERE\r\n";
        sql+= wherestr;
    }else{
        sql+="WHERE\r\n";
        sql+= pkfieldname +"=${"+ pkfieldname +"}";
    }

    return sql;
}

//构建插入字符串
function buildinsertentitysql(entityname, entitydata, isuserpk,isuserdata) {
    var entity = db.getentity(entityname);
    var pkfieldname = db.getentitypk(entity);
    var pairs = []
    var pairstr = ""

    var paramsnames = {}
    for(var p in entitydata) paramsnames[p]=null;

    forEach(entity.properties,function (i, property) {
        if(property.fieldname in paramsnames){
            pairs.push({fieldname:property.fieldname,varname:property.fieldname})
        }else if(property.PK){
            pairs.push({fieldname:property.fieldname,varname:property.fieldname})
        }
    })

    var fieldstr = "";
    var varstr = "";
    forEach(pairs,function (i, pair) {
        var value = "${"+pair.varname+"}" //如果该字段没有约定，且不是主键，则使用用户传入值
        var constaint = db.getconstaint(entityname,pair.fieldname);
        if(constaint&&constaint.newfunc) value = constaint.newfunc();  //如果该字段有约束，则使用约束指定值
        if(isuserpk&&pkfieldname==pair.fieldname) value = "${"+pair.varname+"}" //如果isuserpk=true 则使用用户自定义主键键值
        else if(isuserdata&&pkfieldname!=pair.fieldname) value = "${"+pair.varname+"}"  //isuserdata=true 则使用用户自定义主键键值

        fieldstr+=pair.fieldname;
        varstr+=value;
        if(i<pairs.length-1) {
            fieldstr+=","
            varstr+=","
        }
    })

    var sql = "INSERT INTO "+entityname+"(" + fieldstr + ")\r\n";
    sql+= "VALUES("+varstr+")";

    return sql;

}

//构建删除字符串
function builddeleteentitysql(entityname, wherestr){
    var entity = db.getentity(entityname);
    var pkfieldname = db.getentitypk(entity);
    var sql = "DELETE FROM "+entityname+" \r\n";
    if(wherestr){
        sql+= "WHERE\r\n";
        sql+= wherestr;
    }else{
        sql+="WHERE\r\n";
        sql+= pkfieldname +"=${"+ pkfieldname +"}";
    }
    return sql;
}

//删除实体
function deleteentity(entityname, entitydata,wherestr) {
    var sql = builddeleteentitysql(entityname, wherestr);
    var r = exec(sql,entitydata)
    return {result:r,sql:sql};
}

//更新实体
function updateentity(entityname, entitydata, wherestr) {
    var sql = buildupdateentitysql(entityname, entitydata, wherestr );
    var r = exec(sql,entitydata)
    return {result:r,sql:sql};
}

//插入实体
function insertentity(entityname, entitydata, isuserpk,isuserdata) {
    var sql = buildinsertentitysql(entityname, entitydata, isuserpk,isuserdata);
    var r = exec(sql,entitydata)
    return {result:r,sql:sql};
}

//更新实体
function multiupdateentity(con, entityname, entitydata,wherestr) {
    var sql = buildupdateentitysql(entityname, entitydata, wherestr);
    var r = multiexec(con,sql,entitydata)
    return {result:r,sql:sql};
}

//插入实体
function multiinsertentity(con,entityname, entitydata, isuserpk,isuserdata) {
    var sql = buildinsertentitysql(entityname, entitydata, isuserpk,isuserdata);
    var r = multiexec(con,sql,entitydata)
    return {result:r,sql:sql};
}

//删除实体
function multideleteentity(con,entityname, entitydata,wherestr) {
    var sql = builddeleteentitysql(entityname,wherestr);
    var r = multiexec(con,sql,entitydata)
    return {result:r,sql:sql};
}

//批量更新
function updateentitybatch(con, entityname, entitylistdata,wherestr) {
    var result = true;
    if(!entitylistdata) return {result:false,errormessage:"entitylistdata为空"};
    for(var i=0;i<entitylistdata.length;i++){
        var entitydata = entitylistdata[i];
        var r = multiupdateentity(con,entityname,entitydata,wherestr);
        if(!r.result) return {result:false};
    }
    return {result:result};
}

//批量插入实体
function insertentitybatch(con, entityname, entitylistdata) {
    var result = true;
    if(!entitylistdata) return {result:false,errormessage:"entitylistdata为空"};
    for(var i=0;i<entitylistdata.length;i++){
        var entitydata = entitylistdata[i];
        var r = multiinsertentity(con,entityname,entitydata);
        if(!r.result) return {result:false};
    }
    return {result:result};
}

//插入或更新实体
function insertorupdateentity(entityname, entitydata) {
    var con = createconnection();
    var r = multiinsertorupdateentity(con,entityname,entitydata);
    commit(con);
    closeconnection(con);
    return r;
}

//插入或更新实体
function multiinsertorupdateentity(con,entityname, entitydata) {

    var entity = db.getentity(entityname);
    if(entity==null) return {result:false,errormessage:"实体名:["+entityname+"]不存在"}
    var pkfieldname = db.getentitypk(entity);
    if(pkfieldname==null) return {result:false,errormessage:"实体名:["+entityname+"]无主键"}

    var pkvalue = entitydata[pkfieldname];
    console(pkvalue)
    if(pkvalue==null||pkvalue==""){
        //无主键值，插入该条记录
        var sql = buildinsertentitysql(entityname,entitydata);
        var r = multiexec(con,sql,entitydata);
        return {result:r,sql:sql}
    }else{
        var params = {};
        params[pkfieldname] = pkvalue;
        var r = multiquery(con,"SELECT * FROM "+entityname+" WHERE "+pkfieldname+"=${"+pkfieldname+"}",params,"");

        if(r&&r.length>0){
            //更新
            var sql = buildupdateentitysql(entityname,entitydata,pkfieldname+"="+"${"+pkfieldname+"}");
            var r = multiexec(con,sql,entitydata);
            return {result:r,sql:sql}
        }else{
            //插入
            var sql = buildinsertentitysql(entityname,entitydata,true);
            var r = multiexec(con,sql,entitydata);
            return {result:r,sql:sql}
        }
    }
}

//批量插入或更新实体
function insertorupdateentitybatch(con, entityname, entitylistdata){
    for(var i=0;i<entitylistdata.length;i++) {
        var entitydata = entitylistdata[i];
        var r =  multiinsertorupdateentity(con,entityname,entitydata);
        if(r&&r.result){}
        else return {result:false}
    }
    return {result:true}
}


