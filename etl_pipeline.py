import time
import pandas as pd
from sqlalchemy import create_engine

start_time = time.time()

print("1. Extracting data from Docker Postgres...")
engine = create_engine("postgresql://de_admin:secretpassword@localhost:5433/de_warehouse")
df_raw = pd.read_sql("SELECT user_id, category, amount, created_at FROM transactions", engine)

print("2. Transforming data with Pandas...")

user_agg = df_raw.groupby('user_id').agg(
    total_spent=('amount', 'sum'),
    total_orders=('amount', 'count'),
    first_transaction=('created_at', 'min'),
    last_transaction=('created_at', 'max')
).reset_index()

cat_spent = df_raw.groupby(['user_id', 'category'])['amount'].sum().reset_index()
cat_spent_sorted = cat_spent.sort_values(['user_id', 'amount'], ascending=[True, False])
fav_cat = cat_spent_sorted.drop_duplicates(subset=['user_id'])[['user_id', 'category']].rename(columns={'category': 'favorite_category'})

df_final = pd.merge(user_agg, fav_cat, on='user_id')

def get_tier(spent):
    if spent >= 1500:
        return 'Platinum'
    elif spent >= 800:
        return 'Gold'
    return 'Regular'

df_final['user_tier'] = df_final['total_spent'].apply(get_tier)

print("3. Loading transformed data back to Postgres...")
df_final.to_sql('user_analytics_py_mart', engine, if_exists='replace', index=False)

execution_time = time.time() - start_time
print(f"--- ETL Process Completed in {execution_time:.2f} seconds! ---")