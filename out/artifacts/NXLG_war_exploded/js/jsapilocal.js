/**
 * Created by liuzg on 2017/2/18.
 */

function buildremoteservice() {
    var name = '';
    var fn = null;
    var params= {}
    if(arguments.length==3){
        name = arguments[0];
        fn=arguments[1];
        params=arguments[2];
    }else if(arguments.length==2){
        fn=arguments[0];
        params=arguments[1];
    }

    var fncode = fn.toString();
    var index0 = fncode.indexOf('function');
    var index1 = fncode.indexOf('{');
    var index2 = fncode.lastIndexOf('}');

    if(index0>=0&&index1>index0&&index2>index1){
        var code = fncode.substring(index1+1,index2);
        params.code_=code;
        var r = remotecall("dynamicjsapi",params);
        if(r.result) return r.return;
        else throw r.error;
    }
}

function setjdbc(driver, url, username, password) {
    remotecall("setjdbccon",{jdbcdriver:driver,jdbcurl:url,jdbcusername:username,jdbcpassword:password});
}

function readfile(filepath, encoding) {
    return buildremoteservice(function () {
        return readfile(context.filepath,context.encoding);
    },{filepath:filepath,encoding:encoding})
}

function writefile(filepath, content, encoding) {
    return buildremoteservice(function () {
        return writefile(context.filepath,context.content,context.encoding);
    },{filepath:filepath,encoding:encoding,content:content})
}

function deletefile(fileordir) {
    return buildremoteservice(function () {
        return deletefile(context.fileordir);
    },{fileordir:fileordir})
}

function mkdir(dir) {
    return buildremoteservice(function () {
        return mkdir(context.dir);
    },{dir:dir})
}

function searchFiles(dir, keyword) {
    return buildremoteservice(function () {
        return searchFiles(context.dir, context.keyword)
    },{dir:dir,keyword:keyword})
}

function listfileitems(dir) {
    return buildremoteservice(function () {
        return listfileitems(context.dir)
    },{dir:dir})
}

function listfiles(dir) {
    return buildremoteservice(function () {
        return listfiles(context.dir)
    },{dir:dir})
}

function createfile(filepath) {
    return buildremoteservice(function () {
        return createfile(context.filepath)
    },{filepath:filepath})
}

function velocitytemplate(templatestr, params) {
    return buildremoteservice(function () {
        return velocitytemplate(context.templatestr, context.params)
    },{templatestr:templatestr, params:params})
}

