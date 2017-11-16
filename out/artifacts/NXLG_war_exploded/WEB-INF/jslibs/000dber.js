//克隆对象
function cloneObj(o){
    var k, ret= o, b;
    if(o && ((b = (o instanceof Array)) || o instanceof Object)) {
        ret = b ? [] : {};
        for(k in o){
            if(o.hasOwnProperty(k)){
                ret[k] = cloneObj(o[k]);
            }
        }
    }
    return ret;
}
//替换全部
function replaceall(str,substr1,substr2){
    return str.split(substr1).join(substr2);
}
//唯一
function distinct(arr){
    if(arr.length==0) return [];
    var res = [arr[0]];
    for(var i = 1; i < arr.length; i++){
        var repeat = false;
        for(var j = 0; j < res.length; j++){
            if(arr[i] == res[j]){
                repeat = true;
                break;
            }
        }
        if(!repeat){
            res.push(arr[i]);
        }
    }
    return res;
}
//a.b => {model:'a',property:'b'}
function modelproperty(propertystr){
    var index = propertystr.indexOf(".");
    if(index>0){
        return {
            model:propertystr.substr(0,index),
            property:propertystr.substr(index+1)
        }
    }else{
        return null;
    }
}
//a,b,c,d:[e,f} => a  b  c  d:[e,f]
function splitpropertystr(structurestr){
    var result=[];
    var state = 0;
    var bindex = 0;
    for(var i=0;i<structurestr.length;i++){
        var c = structurestr[i];
        if(c=='['){
            state==1
        }else if(c==']'){
            state==0
        }else if(c==','){
            var t = structurestr.substring(bindex,i);
            result.push(t);
            bindex=i+1;
        }
    }
    var t = structurestr.substring(bindex,i);
    result.push(t);
    return result;
}

function findrelation(relations,entityname,propertyname){
    for(var i=0;i<relations.length;i++){
        var relation = relations[i];
        if(relation.entityname==entityname&&relation.propertyname==propertyname){
            return cloneObj(relation);
        }
    }
    return null;
}

//good[shop,creator] => good
function getpropertystrpropertyname(propertystr){
    var index = propertystr.indexOf('[');
    if(index>-1) {
        return propertystr.substr(0,index);
    }else{
        return propertystr;
    }
}

//good[shop,creator] => shop,creator
function getpropertystrsubproperties(propertystr){
    var index = propertystr.indexOf('[');
    if(index>-1) {
        return propertystr.substring(index+1,propertystr.length-1);
    }else{
        return "";
    }
}

function analysisrelation(instance,entityname,propertystr,relations){
    var entityrelations=[];
    var propertystrs = splitpropertystr(propertystr);
    for(var i=0;i<propertystrs.length;i++){
        var subpropertystr = propertystrs[i];
        var propertyname = getpropertystrpropertyname(subpropertystr);
        var contentstr = getpropertystrsubproperties(subpropertystr);

        var relation = findrelation(relations,entityname,propertyname);
        if(relation==null) throw "["+entityname+"."+propertyname+"]未定义实体关系"
        var targetentityname = relation.targetentityname;

        relation.instance = instance;
        entityrelations.push(relation);
        if(contentstr.length>0){
            var subentityrelations = analysisrelation(instance+"."+propertyname,targetentityname,contentstr,relations);
            for(var j=0;j<subentityrelations.length;j++){
                entityrelations.push(subentityrelations[j]);
            }
        }
    }
    return entityrelations;
}

function analysisstructurestr(structurestr,relations){
    var index= structurestr.indexOf('[');
    if(index==-1) return [];
    var entityname= structurestr.substr(0,index);
    var propertystr=structurestr.substring(index+1,structurestr.length-1);

    return analysisrelation("root",entityname,propertystr,relations);
}

//model.property=model.property => instance.property=instance.property
function modelconnectortoinstanceconnector(entityrelation){
    var connector = entityrelation.modelconnector;
    var def = modelconnectorobject(connector);

    var leftinstance = entityrelation.instance;
    var rightinstance= entityrelation.instance+"."+entityrelation.propertyname;

    var instanceconnector = instancenametotableinstancename(leftinstance)+"."+def.leftfield+"="+instancenametotableinstancename(rightinstance)+"."+def.rightfield;
    return instanceconnector;
}

//a.b.c => a_b_c
function instancenametotableinstancename(propertypath){
    return replaceall(propertypath,".","_");
}

