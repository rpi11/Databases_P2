import pandas as pd
with open("combined.csv", "r") as f:
    df = pd.read_csv(f)
    
tabs = {
    "name_to_code":{
        "columns":["company","name"],
        "key":["name"]
    },
    "company_info":{
        "columns":["name","revenue_22_23_e9","market_cap_e12","emp_num",
                   "founded","income_tax_22_23_e9","Sector","state"],
        "key":["name"]
    },
    "stock_info":{
        "columns":["company","year","change_in_close"],
        "key":["company","year"]
    },
    "emissions_info":{
        "columns":["state","year","emissions_per_cap"],
        "key":["state","year"]
    }
}

for name in tabs:
    outDf = df[tabs[name]["columns"]].drop_duplicates(tabs[name]["key"])
    with open(f"3NF/{name}.csv", "w+") as o:
        outDf.to_csv(o, index=False)

