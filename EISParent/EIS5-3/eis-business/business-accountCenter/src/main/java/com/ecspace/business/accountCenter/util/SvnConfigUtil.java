package com.ecspace.business.accountCenter.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * svn配置工具类
 * @Author lv
 */
public class SvnConfigUtil {
    //svn权限配置表
    private static final String svnUserPath = "/htpasswd";
    private static final String svnPowerPath = "/authz";
    private static final String charsetName = "UTF-8";
    //默认密码
    private static String userPassword = "$apr1$fd1$.3iRqI1eQWZThypQOYI3l1";

    //默认字段
    public static final String title = "title";
    public static final String child = "child";
    public static final String name = "name";
    public static final String power = "power";

    public static final String RW = "RW";
    public static final String R = "R";
    public static final String P = "P";


    //换行符
    public static final String newline = System.getProperty("line.separator");

    //分隔符 /
//  public static final String fileSeparate = System.getProperty("file.separator");
    public static final String fileSeparate = "/";




    /**
     * svn添加用户
     * @param repositoriesPath svn版本库地址 E:/Repositories
     * @param addUsers 需要添加的用户[root]
     * @return
     */
    public static boolean saveSVNUser(String repositoriesPath, List<String> addUsers){
        if(addUsers == null || addUsers.size() == 0){
            return true;
        }

        //查询svn所有用户
        List<String> list = queryUserSVN(repositoriesPath);
        if(list == null){
            list = new ArrayList<>();
        }
        for(String user:addUsers){
            user +=":"+userPassword;
            list.add(user);
        }
        //保存所有用户
        return saveUserSVN(repositoriesPath,list);
    }

    /**
     * svn删除用户
     * @param repositoriesPath svn版本库地址 E:/Repositories
     * @param deletetUsers 需要删除的用户[root]
     * @return
     */
    public static boolean deleteSVNUser(String repositoriesPath, List<String> deletetUsers){
        if(repositoriesPath == null || "".equals(repositoriesPath) || deletetUsers == null || deletetUsers.size() == 0){
            return true;
        }
        //查询所有用户
        List<String> list = queryUserSVN(repositoriesPath);
        if(list == null){
            return true;
        }
        for(String userName:deletetUsers){
            for(int u= list.size()-1;u >=0;u--){
                String user = list.get(u);
                if(user != null && !"".equals(user)) {
                    String names = user.split(":")[0];
                    if(userName.equals(names)){
                        list.remove(u);
                    }
                }
            }
        }
        return saveUserSVN(repositoriesPath,list);
    }

