
# Heroes Of Pymoli Data Analysis

1. One of the most significant demographics to purchase items in-game are males with ages ranging from 20 to 24.
2. Males also account for over 81% of in-game purchases.
3. The top 5 items that bring in the most revenue account for less than 7% of total revenue from item purchases. 


```python
# Environment Setup
# ----------------------------------------------------------------
# Dependencies
import csv
import pandas as pd
import random
import numpy as np

# Output File Name
file_output_purchases_json = "generated_data/purchase_data.json"
```

# Total Number of Players 


```python
players = pd.read_json(file_output_purchases_json)
unique_players = players["SN"].unique()
total_unique_players = len(unique_players)
players_total_dict = [{"Total Players": total_unique_players}]
total_players_summary = pd.DataFrame(players_total_dict)
total_players_summary
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



 # Purchasing Analysis (Total)


```python
purchase_df = pd.read_json(file_output_purchases_json)
#Number of unique items purhcased
unique_item_count = len(purchase_df["Item ID"].unique())
#Average purchase price
average_item_price = purchase_df["Price"].mean()
#Total number of purchases 
total_purchases = len(purchase_df)
#Total revenue
total_purchase_rev = purchase_df["Price"].sum()
#Purchasing analysis table
purchasing_analysis = pd.DataFrame({"Number of Unique Items": unique_item_count,
                        "Average Price": average_item_price,
                        "Number of Purchases": total_purchases,
                        "Total Revenue": [total_purchase_rev],
})
#Organizing and formatting analysis 
organized_pur_ana = purchasing_analysis[["Number of Unique Items", "Average Price", "Number of Purchases", "Total Revenue"]]
organized_pur_ana["Average Price"] = organized_pur_ana["Average Price"].map("${:.2f}".format)
organized_pur_ana["Total Revenue"] = organized_pur_ana["Total Revenue"].map("${:.2f}".format)
organized_pur_ana


```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$2.93</td>
      <td>780</td>
      <td>$2286.33</td>
    </tr>
  </tbody>
</table>
</div>



# Gender Demographics


```python
player_gender_df = pd.read_json(file_output_purchases_json)
no_dupe_players = player_gender_df.drop_duplicates("SN")
number_in_set = len(no_dupe_players)
gender_count_raw = no_dupe_players["Gender"].value_counts()
per_gender = ((gender_count_raw / number_in_set)*100)
#Summmary table for gender demographics
gender_summary = pd.DataFrame({"Percentage of players": round(per_gender,2),
                   "Total Count": gender_count_raw
})
gender_summary
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>81.15</td>
      <td>465</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>1.40</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>



# Purchasing Analysis (Gender)


