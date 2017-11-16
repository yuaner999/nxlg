package com.jsweb.plugins;

import org.apache.commons.text.beta.similarity.JaccardSimilarity;

import java.util.Locale;

/**
 * Created by liuzg on 2017/2/21.
 */
public class TextPlugIn {

    // 参考 https://commons.apache.org/proper/commons-text/javadocs/api-release/
    // 下载 https://commons.apache.org/proper/commons-text/download_text.cgi

    // 帮我完成下面的函数 然后写几个例子试试
    // 这个是文本相似度测量的类库

    public double textJaccardSimilarity(String str1,String str2){
        JaccardSimilarity jaccardSimilarity = new JaccardSimilarity();
        return jaccardSimilarity.apply(str1,str2);
    }

    public String textLongestCommonSubsequence(String str1,String str2){
        return null;
    }

    public int textLongestCommonSubsequenceDistance(String str1,String str2){
        return 0;
    }

    public int textHammingDistance(String str1,String str2){
        return 0;
    }

    public double textFuzzyScore(String str1,String str2,Locale locale){
        return 0;
    }


    public static void main(String[] args){
        TextPlugIn textPlugIn = new TextPlugIn();
        System.out.println(textPlugIn.textJaccardSimilarity("anvbb", "abbbv"));
        System.out.println(textPlugIn.textJaccardSimilarity("anv", "abbbv"));
        System.out.println(textPlugIn.textJaccardSimilarity("assbb", "abbbv"));
    }

}
