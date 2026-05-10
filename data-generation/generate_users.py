import pandas as pd
import numpy as np
from faker import Faker

fake = Faker()
np.random.seed(42)

n_users = 100_000

print("Generating users")

# user ids
user_ids = np.arange(1, n_users + 1)

# signup dates
start_date = pd.Timestamp("2024-04-01")
end_date = pd.Timestamp("2026-04-01")

signup_dates = start_date + pd.to_timedelta(np.random.randint(0, (end_date - start_date).days, n_users), unit="D")

# country distribution
countries = np.random.choice(["India", "USA", "UK", "Canada", "Germany", "Australia"], size=n_users, p=[0.4, 0.2, 0.1, 0.1, 0.1, 0.1])

# device split
devices = np.random.choice(["Mobile", "Desktop", "Tablet"], size=n_users, p=[0.65, 0.25, 0.10])

# acquisition channels
channels = np.random.choice(["Organic", "Paid Ads", "Social", "Referral", "Email"], size=n_users, p=[0.35, 0.25, 0.2, 0.1, 0.1])

# premium users
is_premium = np.random.choice([False, True], size=n_users, p=[0.85, 0.15])

# activity behavior

# base activity
activity_span = np.random.randint(7, 180, n_users)

# some users churn very early
early_churn = np.random.choice([0, 1], size=n_users, p=[0.9, 0.1])
activity_span = np.where(early_churn == 1, np.random.randint(1, 6, n_users), activity_span)

# premium users tend to stay longer
activity_span += is_premium.astype(int) * np.random.randint(30, 150, n_users)

# power users
power_users = np.random.choice([0, 1], size=n_users, p=[0.85, 0.15])
activity_span = np.where(power_users == 1, activity_span + np.random.randint(100, 300, n_users), activity_span)

# last active date 
last_active_dates = signup_dates + pd.to_timedelta(activity_span, unit="D")

# avoid everyone hitting exact end_date 
end_noise = np.random.randint(0, 30, n_users)
adjusted_end = end_date - pd.to_timedelta(end_noise, unit="D")

last_active_dates = np.minimum(last_active_dates, adjusted_end)
last_active_dates = np.maximum(last_active_dates, signup_dates)


# dataframe
users_df = pd.DataFrame({"user_id": user_ids, "signup_date": signup_dates, "country": countries, "device": devices, "acquisition_channel": channels,
    "is_premium": is_premium,
    "last_active_date": last_active_dates
})

# format dates
users_df["signup_date"] = users_df["signup_date"].dt.strftime("%Y-%m-%d")
users_df["last_active_date"] = users_df["last_active_date"].dt.strftime("%Y-%m-%d")

# save
users_df.to_csv("users000.csv", index=False)

print("Users dataset ready")