function modelconnectorobject(modelconnector){
    var index = modelconnector.indexOf("=");
    var left = modelconnector.substr(0,index);
    var right= modelconnector.substr(index+1);
    index = left.indexOf(".");
    var leftmodel = left.substr(0,index);
    var leftfield = left.substr(index+1);
    index = right.indexOf(".");
    var rightmodel = right.substr(0,index);
    var rightfield = right.substr(index+1);
    return {
        leftmodel:leftmodel,
        leftfield:leftfield,
        rightmodel:rightmodel,
        rightfield:rightfield
    }
}

function generatemappingstr(curpath,mappingobj,relationmapping,aliasfields){
    var props = [];
    for(var p in mappingobj){
        props.push(p)
    }

    var result = "";

    for(var i=0;i<props.length;i++) {
        var prop = props[i];
        var subprops = [];
        for(var p in mappingobj[prop]){
            subprops.push(p)
        }
        if(subprops.length>0){
            var relation = relationmapping[curpath+"."+prop];
            if(relation=="1:n"){
                var substr = generatemappingstr(curpath+"."+prop,mappingobj[prop],relationmapping,aliasfields);
                result+=prop+":["+substr+"]";
            }else{
                var substr = generatemappingstr(curpath+"."+prop,mappingobj[prop],relationmapping,aliasfields);
                result+=prop+":("+substr+")";
            }

        }else{
            if((curpath+"."+prop) in aliasfields) {
                var aliasfield = aliasfields[curpath+"."+prop]
                result+= aliasfield.aliasname+"|"+prop
            }else{
                result+=prop;
            }
        }

        if(i<props.length-1) result+=","
    }


    return result;
}

function generatemappingobj(entityrelations,relationmapping){
    //生成mapping字符串
    var mappings = {}
    var allfields={}

    for(var i=0;i<entityrelations.length;i++){
        var entityrelation = entityrelations[i];
        mappings[entityrelation.instance]={};
        var entity = db.getentity(entityrelation.entityname);
        for(var j=0;j<entity.properties.length;j++){
            var field = entity.properties[j];
            if(!(field in allfields)) mappings[entityrelation.instance][field.fieldname]={};
//				allfields[field] = {};
        }

        mappings[entityrelation.instance+"."+entityrelation.propertyname]={};
        entity = db.getentity(entityrelation.targetentityname);
        for(var j=0;j<entity.properties.length;j++){
            var field = entity.properties[j];
            mappings[entityrelation.instance+"."+entityrelation.propertyname][field.fieldname]={};
        }
        relationmapping[entityrelation.instance+"."+entityrelation.propertyname]=entityrelation.relationtype;
    }

    var keys = []
    for(var key in mappings){
        if(key!="root") keys.push(key);
    }

    for(var i=0;i<keys.length;i++){
        var key = keys[i];
        var value = mappings[key];
        var path = key.split(".");
        var cur = mappings;
        for(var j=0;j<path.length;j++){
            if(j==path.length-1) cur[path[j]] = value;
            if(!(path[j] in cur)) cur[path[j]]=[];
            cur = cur[path[j]];
        }
    }

    return mappings["root"];
}

function findinstancenameindexinexpression(expression){
    var state = 0;
    var ignore = false;
    var scount = 0;//单引号数量
    var prevstate = 0;
    var varbeginindex = 0;
    var candidate=[];

    for(var i=0;i<expression.length;i++){
        var c = expression[i];
        if(c>='A'&&c<='Z'||c>='a'&&c<='z'||c=='_'){
            state=0
        }
        else if(c>='0'&&c<='9'){
            if(state==0) state=0
            else state=1
        }
        else if(c=='.'){
            if(state==0) state=0
            else state=2
        }
        else if(c=='{'){
            ignore=true;
        }
        else if(c=='}'){
            ignore=false;
            state=3
            prevstate=3;
        }
        else if(c=="'"){
            scount++;
            if(scount%2==1) ignore=true;
            else {ignore=false;state=3;prevstate=3;}
        }
        else{
            state=3
        }
        if(ignore) continue;
        if(prevstate!=0&&state==0){
            varbeginindex = i;
        }
        if(prevstate==0&&state!=0){
            candidate.push({begin:varbeginindex,end:i});
        }
        prevstate = state;
    }
    if(state==0){
        var instancename = expression.substring(varbeginindex,i);
        candidate.push({begin:varbeginindex,end:expression.length});
    }

    var instancenames=[]
    for(var i=0;i<candidate.length;i++) {
        var instancename = expression.substring(candidate[i].begin,candidate[i].end);
        if(instancename.indexOf(".")>=0) instancenames.push(candidate[i])
    }

    return instancenames
}


