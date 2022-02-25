def get_employees_by_group(dic, name):
	lista =  []

	for k in dic.keys():
		i = dic[k]
		for j in range(len(i)):
			if name == i[j]:
				lista.append(k)


	return lista

employees = {1142: ['admin', 'full-time', 'manager'], 1143: ['full-time'], 1144: ['admin']}

y = get_employees_by_group(employees, 'admin')

print(y)
