# Data Cleaning
import pandas as pd
import numpy as np

df = pd.read_csv('data\\food_delivery_raw_messy_dataset.csv')
def show(df):
    print(df.head())
    print()
    print(df.tail())
    print()
    print(df.info())
    print()
    print(df.describe(include = 'all'))

show(df)
'''
Used Multi level fallback strategy in Price and Quantity to impute missing values

'''
# ======= Remove duplicates =======
df = df.drop_duplicates(subset = 'Order_ID', keep = 'first')

# ======= City =======
df['City'] = df['City'].fillna(df.groupby('Restaurant')['City'].transform(lambda x: x.mode()[0] if not x.mode().empty else pd.NA))
df['City'] = df['City'].str.lower()

# ======= Date =======
df['Date'] = pd.to_datetime(df['Date'], dayfirst=True,errors='coerce')
'''
previously used this to impute missing values in Date column
df['Date'] = df['Date'].fillna(df.groupby(['Restaurant', 'City'])['Date'].transform(lambda x: x.mode()[0] if not x.mode().empty else pd.NaT))
lambda x: x.mode()[0]
x: a group, x.mode(): mode of the group, 
x.mode()[0]: first value of mode (in case there are multiple modes, we take the first one)

Date imputation is considered dangerous because it creates fake historical events
because it can affect trend analysis, seasonality, forecasting, peak-hour detection

What we are doing is creating a Date Flag
filling a new col Date_Flag with True and False

100% non null data is not necessary, trustworthy data is much more important
some missing values carry information
In real data work: fake data is often worse than missing data
'''
df['Date_Flag'] = df['Date'].isna()
df['Day'] = df['Date'].dt.day.astype('Int64')
df['Month'] = df['Date'].dt.month.astype('Int64')
df['Month_Name'] = df['Date'].dt.month_name()
# print(df.loc[df['Date'].isna(), ['Date', 'Restaurant', 'Food_Item', 'City', 'Price', 'Quantity']]) #149 #11 #0

# ======= Price =======
df['Price'] = pd.to_numeric(df['Price'], errors = 'coerce')
df.loc[df['Price']<=0, 'Price'] = np.nan
df['Price'] = df['Price'].fillna(df.groupby(['Restaurant', 'Food_Item', 'City'])['Price'].transform('mean'))
df['Price'] = df['Price'].fillna(df.groupby(['Food_Item', 'City'])['Price'].transform('mean'))
df['Price'] = df['Price'].round(2)
# print(df.loc[df['Price'].isna(), ['Restaurant', 'Food_Item', 'City', 'Price', 'Quantity']])#2 #0

# ======= Quantity =======
df['Quantity'] = df['Quantity'].replace({
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8
})
df['Quantity'] = pd.to_numeric(df['Quantity'], errors= 'coerce')
df.loc[df['Quantity']<=0, 'Quantity'] = np.nan
df['Quantity'] = df['Quantity'].fillna(df.groupby(['Restaurant', 'Food_Item', 'City'])['Quantity'].transform('mean'))
df['Quantity'] = df['Quantity'].fillna(df.groupby(['Food_Item', 'City'])['Quantity'].transform('mean'))
# print(df.loc[df['Quantity'].isna(), ['Restaurant', 'Food_Item', 'City', 'Price', 'Quantity']])#6 #0
df['Quantity'] = df['Quantity'].round().astype('Int64')

# ======= Revenue =======
df['Revenue'] = df['Price'] * df['Quantity']

# ======= Delivery_Time =======
df['Delivery_Time_Minutes'] = pd.to_numeric(df['Delivery_Time_Minutes'], errors= 'coerce')
df.loc[df['Delivery_Time_Minutes']<=0, 'Delivery_Time_Minutes'] = np.nan
df['Delivery_Time_Minutes'] = df['Delivery_Time_Minutes'].fillna(df.groupby(['Restaurant', 'City'])['Delivery_Time_Minutes'].transform('mean'))

# ======= Customer_Rating =======
df.loc[df['Customer_Rating']<0, 'Customer_Rating'] = np.nan
df.loc[df['Customer_Rating']>5, 'Customer_Rating'] = np.nan
df['Customer_Rating'] = df['Customer_Rating'].fillna(df.groupby(['Restaurant'])['Customer_Rating'].transform('mean'))
df['Customer_Rating'] = df['Customer_Rating'].round(1)

# ======= Payment_Method ======= 
df['Payment_Method'] = df['Payment_Method'].str.strip().str.lower()

print("DataFrame Shape:", df.shape)
show(df)

df.to_csv('data\\cleaned_food_delivery.csv', index = False)