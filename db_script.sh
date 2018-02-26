#hell Script name: Driver for Ansible
#

#             Created:              (MM/DD/YYYY)

#             Cliford                   02/13/2018         version 1

#

#             Modified:            (MM/DD/YYYY)

#             Cliford                   02/13/2018         version 1

#

############################################################################

. ${HOME}/.profile-12c

export DB_DATE=`date '+%m/%d/%y-%H:%M:%S'`

export LOGS=/tmp/log_$DB_DATE.log

export CONNSTRINGS=`sort -u $ORACLE_HOME/network/admin/tnsnames.ora | grep -v "^ " | grep -v "^#" | grep -v "^(" | grep -v "^)" | sed "s/ =//g" | grep -v "^$"`

echo "${CONNSTRINGS}" | while read line
do
   tnsping $line
done

word=tnsnames.ora

if [ $word == "tnsnames.ora" ]
then
  echo "condition is true"
else
   echo "condition is false"
fi

#exit 0

#check for standalone listener and tnsnames status

lsnrctl status LISTENER

ps -ef|grep LISTENER

ps -ef|grep tns

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF

connect chedb/ventech@VENTECDB
spool test6.txt

#Prompt check for coampatibility

SELECT name, value FROM v\$parameter WHERE name = 'compatible';

#Prompt check for optimizer_feature is enabled

select * from database_compatible_level;

SHOW PARAMETER optimizer_features_enable;

#Prompt check for job_queue_processes

select value from v\$parameter where name='job_queue_processes';

show parameter job_queue_processes;

#Prompt check if controlfile is multiplex And check if file exit with name = location of file

Show parameter control_files;

#Prompt check for spfile And check if file exit with name = location of file

show parameter spfile;

#Prompt verify all oracle components

COL comp_name FOR a50
COL version FOR a30
COL status FOR a30

SELECT comp_name, version, status FROM dba_registry;

spool off
exit
EOF

#End of Shell script modified=====

