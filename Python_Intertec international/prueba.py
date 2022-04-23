# Your last Python code is saved below:
# #Write a program that parses a sentence and replaces each word with the following: 
# #1) The first letter of the word
# #2) The number of distinct characters between first and last character
# #3) The last letter of the word. 

# #For example, Smooth would become S3h. 
# #Words are separated by spaces or non-alphabetic characters and these separators should be maintained
#  in their original form and location in the answer. 
# #A few of the things we will be looking at is accuracy, efficiency, solution completeness. 

import re

def create_symbols(lista):
  answer = []
  for i in lista:
    j = i[1:-1]
    numero = len(set(j)) 
 
    if numero == 0: 
      numero = ""
    else:
       numero =  str(numero)
    if(len(i)>1):   
       word = i[0] + numero + i[-1]
    else:
       word = i[0] 
    answer.append(word)
    
  return answer

def process(lista_base, lista, answer):
  rta =[]
  pos = 0 
  pos_base = 0
  while(pos < len(lista)):
    # print(pos, pos_base)
    i = lista_base[pos_base]
    if(i.isalnum()): # Word is OK, add symbol
      rta.append(answer[pos])
      pos +=1
    else:  # Word is NOT OK, non-alphabetic
      j =  re.sub("[^\w]", " ",  i).split()
      print(j)
      offset = len(j)
      print(offset) 
      target = list(lista_base[pos_base])
      print(target)
      if(offset>1): # Join symbols with non-alphabetic char
        pos_target = len(lista[pos]) 
        print(pos_target)
        caracter = str(target[pos_target])
        s = caracter.join(answer[pos:pos+offset])
        print(s)
        rta.append(s)
        pos+= offset
      else: # Add non-alphabetic char to the symbol
        begin = ""
        end =""
        if(target[0].isalnum()==False):
          begin = str(target[0]) 
        if(target[-1].isalnum()==False):
          end = str(target[-1])
        x = begin + answer[pos] + end
        rta.append(x)
        pos +=1
        
    pos_base +=1
  return rta

def wordParser(s):
    
  lista_base = s.split(" ") 
  
  lista = re.sub("[^\w]", " ",  s).split()
  
  answer = create_symbols(lista) 
   
  print("\nRaw List", lista_base)
  print("\nClean List", lista)
  print("\nSimbolos",answer)
  
  rta = process(lista_base, lista, answer)
   
  rta_string = " ".join(rta[0:len(rta)])
  return rta_string


output = wordParser('Creativity is x thinking-up new @is. things. Inno=vat=ion .is hola*prueba=definitiva-ihbdiebfilbwfib doing new things!');
print (output)
# 'C6y is t4g-up n1w t4s. I6n is d3g n1w t4s!'
# # expected: C6y is t4g-up n1w t4s. I6n is d3g n1w t4s!

s = "thinking-up"

regex = re.sub("[\w]", "",  s)
print(regex)