    /**
     * 读取svn用户配置文件中的数据
     * @param repositoriesPath E:/Repositories
     * @return [root:$apr1$fd1$.3iRqI1eQWZThypQOYI3l1]
     */
    public static List<String> queryUserSVN(String repositoriesPath){

        //文件读取地址
        File oldfile = new File(repositoriesPath+svnUserPath);
        if(!oldfile.exists()){
            return null;
        }
        FileReader fileReader = null;
        BufferedReader bufferedReader = null;
        List<String> list = new ArrayList<>();
        try {
            fileReader = new FileReader(oldfile);
            String line;
            bufferedReader = new BufferedReader(fileReader);
            while ((line = bufferedReader.readLine()) != null){
                list.add(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(bufferedReader != null){
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(fileReader != null){
                try {
                    fileReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return list != null && list.size() > 0 ? list : null;
    }

    /**
     * 读取svn的用户名
     * @param list [root:$apr1$fd1$.3iRqI1eQWZThypQOYI3l1]
     * @return [root]
     */
    public static List<String> queryUserSVNName(List<String> list){
        if(list == null || list.size() == 0){
            return null;
        }
        List<String> list1 = new ArrayList<>();
        for(String listName : list){
            if(listName != null){
                String[] names = listName.split(":");
                list1.add(names[0]);
            }
        }
        return list1;
    }

    /**
     * 写入svn用户配置
     * @param list [root:$apr1$fd1$.3iRqI1eQWZThypQOYI3l1]
     * @return
     */
    public static boolean saveUserSVN(String repositoriesPath, List<String> list){

        //文件读取地址
        File file = new File(repositoriesPath + svnUserPath);
        if(!file.exists()){
            file.mkdirs();
        }
        if(list == null || list.size() == 0 ){
            return true;
        }

        FileWriter fileWriter = null;
        BufferedWriter bufferedWriter = null;
        try {
            fileWriter = new FileWriter(file);
            bufferedWriter = new BufferedWriter(fileWriter);
            for(String users : list){
                bufferedWriter.write(users.toCharArray());
                bufferedWriter.write(SvnConfigUtil.newline);//换行符
            }
            bufferedWriter.flush();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(bufferedWriter != null){
                try {
                    bufferedWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(fileWriter != null){
                try {
                    fileWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return false;
    }

    /**
     * 读取svn配置文件信息
     *
     * @param repositoriesPath E:/Repositories
     * @return {"title":"[/]","child":"1903121443285768940=rw,root=rw,"}
     */
    public static JSONArray querySVNPowerAll(String repositoriesPath){
        //文件读取地址
        File oldfile = new File(repositoriesPath+svnPowerPath);
        if(!oldfile.exists()){
            return null;
        }
        FileInputStream fileInputStream = null;
        InputStreamReader inputStreamReader = null;
        BufferedReader bufferedReader = null;
        StringBuilder json = new StringBuilder("[");

        try {

            fileInputStream = new FileInputStream(oldfile);
            inputStreamReader = new InputStreamReader(fileInputStream,charsetName);
            String line;
            bufferedReader = new BufferedReader(inputStreamReader);

            boolean flag = false;
            while ((line = bufferedReader.readLine()) != null){
                if(line.contains("[") || line.contains("]")){
                    if(flag){
                        json.append("'},");
                    }
                    flag = true;
//                    json.append("{'"+SvnConfigUtil.title+"':'"+line+"','"+SvnConfigUtil.child+"':'");
                    json.append("{'");
                    json.append(SvnConfigUtil.title);
                    json.append("':'");
                    json.append(line);
                    json.append("','");
                    json.append(SvnConfigUtil.child);
                    json.append("':'");
                }else{
                    //去掉空格
                    if(!line.equals("")){
                        //判断是否到达最后一行
                        json.append(line);
                        json.append(",");
                    }
                }
            }
            json.append("'}]");

        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(bufferedReader != null){
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(inputStreamReader != null){
                try {
                    inputStreamReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(fileInputStream != null){
                try {
                    fileInputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        JSONArray jsonArray = new JSONArray();
        try {
            jsonArray = JSONArray.fromObject(json.toString());
        }catch (Exception e){
            System.out.println("json数据转换异常"+json.toString());
            e.printStackTrace();
        }
        return jsonArray;
    }


    /**
     * 查询指定版本库下用户权限
     * @param repositoriesPath 版本仓库地址 E:/Repositories
     * @param repository 版本库 pdm_zongti 如不传则查询根目录
     * @param catalog 目录 /zxc-1
     * @return [{name=1903121443285768940, power=rw}, {name=root, power=rw}]
     */
    public static List<Map<String, Object>> querySVNPower(String repositoriesPath, String repository, String catalog){
        JSONArray jsonArray = querySVNPowerAll(repositoriesPath);

        if(jsonArray == null){
           return null;
        }

       List<Map<String,Object>> list = new ArrayList<>();

        catalog = catalog != null ? catalog : "";
        for(int i =0;i<jsonArray.size();i++){
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
            //获取标题
            String title = jsonObject.get(SvnConfigUtil.title).toString();
            if(title == null || "".equals(title)){
                continue;
            }
            boolean flag = false;
            //判断传入版本库是否为空
            if(repository != null && !"".equals(repository)){
                //不是空,比较版本库
                StringBuffer rep = new StringBuffer("[");
                rep.append(repository);
                if(catalog.indexOf("/") == -1){
                    //意味着传入为""
                    rep.append(":/");
                }else{
                    rep.append(":");
                }
                rep.append(catalog);
                rep.append("]");
                //比较是否相同
                if(rep.toString().equals(title)){
                    //相同,获取用户权限
                    flag = true;
                }

            }else{
                //是空，查询根目录
                String rootdir = "[/]";
                //比较是否相同
                if(rootdir.equals(title)){
                    //相同,获取用户权限
                    flag = true;
                }
            }

            if(flag){
                //获取用户权限
                String child = jsonObject.get(SvnConfigUtil.child).toString();
                if(child == null || "".equals(child)){
                    continue;
                }
                String[] childs = child.split(",");

                for(String c : childs){
                    Map<String,Object> map = new HashMap<>();
                    if(c == null || "".equals(c)){
                        continue;
                    }
                    String[] cs = c.split("=");

                    if(cs.length > 1){
                        map.put(SvnConfigUtil.name,cs[0]);
                        map.put(SvnConfigUtil.power,cs[1]);
                        list.add(map);
                    }
                }

                break;
            }
        }
       return list;
    }

    /**
     * 添加用户权限
     * @param repositoriesPath 版本仓库地址 E:/Repositories
     * @param repository 版本库 pdm_zongti 如不传则保存在根目录
     * @param catalog 目录 zxc-1 可为空; 添加目录及其子节点下的用户权限
     * @param list 不可为空 [{name=1903121443285768940, power=rw}, {name=root, power=rw}]
     * @return
     */
    public static boolean saveSVNPower(String repositoriesPath, String repository, String catalog, List<Map<String, Object>> list){
        /**
         * 1、查询svn配置文件中所有目录权限；
         * 2、遍历所有权限，判断是否有当前版本库和目录权限的数据
         * 3、有数据，是更新；
         * 3.1、遍历拥有目录权限，比较用户对当前目录的权限
         * 3.2、
         * 4、没有数据，则需要新建；
         * 4.1、新建版本库
         */


        if(list == null || list.size() == 0){
            return false;
        }
        List<Map<String, Object>> userList = new ArrayList<>(list);


        //查询svn配置中的目录用户权限 [{"title":"[/]","child":"1903121443285768940=rw,root=rw,"}]
        JSONArray jsonArray = querySVNPowerAll(repositoriesPath);
        if(jsonArray == null){
            return false;
        }

        repository = repository != null ? repository : "";
        catalog = catalog != null ? catalog.startsWith("/") ? catalog : "/"+catalog : "";
        //拼接比较版本库[text:/t1]
        String rep = splitRepository(repository, catalog);
        //[text:/t1
        String repositoryca1 = rep.substring(0,rep.length()-1);
        boolean newFlag = true;
        for(int i =0;i<jsonArray.size();i++) {
            //目录用户权限对象 {"title":"[/]","child":"1903121443285768940=rw,root=rw,"}
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);

            //获取标题
            String title = jsonObject.get(SvnConfigUtil.title).toString();
            if(title == null || "".equals(title)){
                continue;
            }

            //标题和原始数据进行比较，如果有则赋值
            if(title.equals(rep)){
                newFlag = false;
            }

            if(!title.contains(repositoryca1)){
                //目录没有用户权限
                continue;
            }
            //目录已有用户权限


            for(Map<String,Object> map : userList){
                boolean saveFlag = true;
                String userName = map.get(SvnConfigUtil.name).toString();
                StringBuilder stringBuilder = new StringBuilder();

                //获取标题
                String child = jsonObject.get(SvnConfigUtil.child).toString();
                if(child == null || "".equals(child)){
                    break;
                }
                //用户已经拥有的权限
                String[] childs = child.split(",");

                for(String child1 :childs){
                    if(child1 == null || "".equals(child1)){
                        continue;
                    }

                    String[] cs = child1.split("=");
                    if(!userName.equals(cs[0])){
                        if(!"".equals(stringBuilder.toString())){
                            if(!stringBuilder.toString().endsWith(",")){
                                stringBuilder.append(",");
                            }
                        }
                        stringBuilder.append(child1);
                        continue;
                    }
                    saveFlag = false;
                    //目录下有用户的权限
                    StringBuilder newUserPowers = new StringBuilder();
//                    System.out.println("有用户权限:"+child1);
                    newUserPowers.append(userName);
                    newUserPowers.append("=");
                    newUserPowers.append(changePower(map.get(SvnConfigUtil.power).toString()));
                    if(!"".equals(stringBuilder.toString())){
                        if(!stringBuilder.toString().endsWith(",")){
                            stringBuilder.append(",");
                        }
                    }

                    stringBuilder.append(newUserPowers.toString());
                }
                if(saveFlag){
//                    System.out.println("需要增加:"+map);
                    //目录下没有用户的权限，需要增加
                    if(!"".equals(stringBuilder.toString())){
                        if(!stringBuilder.toString().endsWith(",")){
                            stringBuilder.append(",");
                        }
                    }
                    stringBuilder.append(userName);
                    stringBuilder.append("=");
                    stringBuilder.append(changePower(map.get(SvnConfigUtil.power).toString()));
                }
               jsonObject.put(SvnConfigUtil.child,stringBuilder.toString());


            }

        }

        if(newFlag){
            //需增加目录及其用户权限  {"title":"[pdm_mysql:/text5]","child":"aaa=rw"}
            if(userList.size() > 0){
                //拼接版本库名称 [pdm_mysql:/text5]
                JSONObject jsonObject = new JSONObject();
                jsonObject.put(SvnConfigUtil.title,rep);
                StringBuilder child = new StringBuilder();
                for(int u = 0;u<userList.size();u++){
                    Map<String, Object> map = userList.get(u);
                    if(map == null){
                        continue;
                    }
                    String name = map.get(SvnConfigUtil.name).toString();
                    if(name == null || "".equals(name)){
                        continue;
                    }
                    String power = map.get(SvnConfigUtil.power).toString();
                    //如果权限为空，默认赋值为只读
                    power = power != null ? power : "r";//赋值
                    if(!"".equals(child.toString())){
                        if(!child.toString().endsWith(",")){
                            child.append(",");
                        }
                    }
                    child.append(name);
                    child.append("=");
                    child.append(changePower(power));

                }
                jsonObject.put(SvnConfigUtil.child,child.toString());
                jsonArray.add(jsonObject);
            }

        }

        return writeSVNPower(repositoriesPath, jsonArray);

    }

    /**
     * 删除用户权限
     * @param repositoriesPath 版本仓库地址 E:/Repositories
     * @param repository 版本库 pdm_zongti 如不传则删除根目录下用户
     * @param catalog 目录 /zxc-1 可为空; 删除当前目录及其子目录下用户
     * @param lists 需要删除的用户集合 ['123123123123']   为空时则删除版本库或目录地址
     * @return
     */
    public static boolean deleteSVNPower(String repositoriesPath, String repository, String catalog, List<String> lists){

        if(lists == null || lists.size() == 0){
            return false;
        }
        //查询全部数据
        JSONArray jsonArray = querySVNPowerAll(repositoriesPath);
        if(jsonArray == null){
            return false;
        }
        repository = StringUtil.goOutSpace(repository);
        repository = repository != null ? repository : "";
        catalog = catalog != null ? catalog.startsWith("/") ? catalog : "/"+catalog : "";
        String repositoryca = splitRepository(repository, catalog);

        //根目录标志位
        boolean roootDirFlag = false;

        if(repository == null){
            //根目录
            roootDirFlag = true;
        }
        //去掉最后一位]
        String repositoryca1 = repositoryca.substring(0,repositoryca.length()-1);

        for(int i = jsonArray.size()-1;i>= 0;i--) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
            //获取标题
            String title = jsonObject.get(SvnConfigUtil.title).toString();
            if (title == null || "".equals(title)) {
                continue;
            }
            //比较是否有相同的版本库
            if(!title.contains(repositoryca1)){
                continue;
            }

            //相同，获取用户权限
            // 1903121443285768940=rw,root=rw,
            String child = jsonObject.get(SvnConfigUtil.child).toString();
            if (child == null || "".equals(child)) {
                continue;
            }
            String[] childs = child.split(",");
            //将值添加至集合中
            List<String> childslist = new ArrayList<>();
            for(String ch : childs){
                if(ch == null){
                    continue;
                }
                childslist.add(ch);
            }
            for(int t = 0;t < lists.size();t++){
                String listUserNO = StringUtil.goOutSpace(lists.get(t));
                if(listUserNO == null){
                    continue;
                }
                for(int y = childslist.size()-1; y >= 0;y--){
                    String userPower = StringUtil.goOutSpace(childslist.get(y));
                    if(userPower == null){
                        childslist.remove(y);
                        continue;
                    }
                    String[] users = userPower.split("=");
                    if(users.length < 1){
                        childslist.remove(y);
                        continue;
                    }
                    String userName = StringUtil.goOutSpace(users[0]);
                    if(userName == null){
                        childslist.remove(y);
                        continue;
                    }

                    if(listUserNO.equals(userName)){
                        //相同
                        childslist.remove(y);
                    }
                }
            }
            if(childslist.size() == 0){
                //说明没有子权限了，需要删除版本库这条记录
                jsonArray.remove(i);
            }else{
                //还有记录，直接添加
                StringBuffer childlist = new StringBuffer();
                for(int r = 0;r<childslist.size();r++){
                    childlist.append(childslist.get(r));
                    if(r < childslist.size()-1){
                        //说明还有
                        childlist.append(",");
                    }
                }

                jsonObject.put(SvnConfigUtil.child,childlist.toString());
            }


        }

        return writeSVNPower(repositoriesPath,jsonArray);

    }

    /**
     * 删除所有目录的指定用户权限
     * @param repositoriesPath 版本仓库地址 E:/Repositories
     * @param list 需要删除的用户集合 ['123123123123']
     * @return
     */
    public static boolean deleteSVNPowerAll(String repositoriesPath, List<String> list){
        String repositoriesPaths = StringUtil.goOutSpace(repositoriesPath);
        if (repositoriesPaths == null) {
            return false;
        }
        //查询全部数据
        JSONArray jsonArray = querySVNPowerAll(repositoriesPaths);
        if(jsonArray == null){
            return false;
        }

        for(int i = 0;i<jsonArray.size();i++){
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
            String child = jsonObject.get(SvnConfigUtil.child).toString();
            if (child == null || "".equals(child)) {
                continue;
            }
            String[] childs = child.split(",");
            //将值添加至集合中
            List<String> childslist = new ArrayList<>();
            for(String ch : childs){
                if(ch == null || "".equals(ch)){
                    continue;
                }
               String[] strings = ch.split("=");
                if(strings.length < 1){
                    continue;
                }
               for(String userTNO :list){
                    if(userTNO == null){
                        continue;
                    }
                    if(strings[0].equals(userTNO)){

                    }
               }
                childslist.add(ch);

            }
        }
        return true;
    }

    /**
     * 写入权限至svn配置文件
     * @param repositoriesPath
     * @param jsonArray
     * @return
     */
    private static boolean writeSVNPower(String repositoriesPath, JSONArray jsonArray){
        //文件读取地址
        File oldfile = new File(repositoriesPath+svnPowerPath);
        if(!oldfile.exists()){
            return false;
        }
        FileWriter fileWriter = null;
        BufferedWriter bufferedWriter = null;
        try {
                bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(repositoriesPath + svnPowerPath),charsetName));
//            fileWriter = new FileWriter(repositoriesPath + svnPowerPath);
//            bufferedWriter = new BufferedWriter(fileWriter);
            //写入文件
            for(int i =0;i<jsonArray.size();i++) {
                JSONObject jsonObject = (JSONObject) jsonArray.get(i);
                //获取标题
                String title = jsonObject.get(SvnConfigUtil.title).toString();
                //获取用户及权限
                String child = jsonObject.get(SvnConfigUtil.child).toString();
                if (title == null || "".equals(title) || child == null || "".equals(child)) {
                    continue;
                }
                String[] childs = child.split(",");
                if(childs.length == 0){
                    continue;
                }
                bufferedWriter.write(title.toCharArray());
                bufferedWriter.write(SvnConfigUtil.newline);//换行符
                for(int y =0;y<childs.length;y++){
                    String ch = childs[y];
                    if(ch == null || "".equals(ch)){
                        continue;
                    }
                    bufferedWriter.write(ch.toCharArray());
                    bufferedWriter.write(SvnConfigUtil.newline);//换行符
                    if(y == childs.length-1){
                      bufferedWriter.write(SvnConfigUtil.newline);//换行符
                    }
                }
            }
            bufferedWriter.flush();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(bufferedWriter != null){
                try {
                    bufferedWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(fileWriter != null){
                try {
                    fileWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }


    /**
     * 工具类
     * 拼接版本库
     * @param repository
     * @param catalog
     * @return
     */
    private static String splitRepository(String repository, String catalog){
        StringBuffer rep = new StringBuffer("[");
        if("".equals(repository)){
            rep.append("/");
        }else{
            rep.append(repository);
            if(!"".equals(catalog)){
                rep.append(":");
                rep.append(catalog);
            }else{
                rep.append(":/");
            }
        }
        rep.append("]");
        return rep.toString();
    }

    /**
     * 权限转换(大转小)
     * svn权限需要
     * @param power rw
     * @return RW
     */
    public static String changePower(String power){
       power = power != null ? power :"r";
       return power.toLowerCase();
    }

    /**
     * 获取是新增还是更新
     * @param text A /text_7/ideaIU-2018.2.2.exe
     * @return
     */
    public static String getAddOrUpdate(String text){
        if(text == null || "".equals(text)){
            return "";
        }
        int separator = text.indexOf("/");
        if (separator == -1){
            return "";
        }
        String type = text.substring(0,separator);
        type = type.trim();
        if("A".equals(type)){
            return "新增";
        }
        return "更新";
    }

}