```python
grouped_gender_df = purchase_df.groupby(["Gender"])
purchases_count = grouped_gender_df["Item ID"].count()
avg_gen_pur = grouped_gender_df["Price"].mean()
total_gen_pur = grouped_gender_df["Price"].sum()
drop_gender_df = purchase_df.drop_duplicates(["SN"])
gen_pur_norm = total_gen_pur/drop_gender_df["Gender"].value_counts()
purchasing_gen_df = pd.DataFrame({"Purchase Count": purchases_count,
                                  "Average Purchase Price": avg_gen_pur,
                                  "Total Purchase Value": total_gen_pur,
                                  "Normalized Totals": gen_pur_norm
                                })
purchasing_gen_df["Average Purchase Price"] = purchasing_gen_df["Average Purchase Price"].map("${:.2f}".format)
purchasing_gen_df["Total Purchase Value"] = purchasing_gen_df["Total Purchase Value"].map("${:.2f}".format)
purchasing_gen_df["Normalized Totals"] = purchasing_gen_df["Normalized Totals"].map("${:.2f}".format)
purchasing_gen_org = purchasing_gen_df[["Purchase Count", "Average Purchase Price", "Total Purchase Value", "Normalized Totals"]]
purchasing_gen_org
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>$2.82</td>
      <td>$382.91</td>
      <td>$3.83</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>$2.95</td>
      <td>$1867.68</td>
      <td>$4.02</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>$3.25</td>
      <td>$35.74</td>
      <td>$4.47</td>
    </tr>
  </tbody>
</table>
</div>



# Purchasing Analysis (Age)


```python
age_demo_df = purchase_df.groupby(["Age"])
age_bins = [0, 9, 14, 19, 24, 29, 34, 39, 100]
age_labels = ["< 10", "10-14","15-19","20-24","25-29","30-34","35-39","40+"]
#Put players into bins based on their age
purchase_df["Age Group"] = pd.cut(purchase_df["Age"],age_bins,labels=age_labels)
age_group = purchase_df.groupby("Age Group")
age_group_total = age_group.count()
age_count = age_group["Age"].count()
age_total = age_group["Price"].sum()
age_avg = age_total / age_count
dupe_age = purchase_df.drop_duplicates(["SN"])
age_pur_norm = age_total/(dupe_age["Age Group"].value_counts())
age_group_analysis = pd.DataFrame({"Purchase Count": age_count,
                                   "Average Purchase Price": age_avg,
                                   "Total Purchase Value": age_total,
                                   "Normalized Totals": age_pur_norm
                                    })
age_group_analysis = age_group_analysis[["Purchase Count","Average Purchase Price","Total Purchase Value","Normalized Totals"]]
age_group_analysis["Average Purchase Price"] = age_group_analysis["Average Purchase Price"].map("${:.2f}".format)
age_group_analysis["Normalized Totals"] = age_group_analysis["Normalized Totals"].map("${:.2f}".format)
age_group_analysis["Total Purchase Value"] = age_group_analysis["Total Purchase Value"].map("${:.2f}".format)
age_group_analysis
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10-14</th>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
      <td>$4.22</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
      <td>$3.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>336</td>
      <td>$2.91</td>
      <td>$978.77</td>
      <td>$3.78</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>125</td>
      <td>$2.96</td>
      <td>$370.33</td>
      <td>$4.26</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>64</td>
      <td>$3.08</td>
      <td>$197.25</td>
      <td>$4.20</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>42</td>
      <td>$2.84</td>
      <td>$119.40</td>
      <td>$4.42</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>17</td>
      <td>$3.16</td>
      <td>$53.75</td>
      <td>$4.89</td>
    </tr>
    <tr>
      <th>&lt; 10</th>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
      <td>$4.39</td>
    </tr>
  </tbody>
</table>
</div>



# Top Spenders


```python
spenders_df = purchase_df.groupby(["SN"])
spender_count = spenders_df["Item Name"].count()
spender_total = spenders_df["Price"].sum()
spender_avg = spender_total / spender_count
top_spenders_df = pd.DataFrame({"Total Purchases": spender_count,
                    "Average Purchase Value": spender_avg,
                    "Total Purchase Value": spender_total})
spenders_analysis = top_spenders_df[["Total Purchases","Average Purchase Value", "Total Purchase Value"]]
spenders_analysis = spenders_analysis.sort_values(by = "Total Purchase Value", ascending = False)
spenders_analysis["Average Purchase Value"] = spenders_analysis["Average Purchase Value"].map("${:.2f}".format)
spenders_analysis["Total Purchase Value"] = spenders_analysis["Total Purchase Value"].map("${:.2f}".format)
spenders_analysis.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Purchases</th>
      <th>Average Purchase Value</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Undirrala66</th>
      <td>5</td>
      <td>$3.41</td>
      <td>$17.06</td>
    </tr>
    <tr>
      <th>Saedue76</th>
      <td>4</td>
      <td>$3.39</td>
      <td>$13.56</td>
    </tr>
    <tr>
      <th>Mindimnya67</th>
      <td>4</td>
      <td>$3.18</td>
      <td>$12.74</td>
    </tr>
    <tr>
      <th>Haellysu29</th>
      <td>3</td>
      <td>$4.24</td>
      <td>$12.73</td>
    </tr>
    <tr>
      <th>Eoda93</th>
      <td>3</td>
      <td>$3.86</td>
      <td>$11.58</td>
    </tr>
  </tbody>
</table>
</div>



# Most Popular Items


```python
items_df = purchase_df.groupby(["Item ID", "Item Name"])
item_purchase_count = items_df["Item ID"].count()
item_price = items_df["Price"].unique()
item_purchase_total = items_df["Price"].sum()
items_analysis = pd.DataFrame({"Purchase Count": item_purchase_count,
                               "Item Price": item_price.str.get(0),
                               "Total Purchase Value": item_purchase_total
                              })
