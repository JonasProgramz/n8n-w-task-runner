# Pandas Code Examples for n8n

## Example 1: Simple Data Transformation

```python
import pandas as pd

# Get input data from previous node
input_data = $input.all()

# Convert to DataFrame
df = pd.DataFrame([item['json'] for item in input_data])

# Example transformations
df['full_name'] = df['first_name'] + ' ' + df['last_name']
df['email_domain'] = df['email'].str.split('@').str[1]
df['created_date'] = pd.to_datetime(df['created_at'])

# Filter and sort
df = df[df['age'] > 18].sort_values('created_date', ascending=False)

# Return as list of dicts
return df.to_dict('records')
```

## Example 2: Sales Data Analysis (from workflow)

```python
import pandas as pd
import numpy as np

# Sample sales data
data = {
    'date': pd.date_range(start='2024-01-01', periods=30, freq='D'),
    'product': np.random.choice(['Laptop', 'Phone', 'Tablet', 'Monitor'], 30),
    'quantity': np.random.randint(1, 10, 30),
    'price': np.random.choice([999, 799, 499, 299], 30),
    'region': np.random.choice(['North', 'South', 'East', 'West'], 30)
}

df = pd.DataFrame(data)
df['total_sales'] = df['quantity'] * df['price']

# Group by product
product_summary = df.groupby('product').agg({
    'quantity': 'sum',
    'total_sales': 'sum'
}).reset_index()

return product_summary.to_dict('records')
```

## Example 3: Data Cleaning

```python
import pandas as pd

# Get messy data
df = pd.DataFrame($input.all())

# Remove duplicates
df = df.drop_duplicates(subset=['email'])

# Handle missing values
df['phone'] = df['phone'].fillna('N/A')
df['age'] = df['age'].fillna(df['age'].mean())

# Clean text fields
df['name'] = df['name'].str.strip().str.title()
df['email'] = df['email'].str.lower()

# Remove rows with critical missing data
df = df.dropna(subset=['email', 'name'])

return {
    'cleaned_data': df.to_dict('records'),
    'records_processed': len($input.all()),
    'records_after_cleaning': len(df),
    'duplicates_removed': len($input.all()) - len(df)
}
```

## Example 4: Time Series Analysis

```python
import pandas as pd

# Load time-series data
df = pd.DataFrame($input.all())
df['timestamp'] = pd.to_datetime(df['timestamp'])
df = df.set_index('timestamp')

# Resample to daily averages
daily_avg = df.resample('D')['value'].mean()

# Calculate rolling statistics
df['rolling_avg_7d'] = df['value'].rolling(window=7).mean()
df['rolling_std_7d'] = df['value'].rolling(window=7).std()

# Detect anomalies (values > 2 std devs from mean)
mean = df['value'].mean()
std = df['value'].std()
df['is_anomaly'] = abs(df['value'] - mean) > (2 * std)

anomalies = df[df['is_anomaly']]

return {
    'daily_averages': daily_avg.reset_index().to_dict('records'),
    'anomalies_detected': len(anomalies),
    'anomaly_details': anomalies.reset_index().to_dict('records')
}
```

## Example 5: CSV Processing

```python
import pandas as pd
from io import StringIO

# Read CSV from input (assuming CSV string in 'content' field)
csv_content = $input.first()['json']['content']
df = pd.read_csv(StringIO(csv_content))

# Process the data
summary = {
    'total_rows': len(df),
    'columns': list(df.columns),
    'numeric_summary': df.describe().to_dict(),
    'missing_values': df.isnull().sum().to_dict(),
    'data_sample': df.head(5).to_dict('records')
}

return summary
```

## Tips for Using Pandas in n8n

1. **Import pandas**: Always start with `import pandas as pd`
2. **Return dictionaries**: Use `.to_dict('records')` to convert DataFrames back to n8n format
3. **Handle dates**: Use `pd.to_datetime()` for date parsing
4. **Memory efficient**: For large datasets, process in chunks
5. **Error handling**: Wrap operations in try/except blocks for production workflows
6. **Data validation**: Check data types and missing values before processing

## Available Packages (from your config)

Based on your `n8n-task-runners.json`:
- ✅ numpy
- ✅ pandas
- ✅ pillow (PIL)
- ✅ piexif
- ✅ exifread
- ✅ fpdf2
