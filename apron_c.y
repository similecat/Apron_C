%{
int yylex(void);
void yyerror(char *);
%}
%token PERM LIMITING
%token ACTION
%token OWN_FLOWS OTHERS_FLOWS ALL_FLOWS MAX_PRIORITY EVENT_INTERCEPTION MODIFY_EVENT_ORDER FLOW_LEVEL PORT_LEVEL SWITCH_LEVEL
%token IP_SRC IP_DST TCP_SRC TCP_DST VLAN_ID
%token INT IP WITH_MASK IP_FORMAT
%token SWITCH LINK ALL_SWITCHES BORDER_SWITCHES ALL_DIRECT_LINKS ALL_PATHS_AS_LINKS VIRTUAL SINGLE_BIG_SWITCH
%token DROP FORWARD MODIFY FIELD 
%token AND OR
%token STRING
%%
program:
       perm_list
       |ownership
       |max_priority
       |notification
       |statistics
       |
       ;
ownership:
         OWN_FLOWS
         |OTHERS_FLOWS
         |ALL_FLOWS
         ;
max_priority:
            MAX_PRIORITY INT
            ;
notification:
            EVENT_INTERCEPTION
            |MODIFY_EVENT_ORDER
            ;
statistics:
          FLOW_LEVEL
          |PORT_LEVEL
          |SWITCH_LEVEL
          ;
perm_list:
         perm
         |perm perm_list
         ;
perm:
    PERM perm_name
    |PERM perm_name limit_list
    ;
perm_name:
         STRING {printf("STRING\n");}
         ;
limit_list:
          limit
          |limit limit_list
          ;
limit:
     LIMITING filter
     ;
filter:
      flow_predicate
      |topo
      |ACTION action_list
      ;

flow_predicate:
              ip_range_list
              |field value_list
              ;
field:
     TCP_SRC
     |TCP_DST
     |VLAN_ID
     ;
value_list:
          value_range
          |value_range ',' value_list
          ;
value_range:
           INT
           |INT '-' INT
           ;
ip_range_list:
             ip_range
             |ip_range OR ip_range_list
             ;
ip_range:
        IP ip_format WITH_MASK ip_format
        ;
ip_format:
         IP_FORMAT
         ;
topo:
    physical_topo
    |virtual_topo
    ;
physical_topo:
             SWITCH switch_set AND LINK link_set
             ;
switch_set:
          ALL_SWITCHES
          |BORDER_SWITCHES
          |sw_idx_list
          ;
sw_idx_list:
           sw_idx
           |sw_idx ',' sw_idx_list
           ;
sw_idx:
      INT
      ;
link_set:
        ALL_DIRECT_LINKS
        |ALL_PATHS_AS_LINKS
        |link_list
        ;
link_list:
         link
         |link ',' link_list
         ;
link:
    link_idx
    |path
    ;
path:
    link_idx
    |link_idx ':' path
    ;
link_idx:
        INT
        ;
virtual_topo:
            VIRTUAL SWITCH switch_mapping AND LINK link_set
            ;
switch_mapping:
              SINGLE_BIG_SWITCH
              |switch_set
              ;
switch_set:
          sw_idx
          |sw_idx ',' sw_idx
          ;
sw_idx:
      INT
      ;
action_list:
           action
           |action action_list
           ;
action:
      DROP
      |DROP FIELD field_list
      |FORWARD
      |FORWARD FIELD field_list
      |MODIFY
      |MODIFY FIELD field_list
      ;
field_list:
          field
          |field ',' field_list
          ;

%%
void yyerror(char *s){
    printf("Error :%s\n",s);
    return 0;
}
int main(void){
    yyparse();
    return 0;
}
