package com.utils;

import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.collections.map.LinkedMap;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 处理excel文件中的数据的工具
 * @author hong
 * Created by admin on 2016/9/8.
 */
public class ExcelUtils {
    /**
     * 根据单元格不同属性返回字符串数据
     * @param cell
     * @return
     */
    public static String getCellStringValue(HSSFCell cell) {
        String cellValue = "";
        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_STRING://字符串类型
                cellValue = cell.getStringCellValue();
                if(cellValue.trim().equals("")||cellValue.trim().length()<=0)
                    cellValue="";
                break;
            case HSSFCell.CELL_TYPE_NUMERIC: //数值类型
                if(HSSFDateUtil.isCellDateFormatted(cell)){     //如果是日期
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
                    cellValue=sdf.format(cell.getDateCellValue());
                }else{
                    cellValue = String.valueOf(cell.getNumericCellValue());
                }
                break;
            case HSSFCell.CELL_TYPE_FORMULA: //公式
                cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                cellValue = String.valueOf(cell.getNumericCellValue());
                break;
            case HSSFCell.CELL_TYPE_BLANK:
                cellValue="";
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                break;
            case HSSFCell.CELL_TYPE_ERROR:
                break;
            default:
                break;
        }
        return cellValue;
    }

    /**
     * 从request中加载文件
     * @param request
     * @return
     */
    public static FileItem getFileFromRequest(HttpServletRequest request, String fileType) throws FileUploadException {
        //检查是否上传了文件
        if (!ServletFileUpload.isMultipartContent(request)) {
            throw new RuntimeException("请选择文件");
        }
        //获取文件
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = null;
        items = upload.parseRequest(request);
        Iterator itr = items.iterator();
        FileItem item=null;
        if(itr.hasNext()) {
            item = (FileItem) itr.next();
            String fileName = item.getName();
            if (!item.isFormField()) {
                // 检查扩展名
                String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                if (!fileType.contains(fileExt)) {
                    throw new RuntimeException("上传文件格式不正确");
                }
                System.out.println("上传文件检查文件完成");
            }
        }
        return item;
    }

    /**
     * 创建excel文档，
     * 目前只支持一层子级
     * @param list 数据
     * @param keys list中map的key数组集合
     *  结构类似 "shopid=字段1,shopname=字段2,shopclosetime=字段3,shopdiscountpolicies:[policyid=字段6,money=字段7,discount=字段8,monday=字段9]"
     * */
    public static Workbook createWorkBook(List<Map<String ,Object>> list, String keys, String bookTitle) {
        LinkedMap keyMap=cutKeys(keys); //提取key
        // 创建excel工作簿
        Workbook wb = new HSSFWorkbook();
        // 创建单元格格式
        CellStyle title=wb.createCellStyle();
        // 创建字体
        Font f_t=wb.createFont();
        //标题的字体
        f_t.setFontHeightInPoints((short)24);
        f_t.setBold(false);
        title.setFont(f_t);
        title.setBorderLeft(CellStyle.BORDER_THIN);
        title.setBorderRight(CellStyle.BORDER_THIN);
        title.setBorderTop(CellStyle.BORDER_THIN);
        title.setBorderBottom(CellStyle.BORDER_THIN);
        title.setAlignment(CellStyle.ALIGN_CENTER);
        // 设置第一种单元格的样式（用于列名）
        // 创建第一个sheet（页），并命名
        Sheet sheet = wb.createSheet(bookTitle);
        List<String > columnNames=getColumNames(keyMap);    //获取列的中文名
        //合并单元格
        sheet.addMergedRegion(new CellRangeAddress(0,0,0,columnNames.size()-1));
        // 创建第一行  标题
        Row row = sheet.createRow((short) 0);
        Cell cel=row.createCell(0);
        cel.setCellValue(bookTitle);
        cel.setCellStyle(title);
        row = sheet.createRow((short) 1);
        //设置列名
        for(int i=0;i<columnNames.size();i++){
            Cell cell = row.createCell(i);
            cell.setCellValue(columnNames.get(i));
            sheet.autoSizeColumn(i);
        }
//        //设置每行每列的值
        int i=2;
        Row row1 = sheet.createRow(i);
        createRowData(keyMap,list,sheet,row1,0);
        Map<Integer,String> colsWidth=new HashedMap();
        for(i=1;i<=sheet.getLastRowNum();i++){
            row=sheet.getRow(i);
            for(int j=0;j<=row.getLastCellNum();j++){
                cel=row.getCell(j);
                if(cel!=null){
                    String str=cel.getStringCellValue();
                    int width=sheet.getColumnWidth(j);
                    if(width < 512*str.length())
                        sheet.setColumnWidth(j,650*str.length());
//                        sheet.autoSizeColumn(j);
                }
            }
        }
        return wb;
    }

    /**
     * 生成表格
     * @param key      数据Map 中的key 的名字
     * @param subList  数据的集合
     * @param sheet    表格的sheet元素
     * @param row       表格的行元素
     * @param col        表格的列的下标
     * @return         返回值为int[] ,其中int[0]为生成的数据的行数，int[1]为当前最后一列的下标
     */
    private static int[] createRowData(LinkedMap key, List<Map<String ,Object>> subList, Sheet sheet, Row row, int col){
        int i=row.getRowNum();//合并单元格的起始行号
        int subRows=0;
        for(Map<String ,Object> rowData:subList){
            int j=col;           //第二层循环次数
            Set keySet=key.keySet();
            int mergedRegionStart=col;
            for(Object o:keySet){
                Object dataKey=key.get(o);
                if(dataKey instanceof String){
                    Cell cell = row.createCell(j);
                    String value= rowData.get(o)==null?"": rowData.get(o).toString();
                    cell.setCellValue(value);
                    j++;
                }else if(dataKey instanceof LinkedMap) {
                    List<Map<String ,Object>> child= (List<Map<String, Object>>) rowData.get(o);
                    int[] result=createSubRowData((LinkedMap) dataKey,child,sheet,row,j);
                    int rowEnd=i+result[0];
                    subRows=result[0];
                    if(j>col){
                        for(int t=j-1;t>=col;t--){
                            sheet.addMergedRegion(new CellRangeAddress(i,rowEnd,t,t));
                        }
                        mergedRegionStart=j=result[1];
                    }
                }
            }
            if(j>mergedRegionStart){
                for(int t=j-1;t>=mergedRegionStart;t--){
                    sheet.addMergedRegion(new CellRangeAddress(i,i+subRows,t,t));
                }
            }
            i++;
            i+=subRows;
            row=sheet.createRow(i);
        }
        int[] re=new int[2];
        re[0]=row.getRowNum();
        re[1]=row.getLastCellNum();
        return re;
    }

    /**
     * 生成子级元素的单元格
     *  @param key      数据Map 中的key 的名字
     * @param subList  数据的集合
     * @param sheet    表格的sheet元素
     * @param row       表格的行元素
     * @param col        表格的列的下标
     * @return         返回值为int[] ,其中int[0]为生成的数据的行数，int[1]为当前最后一列的下标
     */
    private static int[] createSubRowData(LinkedMap key, List<Map<String ,Object>> subList, Sheet sheet, Row row, int col){
        int i=0,
                startRow=row.getRowNum();//合并单元格的起始行号
        for(Map<String ,Object> rowData:subList){
            int j=col;           //第二层循环次数
            if(i>0) row=sheet.createRow(startRow+i); //第一次的执行该方法不添加新的row
            Set keySet=key.keySet();
            for(Object o:keySet){
                Object dataKey=key.get(o);
                if(dataKey instanceof String){
                    Cell cell = row.createCell(j);
                    String value= rowData.get(o)==null?"": rowData.get(o).toString();
                    cell.setCellValue(value);
                    j++;
                }else if(dataKey instanceof LinkedMap) {
                    continue;
                }
            }
            i++;
        }
        int[] re=new int[2];
        re[0]=i-1;
        re[1]=row.getLastCellNum();
        return re;
    }

    /**
     * 获取表格的字段名字
     * @param map
     * @return
     */
    private static List<String > getColumNames(LinkedMap map){
        List<String> list=new ArrayList<>();
        if(map==null || map.size()==0) return list;
        for(Object o:map.keySet()){
            Object value=map.get(o);
            if(value instanceof LinkedMap){
                List<String> temp=getColumNames((LinkedMap) value);
                list.addAll(temp);
            }else if(value instanceof String){
                list.add((String) value);
            }
        }
        return list;
    }
    /**
     * 获取key 及 表格的字段名称
     * @param key 拼接好的key=字段名字
     *            结构类似 "shopid=字段1,shopname=字段2,shopclosetime=字段3,shopdiscountpolicies:[policyid=字段6,money=字段7,discount=字段8,monday=字段9,shopdiscoun:[poli=字段10,mon=字段11]]"
     * @return 截取完的key列表、以及对应的字段名字列表
     */
    private static LinkedMap cutKeys(String key){
        LinkedMap keys=new LinkedMap();
        int indexStart=0;
        do{
            int indexEnd=key.indexOf(",",indexStart);
            if(indexEnd==-1) indexEnd=key.length();
            String tempKey=key.substring(indexStart,indexEnd);
            if(tempKey.contains("[")){
                indexEnd=key.lastIndexOf(']')+1;
                tempKey=key.substring(indexStart,indexEnd);
                if(tempKey.contains(":")){
                    int index=tempKey.indexOf(":");
                    keys.put(tempKey.substring(0,index),cutKeys(tempKey.substring(index+2,tempKey.length()-1)));
                }
            }else{
                String[] t=tempKey.split("[=]");
                if(t.length==2){
                    keys.put(t[0].trim(),t[1].trim());
                }
            }
            indexStart=indexEnd+1;
        }while (indexStart<key.length());
        return keys;
    }

    /**
     * 把list转换成map的list
     * @param list
     * @return
     */
    public static List<Map<String ,Object>> parseList(List list){
        List<Map<String ,Object>> mapList=new ArrayList<>();
        for(Object t:list){
            mapList.add(Utils.ObjToMap(t));
        }
        return mapList;
    }

    /**
     * 将生成的excel发送给客户端
     * @param response
     * @param os
     * @param fileName
     */
    public static void  sendExcel(HttpServletResponse response , ByteArrayOutputStream os, String fileName){
        byte[] content = os.toByteArray();
        InputStream is = new ByteArrayInputStream(content);
        // 设置response参数，可以打开下载页面
        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        try {
            response.reset();
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setHeader("Content-Disposition", "attachment;filename="+ new String((fileName + ".xls").getBytes(), "iso-8859-1"));
            ServletOutputStream out = response.getOutputStream();
            bis = new BufferedInputStream(is);
            bos = new BufferedOutputStream(out);
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (final IOException e) {
            e.printStackTrace();
        } finally {
            if (bis != null)
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            if (bos != null)
                try {
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
    }
}
