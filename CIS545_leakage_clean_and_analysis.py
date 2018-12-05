import xlrd
import pandas as pd
import numpy as np

cleaned_df = pd.DataFrame(columns =["Flow", "Referer_Header", "Request", "Servercon", "Clientcon", "Host", "time"])
df = pd.DataFrame(columns =["Ex"])
df1 = pd.DataFrame(columns =["Domain", "Host"])
HL_df =  pd.DataFrame(columns =['Flow',	"Referer",'Request', 'Servercon', 'Clientcon', 'Host',	'Time',	'Ex', 'Domain'])
accidental_HL_df =  pd.DataFrame(columns =['Flow',	"Referer",'Request', 'Servercon', 'Clientcon', 'Host', 'Time',	'Ex', 'Domain'])
SL_df =  pd.DataFrame(columns =['Flow',	"Referer",'Request', 'Servercon', 'Clientcon', 'Host', 'Time', 'Ex', 'Domain'])
exL_df =  pd.DataFrame(columns =['Flow',	"Referer",'Request', 'Servercon', 'Clientcon', 'Host', 'Time', 'Ex', 'Domain'])

# # read the collected logs and other prepared data
workbook = xlrd.open_workbook("HLSLEL_Shopping_new.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Fun.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Newsandweather.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Reading.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Blogging.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Photos.xlsx","rb")
# workbook = xlrd.open_workbook("G:UMD\CIS545\group project\chrome\HLlogs_Productivity.xlsx","rb")
# workbook = xlrd.open_workbook("D:\UMD\CIS545\group project\chrome\history leakage\HLlogs_Video_new.xlsx","rb")

domain = workbook.sheet_by_index(0)
ex_time = workbook.sheet_by_index(1)
all_flow = workbook.sheet_by_index(2)
ex_flow = workbook.sheet_by_index(3)
final_flow = workbook.sheet_by_index(4)
flow = workbook.sheet_by_index(5)   # flow used for statistical analysis

###############################################################################################################################################
###########################################################Network traffic cleaning and analysis###############################################
###############################################################################################################################################

# # select those logs belongs to the extensions and do not contain the domain of the visited URL
# url_df = pd.read_csv("ebay_logs.csv")
# url_list = []
# for i in range(len(url_df)):
#     url_list.append(str(url_df.ix[i, 1]))
# print(len(url_list))
# for j in range(1,all_flow.nrows):
#     rv = all_flow.row_values(j)
#     if str(rv[5]).__contains__("ebay"):
#         pass
#     elif str(rv[2]) not in url_list :
#         cleaned_df.loc[j] = [rv[0], rv[1], rv[2], rv[3], rv[4], rv[5], rv[6]]
# cleaned_df.to_csv("cleaned_df.csv")

# # identify which flow belongs to which extension using recorded time
# for i in range(1,ex_flow.nrows):
#
#     print(i)
#
#     df.loc[i] = 0
#     rv = ex_flow.row_values(i)
#     time = float(rv[7])
#     for j in range(1,ex_time.nrows):
#         rvv = ex_time.row_values(j)
#         start_time = float(rvv[2])
#         end_time = float(rvv[3])
#         if time >= start_time and time <= end_time:
#             df.loc[i] = rvv[1]
# df.to_csv("belongsto_extension.csv")

# # get the domain for the extensions
# for i in range(1,final_flow.nrows):
#     df1.loc[i] = 0
#     rv = final_flow.row_values(i)
#     ex = rv[8]
#     for j in range(1,domain.nrows):
#         rvv = domain.row_values(j)
#         exx = rvv[0]
#         if str(ex).__contains__(exx):
#             df1.loc[i] = [rvv[1]]
# df1.to_csv("domainandhost.csv")


###############################################################################################################################################
##################################################################Statistical analysis#########################################################
###############################################################################################################################################

# # get intentional_HL
# for i in range(1,flow.nrows):
#     print(i)
#     rv = flow.row_values(i)
#     third_host = rv[6]
#     third_host = str(third_host).strip()
#     ex_host = rv[9]
#     ex_host = str(ex_host).strip()
#     if str(third_host).__contains__(rv[9]):
#         pass
#     else:
#         if str(rv[3]).__contains__("ebay") == True:
#             HL_df.loc[i] = [rv[1],rv[2],rv[3],rv[4],rv[5],rv[6],rv[7],rv[8], rv[9]]
# HL_df.to_csv("intentional_HL_df.csv")

