package com.jsweb.plugins;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuzg on 2017/2/21.
 */
public class XmlPlugIn {

    public Map<String,Object> xmlElemDef(Element element){
        Map<String,Object> elemdef = new HashMap<>();

        String name = element.getName();
        String nsp = element.getNamespacePrefix();
        String ns = element.getNamespace().getText();

        elemdef.put("name",name);
        elemdef.put("nsp",nsp);
        elemdef.put("ns",ns);

        List<Object> attrs = new ArrayList<>();
        for (Object attributeObj:element.attributes()){
            Attribute attribute = (Attribute) attributeObj;
            String ansp = attribute.getNamespacePrefix();
            String ans = attribute.getNamespace().getText();
            String aname = attribute.getName();
            String avalue =attribute.getValue();

            Map<String,Object> attrdef = new HashMap<>();
            attrdef.put("nsp",ansp);
            attrdef.put("ns",ans);
            attrdef.put("name",aname);
            attrdef.put("value",avalue);

            attrs.add(attrdef);
        }

        int subelemscount = 0;
        List<Object> elems = new ArrayList<>();
        for(Object subelemobj:element.elements()){
            if(!(subelemobj instanceof Element)) continue;
            subelemscount++;
            Element subelem = (Element) subelemobj;
            Map<String, Object> subdef = xmlElemDef(subelem);
            elems.add(subdef);
        }
        if(subelemscount==0){
            String contenttext = element.getText();
            elemdef.put("contenttext",contenttext);
        }

        elemdef.put("attrs",attrs);
        elemdef.put("elems",elems);

        return elemdef;
    }

    public Map<String,Object> readXmlDef(String xml){
        Element root = readXmlString(xml);
        return xmlElemDef(root);
    }

    /**
     * 将输入的xml字符串变成Element
     * @param xmlstring
     * @return
     */
    public Element readXmlString(String xmlstring){
        try{
            SAXReader saxReader = new SAXReader();
            Document doc = saxReader.read(new StringReader(xmlstring));
            return doc.getRootElement();
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }




}
