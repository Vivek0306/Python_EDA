import pandas as pd
import numpy as np
fs = pd.Series(list("asdfghjkl"))
print(fs)

ss = pd.Series(np.array(['BOM', 'COK', 'TVM', 'KWT', 'NYK', 'LAX']))
print(ss)

# By default the index will be zero based index, to change index position explicitly
ss = pd.Series(np.array(['BOM', 'COK', 'TVM', 'KWT', 'NYK', 'LAX']), index=[chr(x) for x in range(97, 103)])
print(ss)


city_gdp = {
    'Cities': pd.Series(np.array(['BOM', 'COK', 'TVM', 'KWT', 'JFK', 'LAX'])),
    'GDP': pd.Series(np.random.randint(5000, 10000, 6))
}

city_df = pd.DataFrame(city_gdp)
print(city_df.head()) # Head by default shows the first five rows