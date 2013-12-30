%{
#include "stdlib.h"
void yyerror(char *);
#include "y.tab.h"
int yylineno;
#define DEBUG
%}
INT [0-9]+
IP_FORMAT [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+
STRING [A-Za-z_]+
%%
PERM {
#ifdef DEBUG
    printf("PERM\t: %s\n",yytext);
#endif
    return PERM;
    }
LIMITING {
#ifdef DEBUG
    printf("LIMITING\t: %s\n",yytext);
#endif
    return LIMITING;
    }
ACTION {
    return ACTION;
}
OWN_FLOWS {
    return OWN_FLOWS;
}
OTHERS_FLOWS {
    return OTHERS_FLOWS;
}
ALL_FLOWS {
    return ALL_FLOWS;
}
MAX_PRIORITY {
    return MAX_PRIORITY;
}
EVENT_INTERCEPTION {
    return EVENT_INTERCEPTION;
}
MODIFY_EVENT_ORDER {
    return MODIFY_EVENT_ORDER;
}
FLOW_LEVEL {
    return FLOW_LEVEL;
}
PORT_LEVEL {
    return PORT_LEVEL;
}
SWITCH_LEVEL {
    return SWITCH_LEVEL;
}
IP_SRC {
#ifdef DEBUG
    printf("IP_SRC\t: %s\n",yytext);
#endif
    return IP_SRC;
}
IP_DST {
    return IP_DST;
}
TCP_SRC {
    return TCP_SRC;
}
TCP_DST {
    return TCP_DST;
}
VLAN_ID {
    return VLAN_ID;
}
{INT} {
    yylval = atoi(yytext);
    return INT;
}
IP {
#ifdef DEBUG
    printf("IP\t: %s\n",yytext);
#endif
    return IP;
}
WITH_MASK {
#ifdef DEBUG
    printf("WITH_MASK\t: %s\n",yytext);
#endif
    return WITH_MASK;
}
{IP_FORMAT} {
#ifdef DEBUG
    printf("IP_FORMAT\t: %s\n",yytext);
#endif
    return IP_FORMAT;
}
SWITCH {
    return SWITCH;
}
LINK {
    return LINK;
}
ALL_SWITCHES {
    return ALL_SWITCHES;
}
BORDER_SWITCHES {
    return BORDER_SWITCHES;
}
ALL_DIRECT_LINKS {
    return ALL_DIRECT_LINKS;
}
ALL_PATHS_AS_LINKS {
    return ALL_PATHS_AS_LINKS;
}
VIRTUAL {
    return VIRTUAL;
}
SINGLE_BIG_SWITCH {
    return SINGLE_BIG_SWITCH;
}
DROP {
    return DROP;
}
FORWARD {
    return FORWARD;
}
MODIFY {
    return MODIFY;
}
FIELD {
    return FIELD;
}
AND {
#ifdef DEBUG
    printf("AND\t: %s\n",yytext);
#endif
    return AND;
}
OR {
#ifdef DEBUG
    printf("OR\t: %s\n",yytext);
#endif
    return OR;
}
{STRING} {
#ifdef DEBUG
    printf("STRING\t: %s\n",yytext);
#endif
    return STRING;
}
[,:] {
    return *yytext;
}
[\n] {
    ++yylineno;
}
[ \t] ;
. yyerror("invalid character");
%%
int yywrap(){
    return 1;
}