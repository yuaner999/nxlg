/**
 * Created by liuzg on 2016/12/24.
 */
//生成UUID
function uuid() {
    return utils.uuid();
}

//计算输入字符串的MD5，返回MD5字符串
function md5(input) {
    return utils.md5(input);
}

function base64(input) {
    return utils.base64(input,"UTF-8");
}

//对象=>json
function jsonStringify(obj) {
    obj = utils.convertNashornObj(obj);
    return utils.jsonStringify(obj);
}

//json=>对象
function jsonParse(jsonstr) {
    return utils.jsonParse(jsonstr);
}

//从本地缓存中获取值
function getmemcache(key) {
    return utils.getMemcache(key);
}

//设置本地缓存的缓存值
function putmemcache(key, value) {
    utils.putMemcache(key,value);
}

//判断本地缓存是否包含
function ismemcachecontains(key) {
    utils.isMemcacheContains(key);
}

//循环
function forEach(list, consumer) {
    for(var i=0;i<list.length;i++) {
        if(consumer) {
            var r = consumer(i,list[i]);
            if(r===true) break;
            if(r=="break") break;
            if(r===false) continue;
            if(r==="continue") continue;
        }
    }
}

//控制台输出
function console(str) {
    utils.console(str);
}

function createlist() {
    return utils.createList();
}

function testsamples(func,inputsamples) {
    if(inputsamples){
        for(var i=0;i<inputsamples.length;i++){
            console("==========================");
            console("测试"+i);
            var sampledata = inputsamples[i];
            var r=func(sampledata);
            console(jsonStringify(r))
        }
    }
}

function createengine(name){
    return utils.createEngine(name)
}

function createorgetengine(name) {
    return utils.createOrGetEngine(name)
}

function removeengine(name) {
    return utils.removeEngine(name)
}

function engineevalandthrow(enginename,code) {
    var engine = createorgetengine(enginename);
    var r = engine.evalAndThrow(code);
    return r;
}

function setjdbc(jdbcdriver,jdbcurl,jdbcusername,jdbcpassword) {
    dynamicjs.setDefaultJdbcDriver(jdbcdriver);
    dynamicjs.setDefaultJdbcUrl(jdbcurl);
    dynamicjs.setDefaultJdbcUsername(jdbcusername);
    dynamicjs.setDefaultJdbcPassword(jdbcpassword);
}