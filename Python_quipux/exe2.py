import pandas as pd
import matplotlib.pyplot as plt


def plot_exe2_a(name, data):
    fig = plt.figure()
    plt.grid(True, which="both", ls="-", linewidth=0.1, color='0.10', zorder=0)
    plt.scatter(list(data.keys()), list(data.values()), label='', color='tab:blue')
    plt.ylabel("Cantidad")
    plt.xlabel("Velocidad [Km/h]") 
    plt.title("Distribucion velocidades para " + name) 
    fig.savefig("/home/oscar/quipox/exe2/exe2_a_"+name+".png", bbox_inches='tight', dpi=300)
    plt.close(fig)



def plot_exe2_b(name, data):
    fig = plt.figure()
    plt.grid(True, which="both", ls="-", linewidth=0.1, color='0.10', zorder=0)
    plt.scatter(list(data.keys()), list(data.values()), label='', color='tab:blue')
    plt.ylabel("Porcentaje [%]")
    plt.xlabel("Velocidad [Km/h]") 
    plt.title("Probabilidade velocidades entre 20 y 30 km/h " + name) 
    fig.savefig("/home/oscar/quipox/exe2/exe2_b_"+name+".png", bbox_inches='tight', dpi=300)
    plt.close(fig)

if __name__ == "__main__":
    print("Exe 2")
    filenames = ["RP_T1", "RP_T2"]
    for name in filenames:
        print(name)
        df = pd.read_csv(name+".csv", sep=';')
        dic = {}
        for i in df['VELOCIDAD']:
            if i not in list(dic.keys()):
                dic.update([(i, list(df['VELOCIDAD']).count(i))])
        # print('Contando velocidades', dic)

        N = len(df.index)
        # print('Número de muestras', N)

        dic2 = {}
        for i in list(dic.keys()):
            if 20 <= i <= 30:
                dic2.update([(i, (dic.get(i) * 100) / N)])
        # print('Probabilidad de entre 20 e 30 Km/h', dic2)

        plot_exe2_a(name, dic)
        plot_exe2_b(name, dic2)

