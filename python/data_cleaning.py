"""Reusable data preparation pipeline for the Superstore retail analytics project."""
from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parents[1]
RAW_PATH = BASE_DIR / "data" / "raw" / "superstore.csv"
OUTPUT_DIR = BASE_DIR / "data" / "processed"
OUTPUT_PATH = OUTPUT_DIR / "superstore_cleaned.csv"

RENAME_MAP = {
    "Row ID": "row_id", "Order ID": "order_id", "Order Date": "order_date",
    "Ship Date": "ship_date", "Ship Mode": "ship_mode", "Customer ID": "customer_id",
    "Customer Name": "customer_name", "Segment": "segment", "Country/Region": "country_region",
    "City": "city", "State/Province": "state_province", "Postal Code": "postal_code",
    "Region": "region", "Product ID": "product_id", "Category": "category",
    "Sub-Category": "sub_category", "Product Name": "product_name", "Sales": "sales",
    "Quantity": "quantity", "Discount": "discount", "Profit": "profit",
}


def clean_superstore(input_path=RAW_PATH, output_path=OUTPUT_PATH):
    df = pd.read_csv(input_path)
    df = df.rename(columns=RENAME_MAP)
    df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
    df["ship_date"] = pd.to_datetime(df["ship_date"], errors="coerce")

    numeric_cols = ["sales", "quantity", "discount", "profit", "postal_code"]
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    # Remove exact duplicate records and rows missing critical analytical fields.
    df = df.drop_duplicates().copy()
    critical = ["order_id", "order_date", "product_id", "sales", "quantity", "profit"]
    df = df.dropna(subset=critical).copy()

    # Derived analytical fields used by the notebook and dashboard.
    df["ship_days"] = (df["ship_date"] - df["order_date"]).dt.days
    df["order_year"] = df["order_date"].dt.year
    df["order_month"] = df["order_date"].dt.month
    df["month_name"] = df["order_date"].dt.strftime("%b")
    df["year_month"] = df["order_date"].dt.to_period("M").astype(str)
    df["profit_margin"] = df["profit"].div(df["sales"].replace(0, pd.NA)).fillna(0)
    df["sales_per_unit"] = df["sales"].div(df["quantity"].replace(0, pd.NA)).fillna(0)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_path, index=False)
    return df


if __name__ == "__main__":
    cleaned = clean_superstore()
    print(f"Saved {len(cleaned):,} rows to {OUTPUT_PATH}")
