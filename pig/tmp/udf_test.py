@outputSchema("word:chararray")
def helloworld(): 
    return ('Hello, World')
 
@outputSchema("t:(word:chararray,num:long)")
def complex(word): 
    return (str(word),long(word)*long(word))
 
@outputSchemaFunction("squareSchema")
def square(num):
    return ((num)*(num))
 
@schemaFunction("squareSchema")
def squareSchema(input):
    return input
 
# No decorator - bytearray
def concat(str):
    return str+str