items_analysis = items_analysis.sort_values(by = "Purchase Count",ascending = False)
#items_analysis = items_analysis[["Purchase Count", "Item Price", "Total Purchase Value"]]
items_analysis["Total Purchase Value"] = items_analysis["Total Purchase Value"].map("${:.2f}".format)
items_analysis["Item Price"] = items_analysis["Item Price"].map("${:.2f}".format)
popular_five = items_analysis.nlargest(5,"Purchase Count")
popular_five
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Item Price</th>
      <th>Purchase Count</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>39</th>
      <th>Betrayal, Whisper of Grieving Widows</th>
      <td>$2.35</td>
      <td>11</td>
      <td>$25.85</td>
    </tr>
    <tr>
      <th>84</th>
      <th>Arcane Gem</th>
      <td>$2.23</td>
      <td>11</td>
      <td>$24.53</td>
    </tr>
    <tr>
      <th>31</th>
      <th>Trickster</th>
      <td>$2.07</td>
      <td>9</td>
      <td>$18.63</td>
    </tr>
    <tr>
      <th>175</th>
      <th>Woeful Adamantite Claymore</th>
      <td>$1.24</td>
      <td>9</td>
      <td>$11.16</td>
    </tr>
    <tr>
      <th>13</th>
      <th>Serenity</th>
      <td>$1.49</td>
      <td>9</td>
      <td>$13.41</td>
    </tr>
  </tbody>
</table>
</div>



# Most Profitable Items


```python
item_id_df = purchase_df.groupby(["Item ID", "Item Name"])
item_purchase_count = item_id_df["Item ID"].count()
item_price = item_id_df["Price"].unique()
item_purchase_total = item_id_df["Price"].sum()
item_id_analysis = pd.DataFrame({"Purchase Count": item_purchase_count,
                               "Item Price": item_price.str.get(0),
                               "Total Purchase Value": item_purchase_total
                              })
profitable_five_temp = item_id_analysis.nlargest(5,"Total Purchase Value")
profitable_five_temp["Total Purchase Value"] = profitable_five_temp["Total Purchase Value"].map("${:.2f}".format)
profitable_five_temp["Item Price"] = profitable_five_temp["Item Price"].map("${:.2f}".format)
profitable_five_temp
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Item Price</th>
      <th>Purchase Count</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>$4.14</td>
      <td>9</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>115</th>
      <th>Spectral Diamond Doomblade</th>
      <td>$4.25</td>
      <td>7</td>
      <td>$29.75</td>
    </tr>
    <tr>
      <th>32</th>
      <th>Orenmir</th>
      <td>$4.95</td>
      <td>6</td>
      <td>$29.70</td>
    </tr>
    <tr>
      <th>103</th>
      <th>Singed Scalpel</th>
      <td>$4.87</td>
      <td>6</td>
      <td>$29.22</td>
    </tr>
    <tr>
      <th>107</th>
      <th>Splitter, Foe Of Subtlety</th>
      <td>$3.61</td>
      <td>8</td>
      <td>$28.88</td>
    </tr>
  </tbody>
</table>
</div>