//root.goods.goodname=>root_goods.goodname
function instancenametowherevar(instancename){
    var arr = instancename.split('.');
    var r = "";
    for(var i=0;i<arr.length;i++){
        var item = arr[i];
        if(i==arr.length-1){
            r+=item;
        }else if(i==arr.length-2){
            r+=item+".";
        }else{
            r+=item+"_";
        }
    }
    return r;
}

//root.goods.goodname like concat('%',${var.xxx},'%')=> root_goods.goodname like concat('%',${var.xxx},'%')
function convertwhereexp(whereexp){
    var r = "";
    var indexlist = findinstancenameindexinexpression(whereexp);
    if(indexlist.length==0) return whereexp;

    var j=0;
    var replace = true;
    for(var i=0;i<whereexp.length;i++){
        var c = whereexp[i];
        if(i<indexlist[j].begin){
            r+=c;
        }else if(i>=indexlist[j].begin&&i<indexlist[j].end){
            if(replace){
                replace = false;
                r+=instancenametowherevar(whereexp.substring(indexlist[j].begin,indexlist[j].end))
            }
        }else{
            if(j<indexlist.length-1) j++

            r+=c;

            replace = true;
        }
    }
    return r;
}

var db = {
    entities:[],
    relations:[],
    entityconstraints:[],
    getentity:function(entityname){
        for(var i=0;i<this.entities.length;i++) {
            var entity = this.entities[i];
            if(entity.entityname==entityname) return entity;
        }
        return null;
    },
    getentitypk:function(entity){
        var pkfieldname = null;
        if(entity==null) return null;
        for(var i=0;i<entity.properties.length;i++){
            var property = entity.properties[i];
            if(property.PK){
                pkfieldname = property.fieldname;
            }
        }
        return pkfieldname;
    },
    getconstaint:function(entityname,fieldname){
        for(var i=0;i<this.entityconstraints.length;i++) {
            var constaint = this.entityconstraints[i];
            if(constaint.entityname==entityname&&constaint.fieldname==fieldname){
                return constaint;
            }
        }
        return null;
    },
    relation:function(modelpropertystr,modelconnectorstr,relationtype){
        var t= modelproperty(modelpropertystr);
        var connector = modelconnectorobject(modelconnectorstr);
        this.relations.push({
            entityname:t.model,
            propertyname:t.property,
            targetentityname:connector.rightmodel,
            relationtype:relationtype,
            modelconnector:modelconnectorstr
        });
        return this;
    },
    entity:function(entityname,properties){
        this.entities.push({entityname:entityname,properties:properties})
        return this;
    },
    constraint:function(entityname,fieldname,newfunc,updatefunc){
        var isstr1 = Object.prototype.toString.call(newfunc) === "[object String]"
        var isstr2 = Object.prototype.toString.call(updatefunc) === "[object String]"

        var newfunc1 = newfunc;
        var updatefunc1 = updatefunc;
        if(isstr1) newfunc1 = function () {return newfunc;}
        if(isstr2) updatefunc1 = function () {return updatefunc;}


        this.entityconstraints.push({
            entityname:entityname,
            fieldname:fieldname,
            newfunc:newfunc1,
            updatefunc:updatefunc1
        })
        return this;
    }
}

function initmysqldb(dbschema){
    db.entities = query(function () {/*
     SELECT TABLE_NAME,COLUMN_NAME,IS_NULLABLE,COLUMN_KEY='PRI' PK,COLUMN_TYPE,COLUMN_KEY,COLUMN_COMMENT FROM INFORMATION_SCHEMA.Columns WHERE table_schema=${dbschema}
     ORDER BY TABLE_NAME,ORDINAL_POSITION
     */},{dbschema:dbschema},"TABLE_NAME|entityname,properties:[COLUMN_NAME|fieldname,PK,IS_NULLABLE,COLUMN_TYPE,COLUMN_KEY,COLUMN_COMMENT]")
}

