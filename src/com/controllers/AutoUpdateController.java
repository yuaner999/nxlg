/*
*Created by liulei on 2016/4/25.
*/
package com.controllers;

import com.common.D;
import com.common.DFunction;
import com.common.DLog;
import com.common.DTable;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created by liulei on 2016/4/25.
 */
@Controller
@RequestMapping(value = "/AutoUpdate")
public class AutoUpdateController {
    @RequestMapping(value = "/getVersion", method = RequestMethod.GET)
    @ResponseBody
    public JSONObject GetVersion(HttpServletRequest request) {
        JSONObject jsonObject = JSONObject.fromObject("{'version':1})");
        return jsonObject;
    }
}
