/**
 * Created by liuzg on 2016/12/24.
 */

//基于redis的缓存查询
function redisquery(fn, params, mappingstr,expire) {
    var s = sql(fn);
    var vars=  jdbc.getSqlElVars(s);
    var paramstr = varsstr(params,vars);
    var key = s+paramstr;

    var t = redisgetvalue(key)
    if(t!=null&&t.length>0){
        return jsonParse(t).redis;
    }

    var mappingsettings = createmappingitemfromstr(mappingstr);
    if(mappingstr=='') mappingsettings=null;
    var r = jdbc.query(s,params,mappingsettings);

    if(expire)
        redissetvalue(key,jsonStringify({redis:r}),expire);
    else
        redissetvalue(key,jsonStringify({redis:r}),10);
    return r;
}

//基于redis的分页缓存查询，缓存全部数据，分页返回
function redisquerypagedata(fn, params, mappingstr,pagenum,pagesize,expire) {
    var s = sql(fn);
    var vars=  jdbc.getSqlElVars(s);
    var paramstr = varsstr(params,vars);
    var key = s+paramstr;

    if(rediscontainKey(key)) return jsonParse(redisgetvalue(key)).redis;

    var mappingsettings = createmappingitemfromstr(mappingstr);
    if(mappingstr=='') mappingsettings=null;
    var dataset = jdbc.query(s,params,mappingsettings);
    var result = null;
    if(pagenum==null||pagesize==null) result = {total:dataset.length,rows:dataset}
    else result = pagedata(dataset,pagenum,pagesize);

    if(expire)
        redissetvalue(key,jsonStringify({redis:result}),expire);
    else
        redissetvalue(key,jsonStringify({redis:result}),10);
    return result;
}

//生成唯一的参数字符串，用于redis的key
function varsstr(params,vars) {
    var r = "";
    for (var i=0;i<vars.length;i++){
        var varname = vars[i];
        r+= params[varname];
    }
    return r;
}