
import time
import xlrd
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.proxy import Proxy, ProxyType
import pandas as pd

df = pd.DataFrame(columns=['extension', 'start_time', 'end_time'])  # create a dataframe to store recorded time for each networl flow
# read the prepared extentions
workbook = xlrd.open_workbook("Extensions.xlsx", "rb")
ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")
# ex_df = workbook.sheet_by_name("Shopping")


PROXY = "127.0.0.1:8080"
path = '/home/xiao/Downloads/Google_Chrome_Extensions/'

# install the extensions and visit the prepared URL and search query on that website automatically
for i in range(ex_df.nrows):

    options = Options()
    options.add_argument('--proxy-server=%s' % PROXY)

    rv = ex_df.row_values(i)
    ex = rv[0]
    expath = path + rv[0]
    print(expath)

    options.add_extension(expath)
    driver = webdriver.Chrome('./chromedriver', options=options)
    exurl = rv[1]
    start_time = time.time() * 1000

    try:

        # shopping extensions
        driver.get('https://www.ebay.com/');
        search = driver.find_element_by_id('gh-ac')
        search.send_keys('Security and Privacy')
        driver.find_element_by_id("gh-btn").click()
        # driver.close()
        # driver.quit()

    except Exception :
        print("error with" + expath)
        # driver.close()
        driver.quit()

    # time.sleep(0.1) # Let the user actually see something!
    # driver.close()
    driver.quit()
    end_time = time.time() * 1000
    df.loc[i] = [ex, start_time, end_time]

# write the recorded time and extensions to a csv file
df.to_csv('History_Leakage_Traffice_Time.csv')