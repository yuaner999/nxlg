/**
 * Created by liuzg on 2016/12/21.
 */
//将函数转换为sql语句
function sql(fn) {
    if(typeof fn=='function'){
        var fnstr = fn.toString().split('\n').slice(1,-1).join('\n') + '\n';
        return fnstr;
    }else{
        return fn;
    }
}

//切割字符串
function splitmappingstr(mappingstr) {
    var result = [];
    var lastcommaindex = 0;
    var lastquotindex = 0;
    var state = 0;
    for (var i=0;i<mappingstr.length;i++){
        if(mappingstr[i]==','&&state==0){
            var t = mappingstr.substr(lastcommaindex,i-lastcommaindex);
            result.push(t);
            lastcommaindex = i+1;
        }else if(mappingstr[i]==':'){
            state=1;
        }else if(mappingstr[i]=='['){
            lastquotindex = i;
            state=1;
        }else if(mappingstr[i]==']'){
            state=0;
        }else if(mappingstr[i]=='('){
            lastquotindex = i;
            state=1;
        }else if(mappingstr[i]==')'){
            state=0;
        }
    }
    var t = mappingstr.substr(lastcommaindex);
    result.push(t);
    return result;
}

//创建映射设置
function createmappingitem(fieldsetting){
    var result = null;
    var index = fieldsetting.indexOf(':');
    if(index>=0){
        var property = fieldsetting.substr(0,index);
        var subsettingstr = fieldsetting.substring(index+2,fieldsetting.length-1);

        if(fieldsetting[index+1]=="[")
            result = jdbc.createMappingSetting(property,'',"list");
        else if(fieldsetting[index+1]=="(")
            result = jdbc.createMappingSetting(property,'',"object");
        
        var subfieldsettings = splitmappingstr(subsettingstr);
        for(var i=0;i<subfieldsettings.length;i++){
            var subfieldsetting = subfieldsettings[i];
            var r = createmappingitem(subfieldsetting);
            jdbc.addSubSetting(result,r);
        }

    }else{
        var index = fieldsetting.indexOf("|");
        if(index>=0){
            var field = fieldsetting.substr(0,index);
            var property = fieldsetting.substr(index+1);
            result = jdbc.createMappingSetting(property,field,"");
        }else{
            result = jdbc.createMappingSetting(fieldsetting,fieldsetting,"");
        }

    }
    return result;
}

//从字符串创建映射设置 "categoryid,categoryname,categorydescription,dishes:[dishid,dishname,dishprice]"
function createmappingitemfromstr(mappingstr){
    var result = [];
    var fieldsettings = splitmappingstr(mappingstr);
    for(var i=0;i<fieldsettings.length;i++){
        var fieldsetting = fieldsettings[i];
        var item = createmappingitem(fieldsetting);
        result.push(item);
    }
    return result;
}

//单查询sql（查询后连接自动关闭）
function query(fn,params,mappingstr) {
    var s = sql(fn);
    var mappingsettings = null;
    if(mappingstr=='') mappingsettings=null;
    else mappingsettings = createmappingitemfromstr(mappingstr);
    return jdbc.query(s,params,mappingsettings);
}

//分页查询
function querypagedata(fn, params, mappingstr, pagenum, pagesize) {
    var dataset = query(fn,params,mappingstr);
    if(pagenum==null||pagesize==null) return {total:dataset.length,rows:dataset};
    else return pagedata(dataset,pagenum,pagesize);
}

//多查询sql（查询后连接自动关闭）
function multiquery(con,fn,params,mappingstr) {
    var s = sql(fn);
    var mappingsettings = null;
    if(mappingstr=='') mappingsettings=null;
    else mappingsettings = createmappingitemfromstr(mappingstr);
    return jdbc.query(con,s,params,mappingsettings);
}

function exec(fn, params) {
    var s = sql(fn);
    var r = jdbc.exec(s,params);
    return r;
}

function multiexec(con, fn, params) {
    var s = sql(fn);
    var r = jdbc.exec(con,s,params);
    return r;
}

//结果列表分页
function pagedata(dataset, pagenum, pagesize) {
    return jdbc.pagedata(dataset,pagenum,pagesize);
}

//创建连接
function createconnection() {
    return jdbc.createConnection();
}

//创建自定义jdbc连接（无连接池）
function createjdbconnection(driver,url,username,password) {
    return jdbc.createConnection(driver,url,username,password);
}

//关闭连接
function closeconnection(con) {
    jdbc.closeConnection(con);
}

//提交数据
function commit(con) {
    return jdbc.commit(con);
}

//回滚
function rollback(con) {
    return jdbc.rollback(con);
}
