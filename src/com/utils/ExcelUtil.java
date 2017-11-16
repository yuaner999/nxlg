package com.utils;

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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * 处理excel文件中的数据的工具
 * @author hong
 * Created by admin on 2016/9/8.
 */
public class ExcelUtil {
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
//                System.out.println("上传文件检查文件完成");
            }
        }
        return item;
    }

    /**
     * 创建excel文档，
     * @param list 数据
     * @param keys list中map的key数组集合
     * @param columnNames excel的列名
     * */
    public static Workbook createWorkBook(List<Map<String ,Object>> list, String []keys, String columnNames[], String bookTitle) {
        // 创建excel工作簿
        Workbook wb = new HSSFWorkbook();

        // 创建两种单元格格式
        CellStyle cs = wb.createCellStyle();
        CellStyle cs2 = wb.createCellStyle();
        CellStyle title=wb.createCellStyle();
        // 创建两种字体
        Font f_t=wb.createFont();
        Font f = wb.createFont();
        Font f2 = wb.createFont();
        //标题的字体
        f_t.setFontHeightInPoints((short)24);
        f_t.setBold(true);
        f.setColor(IndexedColors.BLACK.getIndex());
        title.setFont(f_t);
        title.setBorderLeft(CellStyle.BORDER_THIN);
        title.setBorderRight(CellStyle.BORDER_THIN);
        title.setBorderTop(CellStyle.BORDER_THIN);
        title.setBorderBottom(CellStyle.BORDER_THIN);
        title.setAlignment(CellStyle.ALIGN_CENTER);
        // 创建第一种字体样式（用于列名）
        f.setFontHeightInPoints((short) 10);
        f.setColor(IndexedColors.BLACK.getIndex());
        f.setBoldweight(Font.BOLDWEIGHT_BOLD);
        // 创建第二种字体样式（用于值）
        f2.setFontHeightInPoints((short) 10);
        f2.setColor(IndexedColors.BLACK.getIndex());
        // 设置第一种单元格的样式（用于列名）
        cs.setFont(f);
        cs.setBorderLeft(CellStyle.BORDER_THIN);
        cs.setBorderRight(CellStyle.BORDER_THIN);
        cs.setBorderTop(CellStyle.BORDER_THIN);
        cs.setBorderBottom(CellStyle.BORDER_THIN);
        cs.setAlignment(CellStyle.ALIGN_CENTER);
        // 设置第二种单元格的样式（用于值）
        cs2.setFont(f2);
        cs2.setBorderLeft(CellStyle.BORDER_THIN);
        cs2.setBorderRight(CellStyle.BORDER_THIN);
        cs2.setBorderTop(CellStyle.BORDER_THIN);
        cs2.setBorderBottom(CellStyle.BORDER_THIN);
        cs2.setAlignment(CellStyle.ALIGN_CENTER);
        // 创建第一个sheet（页），并命名
        Sheet sheet = wb.createSheet("sheet1");
        //合并单元格
        sheet.addMergedRegion(new CellRangeAddress(0,0,0,keys.length-1));
        // 创建第一行  标题
        Row row = sheet.createRow((short) 0);
        Cell cel=row.createCell(0);
        cel.setCellValue(bookTitle);
        cel.setCellStyle(title);

        row = sheet.createRow((short) 1);

        //设置列名
        for(int i=0;i<columnNames.length;i++){
            Cell cell = row.createCell(i);
            cell.setCellValue(columnNames[i]);
            cell.setCellStyle(cs);
            sheet.autoSizeColumn(i);
        }
//        List<Map<String ,Object>> list=parseList(objlist);
        //设置每行每列的值
        int i=2;
        for(Map<String ,Object> map:list){
            // Row 行,Cell 方格 , Row 和 Cell 都是从0开始计数的
            // 创建一行，在页sheet上
            Row row1 = sheet.createRow((short) i);
            // 在row行上创建一个方格
            for(short j=0;j<keys.length;j++){
                Cell cell = row1.createCell(j);
                String str=map.get(keys[j]) == null?" ": map.get(keys[j]).toString();
                cell.setCellValue(str);
                cell.setCellStyle(cs2);
                int width=sheet.getColumnWidth(j);
                if(width < 265*str.length())  sheet.autoSizeColumn(j);
//                System.out.print(map.get(keys[j])+"\t| ");
            }
//            System.out.println();
            i++;
        }
        return wb;
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
