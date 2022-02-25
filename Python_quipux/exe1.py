import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import pyplot as plt
import collections
from collections import Counter


def plot_exe1_a(ef):
	fig = plt.figure()
	ax = fig.add_axes([0,0,3,1])
	langs = ['T1_INF1_moto', 'T1_INF1_carro', 
			'T1_INF2_moto', 'T1_INF2_carro', 
			'T2_INF1_moto', 'T2_INF1_carro', 
			'T2_INF2_moto', 'T2_INF2_carro',
			'T3_INF1_moto', 'T3_INF1_carro', 
			'T3_INF2_moto', 'T3_INF2_carro']
	students = ef
	ax.bar(langs,students)
	plt.ylim(40, 102)

	plt.ylabel("Eficiencia [%]")
	plt.xlabel("Metrica") 
	plt.title("Eficiencia reconociendo placa por tecnologia y tipo de vehiculo") 
	fig.savefig("/home/oscar/quipox/exe1/exe1_a.png", bbox_inches='tight', dpi=300)
	plt.close(fig) 

def plot_exe1_b(dic2, name):
	fig = plt.figure()
	plt.bar(range(len(dic2)), list(dic2.values()), align='center')
	plt.xticks(range(len(dic2)), list(dic2.keys()))
	minimun = min(dic2.values())
	maximum = max(dic2.values())
	plt.ylim(minimun-5, maximum+5)
	plt.ylabel("Eficiencia [%]")
	plt.xlabel("Letra") 
	plt.title("Eficiencia deteccion letras y numeros por tecnologia " + name) 
	fig.savefig("/home/oscar/quipox/exe1/exe1_b_"+name+".png", bbox_inches='tight', dpi=300)
	plt.close(fig) 
		

	
def plot_exe1_c(name, data): 
	labels, counts = np.unique(data,return_counts=True)
	ticks = range(len(counts))
	fig = plt.figure()
	total = sum(counts)
	counts = (counts/total)*100
	plt.bar(ticks,counts, align='center')
	plt.xticks(ticks, labels)
	plt.ylabel("Porcentaje [%]")
	plt.xlabel("Letra") 
	plt.title("Distribucion letras y numeros para " + name) 
	fig.savefig("/home/oscar/quipox/exe1/exe1_c_"+name+".png", bbox_inches='tight', dpi=300)
	plt.close(fig) 


if __name__ == "__main__":
	print("Exe 1")

	filenames= ["T1_INF1", "T1_INF2", "T2_INF1", "T2_INF2", "T3_INF1", "T3_INF2",]
	# filenames= ["T1_INF1"]

	ef = []
	caracteres_moto = []
	caracteres_carro = []

	
	for name in filenames:
		dic = {}
		print(name)		
		fname="/home/oscar/quipox/"+name+".csv"
		f = open(fname, 'r')
		num_cols = len(f.readline().split('|'))
		f.seek(0)
		lines = f.read().splitlines()
		f.close()
		lines.pop(0)
		size = len(lines)

		corregida_moto = []
		dectectada_moto = []
		estado_moto = []
		
		dectectada_carro = []
		corregida_carro = []
		estado_carro = []

		for i in range(size):
			data = lines[i].split(',')

			corregida = data[4] 
			try:
				aux = int(corregida[-1])
			except Exception as e:
				aux = -1
			# Exe 1 - a
			if(aux==-1):
				dectectada_moto.append(data[3])
				corregida_moto.append(data[4])
				estado_moto.append(data[5])
				for caracter in data[4]:
					caracteres_moto.append(caracter)


			else:	
				dectectada_carro.append(data[3])
				corregida_carro.append(data[4])
				estado_carro.append(data[5])
				for caracter in data[4]:
					caracteres_carro.append(caracter)


			# Exe 1 - b
			size_dectectada = len(data[3])
			size_corregida = len(data[4])
			if(size_dectectada == size_corregida):
				dectectada = data[3]
				corregida = data[4]
				for i in range(len(dectectada)):
					if(dectectada[i]==corregida[i]):
						if caracter in dic.keys():
							vector = dic[caracter]
							vector[0] = vector[0] + 1
							dic[caracter] = vector
						else:
							vector = []
							vector.append(1)
							vector.append(0)
							dic[caracter] = vector
					else:
						if caracter in dic.keys():
							vector = dic[caracter]
							vector[1] = vector[1] + 1
							dic[caracter] = vector
						else:
							vector = []
							vector.append(0)
							vector.append(1)
							dic[caracter] = vector

		

		
		# Exe 1 - c
		n_aprobado_moto = estado_moto.count("Aprobado")
		total_moto = len(estado_moto)
		eficiencia_moto  = (n_aprobado_moto/total_moto)*100
		# print(eficiencia_moto)
			
		# print(set(estado_carro))
		n_aprobado_carro = estado_carro.count("Aprobado")
		total_carro = len(estado_carro)
		eficiencia_carro  = (n_aprobado_carro/total_carro)*100
		# print(eficiencia_carro)

		ef.append(eficiencia_moto)
		ef.append(eficiencia_carro)

	
		dic2 = {}
		for llave in dic.keys():
			vector = dic[llave]
			eficiencia_caracter = (vector[1]/(vector[0]+vector[1]))*100
			dic2[llave] = 100 - eficiencia_caracter
		plot_exe1_b(dic2, name)


	plot_exe1_a(ef)
	plot_exe1_c("Motos",caracteres_moto)
	plot_exe1_c("Carros",caracteres_carro)



 
	

