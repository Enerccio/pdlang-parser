// lexer and some expressions partially taken from https://github.com/antlr/grammars-v4/blob/master/java/Java.g4
/*
 * PDLang
 * Copyright (c) 2016-2017 Peter Vaňušanik <admin@en-circle.com>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

grammar pdlang;

compilationUnit:
	imports
	moduleDefinition
	;
	
imports:
	simpleImport* 
	;
	
simpleImport:
	'import' moduleName moduleInitExpression? ';'
	;
	
moduleInitExpression:
	'(' moduleParams? ')'
	;
	
moduleParams:
	(constValue ',')* constValue
	;
	
moduleName: 
	fqName
	; 
	
moduleDefinition:
	'module' identifier moduleInit  
	moduleBody
	;
	
moduleInit:
	'(' moduleInitParams? ')'
	;
	
moduleInitParams:
	(moduleInitParam ',')* moduleInitParam
	;
	
moduleInitParam:
	type ':' identifier
	;
	
moduleBody:
	'{' moduleDescriptionElement* '}'
	;
	
moduleDescriptionElement:
	moduleConstant | moduleStruct | moduleFunc | foreignType | foreignMethod
	;
	
moduleConstant:
	'let' type identifier '=' constValue
	;
	
moduleStruct:
	'structure' identifier structBody
	;
	
foreignType:
	'foreign' 'type' identifier ';'
	;
	
structBody:
	'{' (structDecl)*? '}'
	;
	
structDecl:
	type ':' identifier ('=' constValue)? ';'
	; 
	
foreignMethod:
	'foreign' 'function' identifier closureParams? closureRet? ';'
	;
	
moduleFunc:
	staticFunc? identifier closure
	;
	
closure:
	 closureParams? closureMainBody closureRet?
	 ;
	 
closureMainBody:
	'{' closureDescription? closureCode '}'
	;
	 
closureDescription:
	closureDesc+
	;
	
closureDesc:
	variableDesc
	variableAliasDesc
	idAliasDesc
	;
	
variableDesc:
	'lv' (identifier ',')* identifier ':' type ';'
	;
	
variableAliasDesc:
	'varalias' identifier identifier ';'
	;
	
idAliasDesc:
	'idalias' fqName identifier ';'
	;
	
closureCode:
	statements*
	;
	
statements:
	  implicitClosureInvocation
	| returnStatement
	| assignStatement
	| discardStatement
	| noopStatement
	;
	
noopStatement:
	';'
	;
	
returnStatement:
	'ret' expression? ';'
	;
	
assignStatement:
	identifier '=' expression ';'
	;
	
discardStatement:
	expression ';'
	;
	
implicitClosureInvocation:
	closureMainBody
	;
	 
closureRet:
	'rets' type
	;
	
closureParams:
	'(' closureFormalParams? ')'
	;
	
closureFormalParams:
	(closureParam ',')* closureParam
	;
	
closureParam:
	identifier ':' type
	;
	
expression:
        primary
    |   expression '.' identifier
    |   expression '(' expressionList? ')'
    |   'new' creator
    |   '(' type ')' expression
    |   opPlusMinus expression
    |   opNeg expression
    |   expression opMul expression
    |   expression opPlus expression
    |   expression opShift expression
    |   expression opCompare expression
    |   expression 'instanceof' type
    |   expression opEql expression
    |   expression opBAnd expression
    |   expression opBXor expression
    |   expression opBOr expression
    |   expression opAnd expression
    |   expression opOr expression
    |   expression ternary expression ':' expression
    ;    

creator:
	'make' structType structParams
	;
	
structParams:
	'{' structParameters '}'
	;
	
structParameters:
	structParameter*
	;
	
structParameter:
	identifier '=' expression ';'
	;
    
ternary:
	'?'
	;
    
opBAnd:
	'&'
	;
	
opAnd:
	'&&'
	;
	
opBOr:
	'|'
	;

opOr:
	'||'
	;
	
opBXor:
	'^'
	;
	
opPlusMinus:
	'+' | '-'
	;
	
opNeg:
	'~' | '!'
	;
	
opMul:
	'%'|'*'|'/'
	;
	
opPlus:
	'+'|'-'
	;
	
opShift:
	'<<' | '>>>' | '>>'
	;
	
opCompare:
	'<='|'>='|'>'|'<'
	;
	
opEql:
	'=='|'!='
	;

primary:
       '(' expression ')'
    |   closure
    |   constValue
    |   identifier
;

expressionList
    :   expression (',' expression)*
;
	
staticFunc:
	'static'
	; 
	
type:
	constType |	structType | invokerType
	;
	
constType:
	'int' | 'flt' | 'dbl' | 'lng' | 'Int' | 'Lng' | 'Flt' | 'Dbl' | 
	'chr' | 'Chr' | 'str' | 'bol' | 'Bol' | 'any' 
	;
	
structType:
	fqName 
	;
	
fqName:
	(identifier '.')* identifier
	;
	
invokerType:
	'{' type ':' '(' invokerArgTypes? ')' '}'
	;
	
invokerArgTypes:
	(type ',')* type
	;

constValue:
	  integerConst
	| longConst
	| floatConst
	| doubleConst
	| stringConst
	| charConst
	| booleanConst
	| nullConst
	;
	
integerConst:
	integerLiteral | integerObject
	;
	
integerLiteral:
	IntegerLiteral 'i'?
	;
	
integerObject:
	IntegerLiteral 'I'
	;
	
longConst:
	longLiteral | longObject
	;
	
longLiteral:
	IntegerLiteral 'l'
	;
	
longObject:
	IntegerLiteral 'L'
	;

floatConst:
	 floatLiteral | floatObject
	 ;
	 
floatLiteral:
	FloatingPointLiteral 'f'
	;
	
floatObject:
	FloatingPointLiteral 'F'
	;
	
doubleConst:
	doubleLiteral | doubleObject
	;
	
doubleLiteral:
	FloatingPointLiteral 'd'?
	;
	
doubleObject:
	FloatingPointLiteral 'D'
	;

booleanConst:
	booleanLiteral | booleanObject
	;
	
booleanLiteral:
	BooleanLiteral
	;
	
booleanObject:
	BooleanLiteral 'B'
	;
	
stringConst:
	(stringLiteral '+')* stringLiteral
	;
	
stringLiteral:
	StringLiteral
	;
	
charConst:
	charLiteral | charObject
	;	
	
charLiteral:
	CharacterLiteral
	;
	
charObject:
	CharacterLiteral 'C'
	;
	
nullConst:
	NullLiteral
	;
	
identifier:
	Identifier
	;

// LEXER

INT		   : 'int';
INTO	   : 'Int';
LNG		   : 'lng';
LNGO	   : 'Lng';
FLT		   : 'flt';
FLTO	   : 'Flt';
DBL		   : 'dbl';
DBLO	   : 'Dbl';
BOL		   : 'bol';
BOLO	   : 'Bol';
STR		   : 'str';
CHR		   : 'chr';
CHRO	   : 'Chr';
ANY		   : 'any';
JOB		   : 'job';
MAKE	   : 'make';
IMPORT	   : 'import';
LET		   : 'let';
STATIC	   : 'static';
FOREIGN    : 'foreign';

/*
 [The "BSD licence"]
 Copyright (c) 2013 Terence Parr, Sam Harwell
 All rights reserved.
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// §3.10.1 Integer Literals

IntegerLiteral
    :   DecimalIntegerLiteral
    |   HexIntegerLiteral
    |   OctalIntegerLiteral
    |   BinaryIntegerLiteral
    ;

fragment
DecimalIntegerLiteral
    :   DecimalNumeral
    ;

fragment
HexIntegerLiteral
    :   HexNumeral
    ;

fragment
OctalIntegerLiteral
    :   OctalNumeral
    ;

fragment
BinaryIntegerLiteral
    :   BinaryNumeral
    ;

fragment
DecimalNumeral
    :   '0'
    |   NonZeroDigit (Digits? | Underscores Digits)
    ;

fragment
Digits
    :   Digit (DigitOrUnderscore* Digit)?
    ;

fragment
Digit
    :   '0'
    |   NonZeroDigit
    ;

fragment
NonZeroDigit
    :   [1-9]
    ;

fragment
DigitOrUnderscore
    :   Digit
    |   '_'
    ;

fragment
Underscores
    :   '_'+
    ;

fragment
HexNumeral
    :   '0' [xX] HexDigits
    ;

fragment
HexDigits
    :   HexDigit (HexDigitOrUnderscore* HexDigit)?
    ;

fragment
HexDigit
    :   [0-9a-fA-F]
    ;

fragment
HexDigitOrUnderscore
    :   HexDigit
    |   '_'
    ;

fragment
OctalNumeral
    :   '0' Underscores? OctalDigits
    ;

fragment
OctalDigits
    :   OctalDigit (OctalDigitOrUnderscore* OctalDigit)?
    ;

fragment
OctalDigit
    :   [0-7]
    ;

fragment
OctalDigitOrUnderscore
    :   OctalDigit
    |   '_'
    ;

fragment
BinaryNumeral
    :   '0' [bB] BinaryDigits
    ;

fragment
BinaryDigits
    :   BinaryDigit (BinaryDigitOrUnderscore* BinaryDigit)?
    ;

fragment
BinaryDigit
    :   [01]
    ;

fragment
BinaryDigitOrUnderscore
    :   BinaryDigit
    |   '_'
    ;

// §3.10.2 Floating-Point Literals

FloatingPointLiteral
    :   DecimalFloatingPointLiteral
    |   HexadecimalFloatingPointLiteral
    ;

fragment
DecimalFloatingPointLiteral
    :   Digits '.' Digits? ExponentPart?
    |   '.' Digits ExponentPart?
    |   Digits ExponentPart
    |   Digits
    ;

fragment
ExponentPart
    :   ExponentIndicator SignedInteger
    ;

fragment
ExponentIndicator
    :   [eE]
    ;

fragment
SignedInteger
    :   Sign? Digits
    ;

fragment
Sign
    :   [+-]
    ;

fragment
HexadecimalFloatingPointLiteral
    :   HexSignificand BinaryExponent
    ;

fragment
HexSignificand
    :   HexNumeral '.'?
    |   '0' [xX] HexDigits? '.' HexDigits
    ;

fragment
BinaryExponent
    :   BinaryExponentIndicator SignedInteger
    ;

fragment
BinaryExponentIndicator
    :   [pP]
    ;

// §3.10.3 Boolean Literals

BooleanLiteral
    :   'true'
    |   'false'
    ;

// §3.10.4 Character Literals

CharacterLiteral
    :   '\'' SingleCharacter '\''
    |   '\'' EscapeSequence '\''
    ;

fragment
SingleCharacter
    :   ~['\\]
    ;
// §3.10.5 String Literals
StringLiteral
    :   '"' StringCharacters? '"'
    ;
fragment
StringCharacters
    :   StringCharacter+
    ;
fragment
StringCharacter
    :   ~["\\]
    |   EscapeSequence
    ;
// §3.10.6 Escape Sequences for Character and String Literals
fragment
EscapeSequence
    :   '\\' [btnfr"'\\]
    |   OctalEscape
    |   UnicodeEscape
    ;

fragment
OctalEscape
    :   '\\' OctalDigit
    |   '\\' OctalDigit OctalDigit
    |   '\\' ZeroToThree OctalDigit OctalDigit
    ;

fragment
UnicodeEscape
    :   '\\' 'u' HexDigit HexDigit HexDigit HexDigit
    ;

fragment
ZeroToThree
    :   [0-3]
    ;

// §3.10.7 The Null Literal

NullLiteral
    :   'null'
    ;

// §3.11 Separators

LPAREN          : '(';
RPAREN          : ')';
LBRACE          : '{';
RBRACE          : '}';
LBRACK          : '[';
RBRACK          : ']';
SEMI            : ';';
COMMA           : ',';
DOT             : '.';

// §3.12 Operators

ASSIGN          : '=';
COLON           : ':';
EQUAL           : '==';
LE              : '<=';
GE              : '>=';
NOTEQUAL        : '!=';
ADD             : '+';
SUB             : '-';
MUL             : '*';
DIV             : '/';

// §3.8 Identifiers (must appear after all keywords in the grammar)

Identifier
    :   JavaLetter JavaLetterOrDigit*
    ;

fragment
JavaLetter
    :   [a-zA-Z$_] // these are the "java letters" below 0x7F
    |   // covers all characters above 0x7F which are not a surrogate
        ~[\u0000-\u007F\uD800-\uDBFF]
        {Character.isJavaIdentifierStart(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

fragment
JavaLetterOrDigit
    :   [a-zA-Z0-9$_] // these are the "java letters or digits" below 0x7F
    |   // covers all characters above 0x7F which are not a surrogate
        ~[\u0000-\u007F\uD800-\uDBFF]
        {Character.isJavaIdentifierPart(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

//
// Additional symbols not defined in the lexical specification
//

ELLIPSIS : '...';

//
// Whitespace and comments
//

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;