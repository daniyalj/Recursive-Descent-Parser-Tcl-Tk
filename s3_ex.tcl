#
# David Iliaguiev, 210479830, davidili
# Daniyal Javed, 212654570, cse31034
# Alesya Orina, 212290987, cse23221
#
#
# Implementation for a Recursive Descent Parser of the language of EBNF
#

 namespace eval ::RDP {
    variable rdp_type
    variable rule_code
    variable lexeme        ""
    variable lexeme_previous
	
    variable list_lexeme
    variable count_lexeme
    variable token
    variable end_file

    namespace export init define | rule getLexeme
 }

 #    Initialise the RDP by giving it a list of lexemes

 proc ::RDP::init { input } {
    variable end_file
    variable count_lexeme
    variable list_lexeme

    set end_file           0

    set count_lexeme -1
    set list_lexeme  $input
    set lexeme       ""

    NextLexeme
 }

 #    Get the lexeme that was last examined

 proc ::RDP::getLexeme {} {
    variable lexeme_previous
    return $lexeme_previous
 }

 #    Define the first rule for an item

 proc ::RDP::define { item match {code {}} } {
    variable rdp_type
    variable rule_code
    variable last_item

    set last_item              $item
    set rdp_type($item) [list $match]
    set rule_code($item)       [list $code]
 }

 #    Define alternatives for the first rule for an item

 proc ::RDP::| { match {code {}} } {
    variable rdp_type
    variable rule_code
    variable last_item

    lappend rdp_type($last_item) $match
    lappend rule_code($last_item)       $code
 }

 #    Match the input to the given rule

 proc ::RDP::rule { item } {
    variable rdp_type
    variable rule_code
    variable lexeme
    variable end_file

    if { $end_file } { return 0 }

    # Try all the rules in turn

    set rule_count 0
    foreach dependents $rdp_type($item) code $rule_code($item) {

       set retcode 1
       incr rule_count
       foreach dep $dependents {

          if { [string toupper $dep] != $dep } {
             set retcode [rule $dep]
             if { $retcode == 0 } {
                break ;
             } elseif { $retcode == "error" } {
                return "error"
             }
          } else {

             if { [getToken $lexeme] == $dep } {
                puts "$item: $dep = $lexeme"
                NextLexeme
             } else {

                return 0
             }
          }
       }

       if { $retcode == 1 } {
          namespace eval :: $code
          return 1
       } elseif { $rule_count == [llength $rdp_type($item)] } {

          if { $dep == $item } {
             return 1
          } else {
             return 0
          }
       }
    }

    return "error"
 }

 proc ::RDP::NextLexeme {} {
    variable count_lexeme
    variable list_lexeme
    variable lexeme_previous
    variable lexeme
    variable end_file

    incr count_lexeme
    set  lexeme_previous $lexeme
    if { $count_lexeme < [llength $list_lexeme] } {
       set lexeme [lindex $list_lexeme $count_lexeme]
       puts "Next token is: $lexeme"
    } else {
       puts "Next token is: EOF"
       set end_file 1
    }
 }

 #    Identify the token to the given lexeme

 proc getToken { lexeme } {
    if { $lexeme == "*" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
	    if { $lexeme == "+" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
	    if { $lexeme == "-" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
	    if { $lexeme == "/" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
	    if { $lexeme == "(" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
	    if { $lexeme == ")" } {
       puts "$lexeme = <FACTOR>"
       return "FACTOR"
    }
	
    if { [string is integer -strict $lexeme] } {
       puts "$lexeme = <EXPR>"
       return "FACTOR"
    }

    puts "$lexeme = <TERM>"
    return "STRING"
 }

 # main --
 #   The grammar should parse this input:
 #   A 4       ; a list of attributes for "nodes"
 #   B 5
 #   C 2
 #   +         ; a separator
 #   A B 3     ; a list of connections between "nodes" with a next
 #   A C 1
 #

 namespace import ::RDP::*

 define input     {nodes separator links}
 define nodes     {node nodes}
 define separator FACTOR
 define node      {name next} {
    set Node($name1) $next
 }
 define name      STRING {
    set name1 [getLexeme]
 }
 define next    FACTOR {
    set next [getLexeme]
 }
 define links     {link links}
 define link      {name string next} {
    set Link($name1,$string) $next
 }
 define string     STRING {
    set string [getLexeme]
 }

 init {A 4 B 5 C 2 + A B 3 A C 1}
 puts "Result: [rule input]"

 parray Node
 parray Link