function dbcontext() {
    return {
        actions:[],
        plugins:{
            query:function(context,args){
                var entityrelations=analysisstructurestr(args.structurestr,db.relations);
                var result = "";
                var selectstr = "";
                var joinstr = "";
                context.entityrelations = entityrelations;

                var tableinstancenames = [];
                var instancenames = [];
                var instanceentitymap = {};

                for(var i=0;i<entityrelations.length;i++){
                    var entityrelation = entityrelations[i];
                    tableinstancenames.push(instancenametotableinstancename(entityrelation.instance));
                    tableinstancenames.push(instancenametotableinstancename(entityrelation.instance+"."+entityrelation.propertyname));
                    instancenames.push(entityrelation.instance);
                    instancenames.push(entityrelation.instance+"."+entityrelation.propertyname);
                    instanceentitymap[entityrelation.instance]=entityrelation.entityname;
                    instanceentitymap[entityrelation.instance+"."+entityrelation.propertyname]=entityrelation.targetentityname;
                    if(i==0){
                        joinstr = entityrelation.entityname+" "+entityrelation.instance+"\r\n";
                    }
                    var instanceconnector = modelconnectortoinstanceconnector(entityrelation);
                    joinstr += "left outer join "+entityrelation.targetentityname+" "+instancenametotableinstancename(entityrelation.instance+"."+entityrelation.propertyname) +" ON "+instanceconnector+"\r\n"
                }

                if(instancenames.length==0){
                    result+="SELECT * FROM "+args.structurestr+" root";
                    context.mappingstr = "";
                    return result;
                }

                instancenames = distinct(instancenames);
                tableinstancenames = distinct(tableinstancenames);

                var allfields = {}
                var aliasfields = {}

                for(var i=0;i<instancenames.length;i++) {
                    var instancename = instancenames[i];
                    var entityname = instanceentitymap[instancename];
                    var entity = db.getentity(entityname);
                    for(var j=0;j<entity.properties.length;j++){
                        var field = entity.properties[j];
                        var fieldname = field.fieldname;
                        if(field.fieldname in allfields){
                            fieldname = field.fieldname+allfields[field.fieldname];
                            allfields[field.fieldname]=allfields[field.fieldname]+1;
                        }else{
                            allfields[field.fieldname]=1
                        }
                        if(fieldname!=field.fieldname)
                            aliasfields[instancename+"."+field.fieldname]=({instancename:instancename, fieldname:field.fieldname, aliasname: fieldname})

                        selectstr+= instancenametotableinstancename(instancename)+"."+field.fieldname+" "+fieldname+",";
                    }
                }
                selectstr=selectstr.substr(0,selectstr.length-1);
                var relationmapping = {};
                var mappingobj = generatemappingobj(entityrelations,relationmapping);
                var mappingstr = generatemappingstr("root",mappingobj,relationmapping,aliasfields);
                context.mappingstr = mappingstr;

                result+="SELECT "+selectstr+" \r\nFROM ";
                result+=joinstr;
                return result;
            },
            filter:function(context,args){
                var sql = "";
                if(context.isnotfirstfilter){
                    sql+="AND "
                }else sql += "where \r\n"
                context.isnotfirstfilter = true;
                var filterstr = convertwhereexp(args.filterstr);

                sql += filterstr;
                return sql;
            },
            orderby:function(context,args){
                var sql = "";
                if(context.isnotfirstorderby){
                    sql+=","
                }else sql += "order by \r\n"
                var orderbystr = convertwhereexp(args.orderbystr);

                sql += orderbystr;
                return sql;
            }
        },
        query:function(structurestr){
            this.actions.push({actionname:'query',args:{structurestr:structurestr}})
            return this;
        },
        filter:function(filterstr){
            this.actions.push({actionname:'filter',args:{filterstr:filterstr}})
            return this;
        },
        search:function(varname,condition){
            var a1 = '${'+varname+'}'+" IS NULL";
            var a2 = '${'+varname+'}'+"=''";
            var a ='(('+a1+' OR '+a2+')'+ ' OR ('+convertwhereexp(condition)+'))';
            return this.filter(a);
        },
        orderby:function(orderbystr){
            this.actions.push({actionname:'orderby',args:{orderbystr:orderbystr}})
            return this;
        },
        buildsqlquery:function(){
            var actions = (this.actions);
            var context = {};
            var sql = "";
            for(var i=0;i<actions.length;i++){
                var action = actions[i];
                var actionname = action.actionname;
                var actionargs = action.args;
                var r = this.plugins[actionname](context,actionargs);
                sql += r+"\r\n";
            }

            var r = {sql:sql,mappingstr:context.mappingstr};
            return r;
        }
    }
}
