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

#̾�������
echo -n "        your name ? >"
read INPUT
exitValEmpty ${INPUT}
IN_NAME=${INPUT}

#DB̾�����
echo -n "         which db ? >"
read INPUT
exitValEmpty ${INPUT}
IN_DB=${INPUT}

#���쥯�����̾�����
echo -n " which collection ? >"
read INPUT
exitValEmpty ${INPUT}
IN_COLLECTION=${INPUT}

#����������
echo -n "            query ? >"
read INPUT
IN_QUERY=${INPUT}

#���������ե�����ν���
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

#EXPLAIN�μ¹Գ�ǧ
echo -n "Execute explain ok/no ? >"
read INPUT
res=${INPUT}
if [ "$res" != "ok" ] ; then
 echo " cancel "
 echo " exit "
 exit 1
fi

#EXPLAIN�ѤΥե���������
QUERY="db.${IN_COLLECTION}.find($IN_QUERY).limit(10)"
echo "var explain  = ${QUERY}.explain();" >> ${OUTPUT_EXPLAIN_FILE}
echo "printjson(explain);" >> ${OUTPUT_EXPLAIN_FILE}

#--------------------------                                                         
# Execute MongoDB                                                                                                                        
#--------------------------
#Choose MongoDB Path 
mongo  ${IN_DB} ${OUTPUT_EXPLAIN_FILE} >> ${EXPLAIN_FILE}

#���¹Է�̤�񤭽Ф�
cat ${EXPLAIN_FILE}

#EXPLAIN��̤γ�ǧ
echo -n "explain ok/no ? >"
read INPUT
res=${INPUT}
if [ "$res" != "ok" ] ; then
#EPLAIN�ե�����κ����ǧ
 rm -i ${OUTPUT_EXPLAIN_FILE}
 echo " exit "
 exit 1
fi

#�������ѤΥե���������
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










