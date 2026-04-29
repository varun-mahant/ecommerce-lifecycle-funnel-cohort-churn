import pandas as pd
import numpy as np

np.random.seed(42)

# Load events
events = pd.read_csv(r"C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\events.csv")
events["event_time"] = pd.to_datetime(events["event_time"])

# Filter purchase events
purchases = events[events["event_type"] == "purchase"].copy()

# Generate transactions data
n = len(purchases)

amount_choices = np.array([299, 499, 799, 1299, 1999, 2499, 3999])
payment_methods = np.array(["UPI", "Card", "Wallet", "NetBanking"])
categories = np.array(["Fashion", "Electronics", "Beauty", "Home"])

transactions = pd.DataFrame({
    "txn_id": np.arange(1, n + 1),
    "event_id": purchases["event_id"].values,
    "user_id": purchases["user_id"].values,
    "txn_time": purchases["event_time"].values,
    "amount": np.random.choice(amount_choices, n),
    "payment_method": np.random.choice(payment_methods, n),
    "product_category": np.random.choice(categories, n)
})

transactions.to_csv("transactions_clean.csv", index=False)

print("Transactions generated:", len(transactions))
