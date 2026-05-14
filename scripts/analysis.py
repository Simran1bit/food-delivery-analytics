'''
Questions?:

✅ Restaurant Analytics
Top restaurants by revenue
Highest rated restaurants
Avg delivery time per restaurant

✅ Operational Analytics
Peak order months
Fastest delivery cities
Payment method usage

✅ Customer Experience
Rating vs delivery time
Rating vs city

✅ Revenue Analytics
category revenue
city revenue
restaurant revenue
'''

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('data\\cleaned_food_delivery.csv')

def graph(chart_type, x, y, xlabel, ylabel, title):
    plt.figure(figsize=(6,6))
    if chart_type == "bar":
        plt.bar(x, y)
    elif chart_type == "line":
        plt.plot(x, y, marker='o')
    elif chart_type == "pie":
        plt.pie(y, labels = x, autopct='%1.1f%%')
    
    if chart_type != "pie":
        plt.xlabel(xlabel)
        plt.ylabel(ylabel)
        plt.xticks(rotation=45)
        plt.grid(True, linestyle='--', alpha=0.5)
        plt.gca().set_axisbelow(True) 
    
    plt.title(title)
    plt.tight_layout()
    safe_title = title.lower().replace(" ", "_")
    plt.savefig(f"images\\{safe_title}.png")
    plt.show()

# ======= Restaurant Analytics =======
# 1) Top restaurants by revenue
top_restaurant = df.groupby('Restaurant')['Revenue'].sum().sort_values(ascending = False)
print(f"\n👉 {(top_restaurant).index[0]} is the top restaurant with the highest revenue")

# 2) Highest rated restaurants
# ratings are averages, not cumulative
high_rating_restaurant = df.groupby('Restaurant')['Customer_Rating'].mean().sort_values(ascending=False).index[0]
print(f"\n👉 {high_rating_restaurant} seems to be customer's favorite")

# 3) Avg delivery time per restaurant
avg_delivery_time = df.groupby('Restaurant')['Delivery_Time_Minutes'].mean().round(2)
print(f"\n👉 Average Delivery Time per restaurant is:\n{avg_delivery_time}")
# avg_delivery_time.plot(kind='bar')
graph('bar', avg_delivery_time.index, avg_delivery_time.values, 'Restaurant', 'Average Delivery Time (Minutes)', 'Average Delivery Time per Restaurant')

# ======= Operational Analytics =======
df = df.drop(df[df['Date_Flag'] == True].index)

# 1) Peak order months
'''
sort_values(by = 'Month') is used to sort the DataFrame, but peak_order_month is a Series

reset_index() is used to convert the Series back into a DataFrame and names the count column as Order_Count
sort_values('Order_Count', ascending=False): sorts months by highest orders first
['Month_Name']: selects only month names
.iloc[0]: selects the first month from the sorted list
'''
peak_order_month = df.groupby(['Month', 'Month_Name'])['Order_ID'].count().reset_index(name='Order_Count').sort_values('Month')
print(f"\n👉 Consider running promotions and discounts during {(peak_order_month).sort_values('Order_Count',ascending=False)['Month_Name'].iloc[0]} to attract more customers and boost sales.")
graph("line", peak_order_month['Month_Name'], peak_order_month['Order_Count'], 'Month', 'Number of Orders', 'Number of Orders per Month')

# 2) Fastest delivery cities
fast_delivery_city = df.groupby('City')['Delivery_Time_Minutes'].mean()
print(f"\n👉 The city with fastest delivery is {(fast_delivery_city).sort_values().index[0].capitalize()}")
graph("bar", fast_delivery_city.index, fast_delivery_city.values, 'City', 'Average Delivery Time (Minutes)', 'Average Delivery Time per City')

# 3) Payment method usage
pay_method = df['Payment_Method'].value_counts()
print(f"\n👉 Customers prefer the {(pay_method).index[0].capitalize()} method for payments - keep appropriate checkout options available at reception.")
# value_counts(): returns a Series containing counts of unique values in Descending order. Excludes NA values by default
graph("pie", pay_method.index, pay_method.values, 'Payment Method', 'Number of Orders', 'Payment Method Usage')

# ======= Customer Experience =======
# 1) Rating vs delivery time
'''
groupby('Delivery_Time_Minutes'): creates MANY tiny groups, very granular and not meaningful
instead of 12, 13, 14 minutes, we can create ranges like 0-10, 11-20 etc
pd.cut(): converts continuous numeric data into categories/buckets
pd.cut(df, bins, labels): creates bins based on specified edges and assigns labels to those bins
this is called binning/bucketing or discretization
'''
df['Delivery_Speed'] = pd.cut(df['Delivery_Time_Minutes'], bins = [0,20, 40, 60, 100], labels = ['Fast', 'Moderate', 'Slow', 'Very Slow'])
rat_vs_delivery_time = df.groupby('Delivery_Speed')['Customer_Rating'].mean().round(2)
print(f"\n👉 Customers are more satisfied with faster deliveries, as the average customer rating is higher for shorter delivery times. Consider optimizing delivery processes to reduce delivery times and enhance customer satisfaction.")
graph("bar", rat_vs_delivery_time.index, rat_vs_delivery_time.values, 'Delivery Speed', 'Average Customer Rating', 'Average Customer Rating vs Delivery Speed')

# 2) Rating vs city
rat_vs_city = df.groupby('City')['Customer_Rating'].mean().round(2)
print(f"\n👉 {(rat_vs_city.sort_values(ascending=False).index[0]).capitalize()} customers are more satisfied than {(rat_vs_city.sort_values(ascending=False).index[-1]).capitalize()} customers")
print(f"Consider understanding the reasons behind the poor experience in {(rat_vs_city.sort_values(ascending=False).index[-1]).capitalize()} and understand the underlying issues.")
graph("bar", rat_vs_city.index, rat_vs_city.values, 'City', 'Average Customer Rating', 'Average Customer Rating per City')

# ======= Revenue Analytics =======
# 1) category revenue
category_revenue = df.groupby('Category')['Revenue'].sum()
print(f"\n👉 The category {(category_revenue).sort_values(ascending=False).index[0]} generates the highest revenue")
graph('pie',category_revenue.index, category_revenue.values, 'Category', 'Total Revenue', 'Revenue per Category')

# 2) city revenue
city_revenue = df.groupby('City')['Revenue'].sum()
print(f"\n👉 The city {(city_revenue.sort_values(ascending=False).index[0]).capitalize()} generates the highest revenue - Consider opening new branch here")
graph('bar',city_revenue.index, city_revenue.values, 'City', 'Total Revenue', 'Revenue per City')

# 3) restaurant revenue
restaurant_revenue = df.groupby('Restaurant')['Revenue'].sum()
print(f"\n👉 {(restaurant_revenue.sort_values(ascending=False).index[0])} performs strongly and attracts high customer demand - possibly due to customer preference, pricing, delivery experience, or menu popularity.")
graph('bar', restaurant_revenue.index, restaurant_revenue.values, 'Restaurant', 'Total Revenue', 'Revenue per Restaurant')
