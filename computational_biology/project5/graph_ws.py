import matplotlib.pyplot as plt 
from project5_setup import read_file, mean

data = read_file("w_data.txt")
x = list()
y = list()
# print(data[0])
for item in data:
    item = item.split(', Time:')
    ws = item[0].split("Ws:")[1].split(",")
    ws[0] = ws[0].split("[")[1]
    ws[len(ws)-1] = ws[len(ws)-1].split("]")[0]
    y.append(list(map(float,(ws))))
    time = int(item[1])
    x.append(time)
plt.title("Convergence of Weights")
plt.xlabel("Iteration")
plt.ylabel("Weight Averages")
plt.plot(x,[mean(w) for w in y])
plt.show()
