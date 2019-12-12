//package com.ecspace.business.knowledgeCenter.administrator.util;
//
///**
// * @author zhangch
// * @date 2019/12/12 0012 上午 10:58
// */
//public class SearchLogUtil {
//    private final static Logger logger = LoggerFactory.getLogger(LogUtil.class);
//    private static ExecutorService executorService = Executors.newFixedThreadPool(2);
//
//    private static MainServiceImpl mainService = SpringContextHolder.getBean("mainServiceImpl");
//
//    public static void writeMainLog(MainEntity log, List<ChildEntity> list) {
//        executorService.execute(new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    if (mainService != null) {
//                        logger.info("---插入日志start---");
//                        int issuccess = mainService.insertlog(log);
//                        int mainid = log.getId();
//                        if (list != null && issuccess > 0 && mainid > 0) {
//                            for (ChildLogEntity clog : list) {
//                                clog.setMainlogid(mainid);
//                            }
//                            mainService.insertchildlog(list);
//                        }
//                        logger.info("---插入日志end---");
//                    } else {
//                        logger.error("spring init bean mainService fail,please check configs");
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//            }
//        });
//
//    }
//}
