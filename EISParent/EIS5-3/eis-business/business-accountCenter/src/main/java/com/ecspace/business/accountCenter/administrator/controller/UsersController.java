package com.ecspace.business.accountCenter.administrator.controller;

import com.ecspace.business.accountCenter.administrator.service.UsersService;
import com.ecspace.business.accountCenter.administrator.entity.Users;

import com.ecspace.business.accountCenter.util.*;
import com.ecspace.business.resourceCenter.util.PageBean;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 账户中心
 */

@Controller
@RequestMapping("/users")
public class UsersController {

    @Autowired
    private UsersService usersService;

    @RequestMapping("/list")
    public void list(HttpServletRequest request, HttpServletResponse response){
        JSONObject resultObject = new JSONObject();

        String page = StringUtil.goOutSpace(request.getParameter("page"));
        String rows = StringUtil.goOutSpace(request.getParameter("rows"));
        String companyName= StringUtil.goOutSpace(request.getParameter("companyName"));


        if(page == null || rows == null ){
            resultObject.put("rows", "[]");
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        PageBean pageBean = new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
        Map<String, Object> map = new HashMap<String, Object>();
            map.put("startTemp", pageBean.getStartTemp());
            map.put("pageSize", pageBean.getPageSize());
            map.put("deleteMark","1");
            map.put("companyName",companyName);
        List<Users> list =  usersService.list(map);
        JSONArray jsonArray = new JSONArray();
        if(list != null){
            try {
                JsonConfig config = new JsonConfig();
                config.setIgnoreDefaultExcludes(false);
                config.registerJsonValueProcessor(Date.class,	new JsonDateValueProcessor());
                jsonArray = JSONArray.fromObject(list, config);
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        resultObject.put("rows", jsonArray);
        resultObject.put("total",usersService.listTotal(map));
        ResponseUtil.write(response,resultObject);
    }

    @RequestMapping("/save")
    public void save(Users users, HttpServletRequest request, HttpServletResponse response){
        users.settNO(StringUtil.goOutSpace(users.gettNO()));
        JSONObject result = new JSONObject();
        String code = ResultMessage.success;
        if (users.gettNO() == null) {
            //新增
            users.setUserId(StringUtil.goOutSpace(users.getUserId()));
            users.setUserName(StringUtil.goOutSpace(users.getUserName()));
            users.setUserPassword(StringUtil.goOutSpace(users.getUserPassword()));
            if (users.getUserId() == null || users.getUserName() == null) {
                //参数不合法
                result.put("code", ResultMessage.parameterNotValid);
                ResponseUtil.write(response, result);
                return;
            }
            Map<String, Object> map = new HashMap<>();
            map.put("userId", users.getUserId());
            map.put("deleteMark","1");
            List<Users> list = usersService.list(map);
            if (list != null) {
                //用户编号重复
                result.put("code", ResultMessage.dataRepetition);
                ResponseUtil.write(response, result);
                return;
            }
            if (users.getUserPassword() == null) {
                //初始密码赋值
                users.setUserPassword(ReadData.initPassword);
            }
            users.settNO(IdGenerator.generate());
            users.setInputDate(DateUtil.getDate());
            users.setInputUser(ReadData.administrator);
            users.setDeleteMark("1");

            if(!usersService.create(users)){
                code = ResultMessage.defeated;
            }

        }else{
            //编辑
            users.setUserId(null);
            users.setUserName(StringUtil.goOutSpace(users.getUserName()));
            users.setUserPassword(null);
            users.setEditUser(ReadData.administrator);
            users.setEditDate(DateUtil.getDate());
            if (!usersService.update(users)) {
                code = ResultMessage.defeated;
            }
        }

        result.put("code", code);
        ResponseUtil.write(response, result);

    }

    @RequestMapping("/delete")
    public void delete(HttpServletRequest request, HttpServletResponse response){
        String tNO = StringUtil.goOutSpace(request.getParameter("tNO"));
        System.out.println(tNO);
        JSONObject result = new JSONObject();

        JSONArray jsonArray ;
        try {
            if(tNO == null){
                throw new JSONException();
            }
            jsonArray = JSONArray.fromObject(tNO);
            if (jsonArray.size() == 0){
                throw  new JSONException();
            }
        }catch (JSONException e) {
            //参数不合法
            result.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response, result);
            return;
        }

        List<Users> list = new LinkedList<>();
        for (int i = 0; i < jsonArray.size(); i++) {
            Users users = new Users();
            users.settNO(jsonArray.getString(i));
            users.setDeleteMark("0");
            users.setInputUser(ReadData.administrator);
            users.setInputDate(DateUtil.getDate());
            list.add(users);
        }
        String code = ResultMessage.success;
        if (!usersService.update(list)) {
            code = ResultMessage.defeated;
        }
        result.put("code", code);
        ResponseUtil.write(response, result);

    }


}
