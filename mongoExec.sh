#!/bin/bash
# +----------------------------------------------------------------------+
# | System name: Mongo Tool                                              |
# +----------------------------------------------------------------------+
# | Execute MongoDB                                                      |
# +----------------------------------------------------------------------+
# | Authors: Rui Bando                                                   |
# +----------------------------------------------------------------------+

#--------------------------
# SUB ROUTINE
#--------------------------
exitValEmpty(){
 if [ -z $1 ] ; then
  echo " failed "
  echo " exit "
  exit 1
 fi
}

#名前を取得
echo -n "        your name ? >"
read INPUT
exitValEmpty ${INPUT}
IN_NAME=${INPUT}

#DB名を取得
echo -n "         which db ? >"
read INPUT
exitValEmpty ${INPUT}
IN_DB=${INPUT}

#コレクション名を取得
echo -n " which collection ? >"
read INPUT
exitValEmpty ${INPUT}
IN_COLLECTION=${INPUT}

#クエリを取得
echo -n "            query ? >"
read INPUT
IN_QUERY=${INPUT}

#作成されるファイルの準備
DATETIME=`date +%Y%m%d%H%M%S`
mkdir /tmp/${IN_NAME}_${DATETIME}/
OUTPUT_EXPLAIN_FILE="/tmp/${IN_NAME}_${DATETIME}/explain.js"
OUTPUT_QUERY_FILE="/tmp/${IN_NAME}_${DATETIME}/result.js"
EXPLAIN_FILE="/tmp/${IN_NAME}_${DATETIME}/explain.txt"
RESULT_FILE="/tmp/${IN_NAME}_${DATETIME}/result.txt"

#--------------------------
# CONFIRM
#--------------------------
echo "              name: ${IN_NAME}"
echo "            dbname: ${IN_DB} "
echo "        collection: ${IN_COLLECTION}"
echo "             query: ${IN_QUERY}"
echo "        explain.js: ${OUTPUT_EXPLAIN_FILE}"
echo "          query.js: ${OUTPUT_QUERY_FILE}"
echo "         queryfile: ${EXPLAIN_FILE}"
echo "        resultfile: ${RESULT_FILE}"
echo "             --------"

#EXPLAINの実行確認
echo -n "Execute explain ok/no ? >"
read INPUT
res=${INPUT}
if [ "$res" != "ok" ] ; then
 echo " cancel "
 echo " exit "
 exit 1
fi

#EXPLAIN用のファイルを作成
QUERY="db.${IN_COLLECTION}.find($IN_QUERY).limit(10)"
echo "var explain  = ${QUERY}.explain();" >> ${OUTPUT_EXPLAIN_FILE}
echo "printjson(explain);" >> ${OUTPUT_EXPLAIN_FILE}

#--------------------------                                                         
# Execute MongoDB                                                                                                                        
#--------------------------
#Choose MongoDB Path 
mongo  ${IN_DB} ${OUTPUT_EXPLAIN_FILE} >> ${EXPLAIN_FILE}

#■実行結果を書き出す
cat ${EXPLAIN_FILE}

#EXPLAIN結果の確認
echo -n "explain ok/no ? >"
read INPUT
res=${INPUT}
if [ "$res" != "ok" ] ; then
#EPLAINファイルの削除確認
 rm -i ${OUTPUT_EXPLAIN_FILE}
 echo " exit "
 exit 1
fi

#クエリ用のファイルを作成
QUERY="db.${IN_COLLECTION}.find(query)"
echo 'var query = ""' >> ${OUTPUT_QUERY_FILE}
if [ "${IN_QUERY}" != "" ] ; then
 echo "query = ${IN_QUERY};" >> ${OUTPUT_QUERY_FILE}
fi

echo "${QUERY}.forEach(print);" >> ${OUTPUT_QUERY_FILE}

#------------------------------------------#
# Execute MongoDB
#------------------------------------------#
#Choose MongoDB Path
mongo ${IN_DB} ${OUTPUT_QUERY_FILE} >> ${RESULT_FILE}

#------------------------------------------#
# END
#------------------------------------------#
exit 










