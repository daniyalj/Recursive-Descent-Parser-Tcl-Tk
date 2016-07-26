#
#	David Iliaguiev, 210479830, davidili
#	Daniyal Javed, 212654570, cse31034
#	Alesya Orina, 212290987, cse23221
#
#
#	Implementation for a state diagram for the language of EBNF
#

#    Identify the token to the given lexeme

proc tokenCheck { lexeme } {
	if { $lexeme == "\{" || $lexeme == "\}" || $lexeme == "(" || $lexeme == ")" || 
	$lexeme == "=" || $lexeme == "|" || $lexeme == "\'" || $lexeme == "\"" || 
	$lexeme == "," || $lexeme != " " } {
	   puts "Next token is: $lexeme"
	}
}


puts "Enter a language defined by the grammar of EBNF:"
set userinput [gets stdin]
set size [string length $userinput]
set i 0
for { set i 0 } { $i < $size } { incr i } {
	set k [string index $userinput $i]
	tokenCheck $k
}