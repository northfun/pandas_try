import time
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

verA = "v1.0av1"
verB = "v1.0bv1"
csvFile = "./data/test_data.log"
colName = ['reqid', 'timestampms', 'fill_price', 'model_price', 'model_ver', 'model_name', 'imp_price', 'real_cost']
datas = pd.read_csv(filepath_or_buffer=csvFile, names=colName)


datas["date_time"] = list(
    # map(lambda x: time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(float(x/1000))), datas["timestampms"]))
    map(lambda x: time.strftime("%Y-%m-%d %H:%M", time.localtime(float(x/1000))), datas["timestampms"]))

# ab fill_count & imp_count
datas["ab_imp"] = list(
    map(lambda x,y: "imp_"+x if not y == 0 else "null_"+x, datas["model_ver"], datas["imp_price"]))


# startTime=datas.loc[0].at["date_time"]
# endTime=datas.loc[datas.last_valid_index()].at["date_time"]
# dateIndex=pd.date_range(startTime, endTime, freq='10S')
# print(dateIndex)

# fillNum=pd.DataFrame(datas[""])

abImpCounts=datas.groupby("date_time")["ab_imp"].value_counts()
abImpCounts.unstack().plot(kind='line', style='.-', legend=True)

plt.show()

impDatasA=datas.loc[((datas['imp_price']>0 )& (datas["model_ver"] == verA))].copy()
impDatasB=datas.loc[((datas['imp_price']>0) & (datas["model_ver"] == verB))].copy()

print(impDatasB.head()["model_ver"])

impDatasA["marginA"] = list(
    map(lambda x,y: int((y-x)*1000), impDatasA["imp_price"], impDatasA["real_cost"]))
impDatasB["marginB"] = list(
    map(lambda x,y: int((y-x)*1000), impDatasB["imp_price"], impDatasB["real_cost"]))

impPriceACounts=impDatasA.groupby("date_time")["marginA"].mean()
impPriceBCounts=impDatasB.groupby("date_time")["marginB"].mean()

print(impPriceACounts)

print(impPriceBCounts)

abImpCounts = pd.merge(impPriceACounts, impPriceBCounts, how="left")
abImpCounts.shape
abImpCounts.unstack().plot()

#print(abImpCounts)
# df = pd.DataFrame(np.random.randn(1000, 4), index=pd.date_range('1/1/2000', periods=1000), columns=list('ABCD'))
# df = df.cumsum()
# df.plot()

plt.show()