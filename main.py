from numpy import concatenate
import pandas as pd
import random

def result_invalid(result):
    #returns True if result is not a combo of
    #3 1s and 0s e.g. 101
    if len(result) != 3:
        return True
    for i in [0,1,2]:
        if (result[i] != '0') & (result[i] != '1'):
            return True
    return False

discs = ['Dagger', 'Luna', 'Caltrop']

date = input("Enter todays date, e.g. 10/19/21 : ")
dates = []
putt = []
order = []
dagger = []
luna = []
caltrop = []
for i in range(1, 11, 1):
    dates.append(date)
    random.shuffle(discs)
    print('Putt number: ', i)
    putt.append(i)
    order.append(discs[0][0] + discs[1][0] + discs[2][0])
    print('Order: ', discs)

    result = input('Result: ') #e.g. 101
    while result_invalid(result):
        result = input('Try again: ')

    if (discs[0] == 'Dagger') & (discs[1] == 'Luna') & (discs[2] == 'Caltrop'):
        dagger.append(result[0])
        luna.append(result[1])
        caltrop.append(result[2])
    if (discs[0] == 'Dagger') & (discs[1] == 'Caltrop') & (discs[2] == 'Luna'):
        dagger.append(result[0])
        caltrop.append(result[1])
        luna.append(result[2])
    if (discs[0] == 'Luna') & (discs[1] == 'Dagger') & (discs[2] == 'Caltrop'):
        luna.append(result[0])
        dagger.append(result[1])
        caltrop.append(result[2])
    if (discs[0] == 'Caltrop') & (discs[1] == 'Dagger') & (discs[2] == 'Luna'):
        caltrop.append(result[0])
        dagger.append(result[1])
        luna.append(result[2])
    if (discs[0] == 'Caltrop') & (discs[1] == 'Luna') & (discs[2] == 'Dagger'):
        caltrop.append(result[0])
        luna.append(result[1])
        dagger.append(result[2])
    if (discs[0] == 'Luna') & (discs[1] == 'Caltrop') & (discs[2] == 'Dagger'):
        luna.append(result[0])
        caltrop.append(result[1])
        dagger.append(result[2])
    print(' ')

df_new = pd.DataFrame(zip(dates, putt, order, dagger, luna, caltrop), 
    columns=['date', 'putt_#', 'order', 'dagger', 'luna', 'caltrop'])
df_old = pd.read_csv('data.csv')
df = pd.concat([df_old, df_new], ignore_index=True)
df.to_csv('data.csv', index=False)