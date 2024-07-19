with vs as (
  select username
       , sid
       , serial#
       , status
       , schemaname
       , module
       , action
       , client_info
       , client_identifier
       , resource_consumer_group
       , last_call_et
       , command
    from v$session
)
  select vs.username
       , vs.schemaname
       , vs.status
       , case when vs.status = 'ACTIVE' then last_call_et else null end as seconds_in_wait
       , ( select vsc.command_name from v$sqlcommand vsc where vsc.command_type = vs.command ) as command
       , vs.module
       , vs.action
       , vs.client_info
       , vs.client_identifier
       , vs.resource_consumer_group  
       , regexp_substr( vs.module, '(\w+)\/APEX:APP (\d+):(\d+)', 1, 1, 'i', 1 ) as app_schema
       , regexp_substr( vs.module, '(\w+)\/APEX:APP (\d+):(\d+)', 1, 1, 'i', 2 ) as app_id
       , regexp_substr( vs.module, '(\w+)\/APEX:APP (\d+):(\d+)', 1, 1, 'i', 3 ) as app_page_id
       , regexp_substr( vs.client_info, '(\d+):(\w+)', 1, 1, 'i', 1 ) as workspace_id
       , regexp_substr( vs.client_info, '(\d+):(\w+)', 1, 1, 'i', 2 ) as workspace_user
       , regexp_substr( vs.client_identifier, '(\w+):(\d+)', 1, 1, 'i', 1 ) as app_user
       , regexp_substr( vs.client_identifier, '(\w+):(\d+)', 1, 1, 'i', 2 ) as app_session
    from vs
   where username in ('APEX_PUBLIC_USER', 'ORDS_PUBLIC_USER')
order by username asc, status asc
;
