import pandas as pd
import numpy as np

np.random.seed(42)

# Load users

users_df = pd.read_csv("C:\\Users\\Public\\Documents\\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\\users000.csv")
users_df["signup_date"] = pd.to_datetime(users_df["signup_date"])
users_df["last_active_date"] = pd.to_datetime(users_df["last_active_date"])

# Active users 

active_users = users_df.sample(frac=0.82, random_state=42)["user_id"].values

# Generate sessions

sessions = []
session_id = 1

start_date = pd.Timestamp("2025-01-01")
end_date = pd.Timestamp("2025-03-01")

for user in active_users:
    n_sessions = np.random.choice(
        [1, 2, 3, 4, 5],
        p=[0.4, 0.3, 0.15, 0.1, 0.05]
    )
    
    for _ in range(n_sessions):
        session_start = start_date + pd.Timedelta(
            seconds=np.random.randint(0, int((end_date - start_date).total_seconds()))
        )
        
        duration = np.random.randint(5, 60)
        session_end = session_start + pd.Timedelta(minutes=duration)
        
        sessions.append([
            session_id,
            user,
            session_start,
            session_end
        ])
        
        session_id += 1

sessions_df = pd.DataFrame(
    sessions,
    columns=["session_id", "user_id", "session_start", "session_end"]
)

sessions_df.to_csv("sessions.csv", index=False)

print("Sessions generated:", len(sessions_df))
