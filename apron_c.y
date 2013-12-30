%{
typedef char* string;
#define YYSTYPE string
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror(char *);
%}
%token PERM LIMITING
%token ACTION
%token OWN_FLOWS OTHERS_FLOWS ALL_FLOWS MAX_PRIORITY EVENT_INTERCEPTION MODIFY_EVENT_ORDER FLOW_LEVEL PORT_LEVEL SWITCH_LEVEL
%token IP_SRC IP_DST TCP_SRC TCP_DST VLAN_ID
%token INT IP WITH MASK IP_FORMAT
%token SWITCH LINK ALL_SWITCHES BORDER_SWITCHES ALL_DIRECT_LINKS ALL_PATHS_AS_LINKS VIRTUAL SINGLE_BIG_SWITCH
%token DROP FORWARD MODIFY FIELD 
%token AND OR NOT AS FLOAT RULE_COUNT_PER_SWITCH SIZE_PERCENTAGE_PER_SWITCH
%token STRING
%start program
%%
program:
       perm_list
       ;
perm_list:
         perm
         |perm perm_list
         ;
perm:
    PERM perm_name
    |PERM perm_name LIMITING filter_expr
    ;
filter_expr:
    filter_term
    |filter_expr AND filter_term
    ;
filter_term:
    filter_factor
    |filter_term OR filter_factor
    ;
filter_factor:
    filter_not_factor
    |NOT filter_factor
    ;
filter_not_factor:
    '(' filter_expr ')'
    |flow_predicate
    |topo
    |ACTION action
    |ownership
    |max_priority
    |flow_table
    |notification
    |statistics
    ;    
flow_predicate:
              ip_range
              |field '{' value_list'}'
              ;
field:
     TCP_SRC
     |TCP_DST
     |VLAN_ID
     |IP_SRC
     |IP_DST
     ;
value_list:
          value_range 
          |value_range ',' value_list
          ;
value_range:
           INT
           |INT '-' INT
           ;
ip_range:
        IP ip_format WITH MASK ip_format
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
          |'{' sw_idx_list '}'
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
    |'(' path ')'
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
              |'{' virtual_switch_set '}'
              ;
virtual_switch_set:
          switch_set AS sw_idx
          |switch_set AS sw_idx ',' virtual_switch_set
          ;
action:
      DROP
      |FORWARD
      |MODIFY
      |MODIFY FIELD field_list
      ;
field_list:
          field
          |field ',' field_list
          ;    
ownership:
         OWN_FLOWS
         |OTHERS_FLOWS
         |ALL_FLOWS
         ;
max_priority:
            MAX_PRIORITY INT
            ;
flow_table:
    RULE_COUNT_PER_SWITCH INT
    |SIZE_PERCENTAGE_PER_SWITCH FLOAT
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
perm_name:
         STRING {printf("STRING\n");}
         ;


%%
void yyerror(char *s){
    printf("Error :%s\n",s);
    return;
}
int main(void){
    yyparse();
    return 0;
}
