
function readxmldef(xmlstr) {
    var def = xml.readXmlDef(xmlstr);
    builddeffunctions(def);
    return def;
}

function xmlelemdef(xmlelem) {
    return xml.xmlElemDef(xmlstr);
}

function readxmlstring(xmlstr){
    return xml.readXmlString(xmlstr);
}

function builddeffunctions(elemdef) {
    elemdef.attr = function () {
        if(arguments.length==1){
            var name = arguments[0];
            for(var i=0;i<elemdef.attrs.length;i++){
                var attr = elemdef.attrs[i];
                if(attr.name==name){
                    return attr.value;
                }
            }
        }else if(arguments.length==2){
            var name = arguments[0];
            var value = arguments[1];
            if(value==null) value="";
            else value=value.toString();
            var find = false;
            for(var i=0;i<elemdef.attrs.length;i++){
                var attr = elemdef.attrs[i];
                if(attr.name==name){
                    attr.value = value;
                    find = true;
                    break;
                }
            }
            if(!find){
                elemdef.attrs.push({ns:"",nsp:"",name:name,value:value})
            }
        }
    };
    elemdef.addsubelem = function (subelemdef) {
        subelemdef = builddeffunctions(subelemdef);
        elemdef.elems.push(subelemdef);
        return subelemdef;
    };
    elemdef.insertsubelem = function (subelemdef,index) {
        subelemdef = builddeffunctions(subelemdef);
        elemdef.splice(index,0,[subelemdef]);
        return subelemdef;
    };
    for(var i=0;i<elemdef.elems.length;i++){
        var subelemdef = elemdef.elems[i];
        builddeffunctions(subelemdef);
    }
}