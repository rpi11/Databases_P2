import pandas as pd

def read(file):
    with open(file, "r") as f:
        return pd.read_csv(f)
    
companies = read("companies.csv")
emissions = read("emissions.csv")
stocks = read("stocks.csv")

stocks["Date"] = pd.to_datetime(stocks["Date"])
stocks["year"] = stocks["Date"].dt.year

codes = []
delta_close = []
high = []
low = []
years = []
for code in stocks["Company"].unique():
    for year in stocks[stocks["Company"] == code]["year"].unique():
        temp = stocks[(stocks["Company"] == code) & (stocks["year"] == year)].sort_values(by = "Date")
        h = max(temp["High"])
        l = max(temp["Low"])
        dc = float(temp["Close/Last"].iloc[-1][1:]) - float(temp["Close/Last"].iloc[0][1:])

        codes.append(code)
        years.append(year)
        delta_close.append(dc)
        high.append(h)
        low.append(l)


stocks = pd.DataFrame({
    "company":codes,
    "year":years,
    "change_in_close":delta_close,
    "high":high,
    "low":low
})

stocks_companies = pd.merge(stocks, companies, left_on = "company", right_on = "Stock Name",
                            how = "inner").drop(columns = "Stock Name").rename(columns = {
                                "HQ State" : "state",
                                "Founding Year" : "founded",
                                "Annual Revenue 2022-2023 (USD in Billions)" : "revenue_22_23_e9",
                                "Market Cap (USD in Trillions)" : "market_cap_e12",
                                "Company Name" : "name",
                                "Annual Income Tax in 2022-2023 (USD in Billions)" : "income_tax_22_23_e9",
                                "Employee Size" : "emp_num"
                            })

emissions = emissions[emissions.columns[:-4]].melt(id_vars = "State", var_name='year', 
                                                   value_name='emissions_per_cap').rename(columns = {"State":"state"})

emissions["year"] = pd.to_numeric(emissions["year"])

emissions_stocks_companies = pd.merge(stocks_companies, emissions,
                                      on = ["state","year"], how = "inner")

with open("combined.csv", "w+") as o:
    emissions_stocks_companies.to_csv(o, index=False)