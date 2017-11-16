package com.common;

import java.io.*;

/**
 * FFile
 * Created by Administrator on 2015/12/16.
 */
public class DFile {
    private String filePath;
    private File file;

    public DFile(String filePath) {
        this.filePath = filePath;
        this.file = new File(filePath);

        checkAndCreateFile(this.file);
    }

    /**
     * 删除一文件
     *
     * @param filePath 文件路径
     * @return 结果
     */
    public static boolean unlink(String filePath) {
        File file = new File(filePath);
        return file.delete();
    }

    /**
     * 写入文件
     *
     * @param filePath 文件路径
     * @param string   文件内容
     * @return boolean
     */
    public static boolean write(String filePath, String string) {
        File file = new File(filePath);

        checkAndCreateFile(file);

        try {
            FileOutputStream output = new FileOutputStream(file);
            output.write(string.getBytes("utf8"));
            output.close();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * 检查并创建文件, 循环创建该文件所在的文件夹
     *
     * @param file 文件路径
     * @return 结果
     */
    public static boolean checkAndCreateFile(File file) {
        if (!file.exists()) {
            try {
                return file.getParentFile().mkdirs() && file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * 读取文件内容
     *
     * @param filePath 文件路径
     * @return 文件内容
     */
    public static String read(String filePath) {
        File file = new File(filePath);

        String stringReturn = "";

        InputStreamReader read = null;//考虑到编码格式
        try {
            read = new InputStreamReader(new FileInputStream(file), "utf8");
            BufferedReader bufferedReader = new BufferedReader(read);
            String lineTxt = null;
            while ((lineTxt = bufferedReader.readLine()) != null) {
                stringReturn += lineTxt;
            }

            return stringReturn;
        } catch (IOException e) {
            e.printStackTrace();
        }

        return stringReturn;
    }

    public void append(String string) {
        FileOutputStream out;
        try {
            out = new FileOutputStream(file, true);
            out.write(string.getBytes("utf-8"));
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public long getLength(){
        if (file.exists() && file.isFile()) {
            return file.length();
        } else {
            return 0;
        }
    }

    public boolean rename(String new_file){

        File newFile = new File(new_file);
        if (file.renameTo(newFile))
        {
            return true;
        }
        else
        {
            return  false;
        }
    }
}
