import pandas as pd
import numpy as np

np.random.seed(42)

# Load sessions

sessions_df = pd.read_csv(r"C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\sessions_final.csv")

sessions_df["session_start"] = pd.to_datetime(sessions_df["session_start"])
sessions_df["session_end"] = pd.to_datetime(sessions_df["session_end"])

events = []
event_id = 1

for _, row in sessions_df.iterrows():

    session_id = row["session_id"]
    user_id = row["user_id"]
    start = row["session_start"]
    end = row["session_end"]

    duration = max(1, int((end - start).total_seconds()))

    viewed = False

    if np.random.rand() < 0.70:
        viewed = True
        t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
        events.append([event_id, session_id, user_id, "view", t])
        event_id += 1

        if np.random.rand() < 0.28:
            t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
            events.append([event_id, session_id, user_id, "product_click", t])
            event_id += 1

            if np.random.rand() < 0.22:
                t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
                events.append([event_id, session_id, user_id, "add_to_cart", t])
                event_id += 1

                if np.random.rand() < 0.32:
                    t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
                    events.append([event_id, session_id, user_id, "checkout", t])
                    event_id += 1

                    if np.random.rand() < 0.28:

                        # repeat purchases (realistic)
                        n_purchases = np.random.choice([1, 2], p=[0.9, 0.1])

                        for _ in range(n_purchases):
                            t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
                            events.append([event_id, session_id, user_id, "purchase", t])
                            event_id += 1

    n_extra_views = np.random.randint(2, 6)  # scale generator

    for _ in range(n_extra_views):
        t = start + pd.Timedelta(seconds=np.random.randint(0, duration))
        events.append([event_id, session_id, user_id, "view", t])
        event_id += 1

events_df = pd.DataFrame(
    events,
    columns=["event_id", "session_id", "user_id", "event_type", "event_time"]
)

events_df.to_csv("events.csv", index=False)

print("Total events:", len(events_df))

print("\nDistinct users per stage:")
print(events_df.groupby("event_type")["user_id"].nunique())

print("\nTotal purchase events:",
      (events_df["event_type"] == "purchase").sum())