# # get accidental_HL
# for i in range(1,flow.nrows):
#     print(i)
#     rv = flow.row_values(i)
#     third_host = rv[6]
#     third_host = str(third_host).strip()
#     ex_host = rv[9]
#     ex_host = str(ex_host).strip()
#     if str(third_host).__contains__(rv[9]):
#         pass
#     else:
#         if str(rv[2]).__contains__("ebay"):
#             accidental_HL_df.loc[i] = [rv[1],rv[2],rv[3],rv[4],rv[5],rv[6],rv[7],rv[8], rv[9]]
# accidental_HL_df.to_csv("accidental_HL_df.csv")

# # get intentional_SL
# for i in range(1,flow.nrows):
#     print(i)
#     rv = flow.row_values(i)
#     third_host = rv[6]
#     third_host = str(third_host).strip()
#     ex_host = rv[9]
#     ex_host = str(ex_host).strip()
#     if str(third_host).__contains__(rv[9]):
#         pass
#     else:
#         # print(rv[2])
#         if str(rv[3]).__contains__("Privacy"):
#             # print(rv[2])
#             SL_df.loc[i] = [rv[1],rv[2],rv[3],rv[4],rv[5],rv[6],rv[7],rv[8], rv[9]]
# SL_df.to_csv("intentional_SL_df.csv")

# # get accidental_SL
# for i in range(1,flow.nrows):
#     print(i)
#     rv = flow.row_values(i)
#     third_host = rv[6]
#     third_host = str(third_host).strip()
#     ex_host = rv[9]
#     ex_host = str(ex_host).strip()
#     if str(third_host).__contains__(rv[9]):
#         pass
#     else:
#         # print(rv[2])
#         if str(rv[2]).__contains__("Privacy"):
#             # print(rv[2])
#             SL_df.loc[i] = [rv[1],rv[2],rv[3],rv[4],rv[5],rv[6],rv[7],rv[8], rv[9]]
# SL_df.to_csv("accidental_SL_df.csv")

# # get intentional_EL
# for i in range(1,flow.nrows):
#     print(i)
#     rv = flow.row_values(i)
#     third_host = rv[6]
#     third_host = str(third_host).strip()
#     ex_host = rv[9]
#     ex_host = str(ex_host).strip()
#     if str(third_host).__contains__(rv[9]):
#         pass
#     else:
#         if str(rv[3]).__contains__("search*.com") or str(rv[2]).__contains__("my*xp.com") or str(rv[2]).__contains__("findizer.fr") or str(rv[2]).__contains__("theweathercenter.co") or str(rv[2]).__contains__("lsmdm.com") or str(rv[2]).__contains__("mixpanel.com"):
#             HL_df.loc[i] = [rv[1],rv[2],rv[3],rv[4],rv[5],rv[6], rv[7],rv[8], rv[9]]
# HL_df.to_csv("intentional_EL_df.csv")

# # calculate the number of third parties by extensions
# HL_df = pd.read_csv("intentional_HL_df.csv")
# HL_df = pd.read_csv("accidental_HL_df.csv")
# HL_df = pd.read_csv("intentional_SL_df.csv")
# HL_df = pd.read_csv("accidental_SL_df.csv")
# group_by_ex = HL_df.groupby('Ex').count()
# group_by_ex.to_csv('group_by_ex_HL.csv')

# # consolidate the #of thrid parity called by extensions finally
# HL_df = pd.read_csv("intentional_HL_df.csv")
# # HL_df = pd.read_csv("accidental_HL_df.csv")
# # HL_df = pd.read_csv("intentional_SL_df.csv")
# # HL_df = pd.read_csv("accidental_SL_df.csv")
# group_by_thrd_host = HL_df.groupby('Host').Ex.nunique()
# group_by_thrd_host.to_csv('group_by_third_parties_host_HL.csv')
